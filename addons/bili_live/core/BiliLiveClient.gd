## 实现与官方服务器进行长连
class_name BiliLiveClient
extends Node

## 连接成功并鉴权通过时触发
signal connected
## 连接断开时触发
signal disconnected

## 长连服务推送直播间数据时触发
signal live_data(data: Dictionary)

## 直播间有人发送弹幕时触发
signal live_dm(data: BiliLiveDm)
## 当该直播间为支持跨房弹幕的直播间模式，其他直播间有人发送弹幕时触发
signal live_dm_mirror(data: BiliLiveDmMirror)
## 当该直播间有人赠送礼物时触发
signal live_send_gift(data: BiliLiveSendGift)
## 当该直播间有人发送付费留言时触发
signal live_super_chat(data: BiliLiveSuperChat)
## 当该直播间有付费留言被下线时触发
signal live_super_chat_del(data: BiliLiveSuperChatDel)
## 当该直播间有人上舰时触发
signal live_guard(data: BiliLiveGuard)
## 该直播间有用户在移动端双击直播画面点赞时触发
signal live_like(data: BiliLiveLike)
## 该直播间有观众进入直播间时触发
signal live_room_enter(data: BiliLiveRoomEnter)
## 该直播间开始直播时触发
signal live_live_start(data: BiliLiveLiveStart)
## 该直播间停止直播时触发
signal live_live_end(data: BiliLiveLiveEnd)
## 当目前长连接停止推送时触发
signal live_interaction_end(data: BiliLiveInteractionEnd)

## 认证配置
@export var config: BiliLiveConfig
## 如果为 true，则当前节点会在进入场景树时自动连接
@export var auto_connect: bool = false
## 如果为 true，则打印日志
@export var print_log: bool = true

# 内部状态
var _ws := WebSocketPeer.new()
var _http: HTTPRequest
var _game_id: String = ""
var _ws_connected: bool = false
var _is_authenticated: bool = false
var _crypto := Crypto.new()

# 计时器
var _ws_heartbeat_timer: float = 0.0
var _app_heartbeat_timer: float = 0.0

## 错误码映射表，文档地址：https://open-live.bilibili.com/document/74eec767-e594-7ddd-6aba-257e8317c05d
const ERROR_MAP = {
	4000: "参数错误：请检查必填参数，参数大小限制",
	4001: "应用无效：请检查header的x-bili-accesskeyid是否为空，或者有效",
	4002: "签名异常：请检查header的Authorization",
	4003: "请求过期：请检查header的x-bili-timestamp",
	4004: "重复请求：请检查header的x-bili-nonce",
	4005: "签名方法异常：请检查header的x-bili-signature-method，目前仅支持 HMAC-SHA256",
	4006: "版本异常：请检查header的x-bili-version",
	4007: "IP白名单限制：请确认请求服务器是否在报备的白名单内",
	4008: "权限异常：请确认接口权限",
	4009: "接口访问限制：请确认接口权限及请求频率",
	4010: "接口不存在：请确认请求接口url",
	4011: "Content-Type 错误：必须为 application/json",
	4012: "MD5 校验失败：Body 内容与 x-bili-content-md5 不符",
	4013: "Accept 错误：必须为 application/json",
	5000: "服务异常：请联系B站对接同学",
	5001: "请求超时：请联系B站对接同学",
	5002: "请求超时：请联系B站对接同学",
	5003: "配置错误：请联系B站对接同学",
	5004: "房间白名单限制：未上架的应用，只能连接开发者自己的直播间，如果已上架还提示，请联系B站对接同学",
	5005: "房间黑名单限制：请联系B站对接同学",
	5011: "应用权限限制：应用存在黑白名单限制，默认未上架应用只允许开发者自己连接，如已上架且提醒该问题，请联系B站对接同学",
	6000: "验证码错误：验证码校验失败",
	6001: "手机号码错误：检查手机号码",
	6002: "验证码已过期：验证码超过规定有效期",
	6003: "验证码频率限制：检查获取验证码的频率",
	6010: "房间号不能为空：房间号不能为空",
	6011: "没有查询到房间：没有查询到房间",
	6012: "主播信息为空：主播信息为空",
	6013: "互玩游戏关闭失败：互玩游戏关闭失败",
	6014: "插件关闭失败：插件关闭失败",
	6015: "直播工具关闭失败：直播工具关闭失败",
	7000: "不在游戏内：当前房间未进行互动游戏",
	7001: "请求冷却期：上个游戏正在结算中，建议10秒后进行重试",
	7002: "房间重复游戏：当前房间正在进行游戏，无法开启下一局互动游戏",
	7003: "心跳过期：当前 game_id 错误或互动游戏已关闭",
	7004: "批量心跳超过最大值：批量心跳单次最大值为200",
	7005: "批量心跳ID重复：批量心跳game_id存在重复,请检查参数",
	7007: "身份码错误：请检查身份码是否正确",
	7008: "插件重复开启：插件重复开启",
	7009: "无道具投放权限：无道具投放权限",
	7010: "超过上限，同一个应用单个直播间最多同时打开5个：单个直播间对于同一个插件/工具最多能启动5个连接，请检查start和心跳维持数量",
	8002: "项目无权限访问：确认项目ID是否正确",
}


func _ready() -> void:
	_http = HTTPRequest.new()
	add_child(_http)

	if auto_connect and config:
		start()


func _process(delta: float) -> void:
	_ws.poll()
	var state := _ws.get_ready_state()

	if state == WebSocketPeer.STATE_OPEN:
		if not _ws_connected:
			_ws_connected = true

		# 读取所有包
		while _ws.get_available_packet_count() > 0:
			var packet_data := _ws.get_packet()
			_process_packet_data(packet_data)

		# 心跳逻辑
		if _is_authenticated:
			_ws_heartbeat_timer -= delta
			if _ws_heartbeat_timer <= 0:
				_send_ws_heartbeat()
				_ws_heartbeat_timer = config.ws_heartbeat_interval

	elif state == WebSocketPeer.STATE_CLOSED and _ws_connected:
		_ws_connected = false
		_is_authenticated = false
		emit_signal("disconnected")
		_log("ws被动断连. Code: %d" % _ws.get_close_code(), 1)
		# Todo: 可以在这里添加自动重连逻辑

	# App 维持心跳
	if not _game_id.is_empty():
		_app_heartbeat_timer -= delta
		if _app_heartbeat_timer <= 0:
			_send_app_heartbeat()
			_app_heartbeat_timer = config.app_heartbeat_interval


func start() -> void:
	if _verify_identity():
		var data := await _app_start()
		_ws_start(data)


func stop() -> void:
	_app_end()
	_ws_end()


## 获取可读的错误请求说明信息
static func get_error_detaile(code: int) -> String:
	return ERROR_MAP.get(code, "未知API错误 (Code: %d)" % code)


func _verify_identity() -> bool:
	if not config:
		_log("缺少身份验证配置", 1)
		return false
	if config.id_code == "":
		_log("请填写主播身份码", 1)
		return false
	if config.access_key_id == "":
		_log("请填写开发者 Access Key", 1)
		return false
	if config.access_key_secret == "":
		_log("请填写开发者 Secret Key", 1)
		return false

	return true


func _app_start() -> Dictionary:
	_log("正在开启互动玩法...")

	# 1. 开启项目 (App Start)
	var start_res := await _api_request("/v2/app/start", {"code": config.id_code, "app_id": config.app_id})
	var success: bool = start_res.success
	var data: Dictionary = start_res.data

	if not success:
		_log("开启互动玩法失败", 1)
		return start_res

	_game_id = data.get("game_info", {}).get("game_id", "")
	_log("开启互动玩法成功(game_id: {0})".format([_game_id]))
	return start_res


func _app_end() -> void:
	if not _game_id.is_empty():
		_log("关闭互动玩法")
		# 异步发送，不等待
		_api_request("/v2/app/end", {"game_id": _game_id, "app_id": config.app_id})
		_game_id = ""


func _ws_start(payload: Dictionary) -> void:
	var is_app_start_success: bool = payload.success
	if not is_app_start_success:
		return

	var data: Dictionary = payload.data
	var websocket_info: Dictionary = data.get("websocket_info", {})
	var wss_links: Array = websocket_info.get("wss_link", [])
	var auth_body: String = websocket_info.get("auth_body", "")

	await _ws_failover_cluster_connector(wss_links, auth_body)


func _ws_end() -> void:
	if _ws.get_ready_state() == WebSocketPeer.STATE_OPEN:
		_ws_connected = false
		_is_authenticated = false
		_ws.close()
		emit_signal("disconnected")
		_log("ws已安全关闭")


# --- 内部逻辑 ---


# 连接ws，失败后切换集群
func _ws_failover_cluster_connector(wss_links: Array, auth_body: String) -> void:
	for i in range(wss_links.size()):
		var url: String = wss_links[i]
		_log("尝试连接ws集群 [%d/%d]: %s" % [i + 1, wss_links.size(), url])

		var success := await _connect_to_ws(url, auth_body)
		if success:
			_log("ws连接成功，当前集群: %s" % url)
			return
		else:
			_log("ws集群连接失败，切换下一个", 1)

	_log("所有ws集群均连接失败", 1)


func _connect_to_ws(url: String, auth_body: String) -> bool:
	_ws.close()

	var err := _ws.connect_to_url(url)
	if err != OK:
		_log("无法连接ws地址: %s" % url, 1)
		return false

	var wait_time := 0.0
	while _ws.get_ready_state() != WebSocketPeer.STATE_OPEN:
		if _ws.get_ready_state() == WebSocketPeer.STATE_CLOSED:
			_log("ws连接在极短时间内失败: %s" % url, 1)
			return false

		await get_tree().process_frame
		_ws.poll()
		wait_time += get_process_delta_time()

		if wait_time > 5.0:
			_log("ws连接超时: %s" % url, 1)
			_ws.close()
			return false

	# 连接成功后，发送鉴权包
	var req_bytes := BiliLiveProto.pack(BiliLiveProto.OP_AUTH, auth_body.to_utf8_buffer())
	_ws.put_packet(req_bytes)

	return true


func _process_packet_data(raw_data: PackedByteArray) -> void:
	var packets := BiliLiveProto.unpack(raw_data)

	for p in packets:
		match p.op:
			BiliLiveProto.OP_AUTH_REPLY:
				# 鉴权响应
				var json: Dictionary = JSON.parse_string(p.body.get_string_from_utf8())
				if json and json.get("code") == 0:
					_is_authenticated = true
					emit_signal("connected")
					# _send_ws_heartbeat()  # 鉴权成功后立即发一次心跳（可选）
				else:
					_log("鉴权失败: " + str(json), 1)
			BiliLiveProto.OP_HEARTBEAT_REPLY:
				_log("服务端心跳响应")
			BiliLiveProto.OP_SEND_SMS_REPLY:
				# 业务消息
				if p.json_data:
					_dispatch_event(p.json_data)


func _dispatch_event(json: Dictionary) -> void:
	var cmd: String = json.get("cmd", "")
	var data: Dictionary = json.get("data", {})

	emit_signal("live_data", json)

	match cmd:
		"LIVE_OPEN_PLATFORM_DM":
			emit_signal("live_dm", BiliLiveDm.from_dict(data))
		"LIVE_OPEN_PLATFORM_DM_MIRROR":
			emit_signal("live_dm_mirror", BiliLiveDmMirror.from_dict(data))
		"LIVE_OPEN_PLATFORM_SEND_GIFT":
			emit_signal("live_send_gift", BiliLiveSendGift.from_dict(data))
		"LIVE_OPEN_PLATFORM_SUPER_CHAT":
			emit_signal("live_super_chat", BiliLiveSuperChat.from_dict(data))
		"LIVE_OPEN_PLATFORM_SUPER_CHAT_DEL":
			emit_signal("live_super_chat_del", BiliLiveSuperChatDel.from_dict(data))
		"LIVE_OPEN_PLATFORM_GUARD":
			emit_signal("live_guard", BiliLiveGuard.from_dict(data))
		"LIVE_OPEN_PLATFORM_LIKE":
			emit_signal("live_like", BiliLiveLike.from_dict(data))
		"LIVE_OPEN_PLATFORM_LIVE_ROOM_ENTER":
			emit_signal("live_room_enter", BiliLiveRoomEnter.from_dict(data))
		"LIVE_OPEN_PLATFORM_LIVE_START":
			emit_signal("live_live_start", BiliLiveLiveStart.from_dict(data))
		"LIVE_OPEN_PLATFORM_LIVE_END":
			emit_signal("live_live_end", BiliLiveLiveEnd.from_dict(data))
		"LIVE_OPEN_PLATFORM_INTERACTION_END":
			emit_signal("live_interaction_end", BiliLiveInteractionEnd.from_dict(data))


func _api_request(endpoint: String, params: Dictionary) -> Dictionary:
	var body_str := JSON.stringify(params)
	var headers := _generate_headers(body_str)
	var url := config.host + endpoint

	_http.request(url, headers, HTTPClient.METHOD_POST, body_str)
	var result: Array = await _http.request_completed

	if result[0] != HTTPRequest.RESULT_SUCCESS:
		var net_err: String = "网络请求失败 (HTTPRequest Result: %d)" % result[0]
		_log(net_err, 1)
		return {"success": false, "data": null}

	var body_raw: String = result[3].get_string_from_utf8()
	var json: Dictionary = JSON.parse_string(body_raw)
	if json == null:
		_log("解析 JSON 失败: " + body_raw, 1)
		return {"success": false, "data": null}

	var code: int = json.get("code", -1)
	if code != 0:
		var error_msg := BiliLiveClient.get_error_detaile(code)
		_log(error_msg + " " + str(json), 1)
		return {"success": false, "data": json}

	return {"success": true, "data": json.get("data")}


func _generate_headers(body: String) -> PackedStringArray:
	# 1. MD5
	var md5_ctx := HashingContext.new()
	md5_ctx.start(HashingContext.HASH_MD5)
	md5_ctx.update(body.to_utf8_buffer())
	var md5_str := md5_ctx.finish().hex_encode()

	# 2. Params
	var ts := str(int(Time.get_unix_time_from_system()))
	var nonce := str(randi() % 100000 + int(Time.get_unix_time_from_system()))

	var header_map := {
		"x-bili-timestamp": ts,
		"x-bili-signature-method": "HMAC-SHA256",
		"x-bili-signature-nonce": nonce,
		"x-bili-accesskeyid": config.access_key_id,
		"x-bili-signature-version": "1.0",
		"x-bili-content-md5": md5_str,
	}

	# 3. Sort & Sign
	var keys: Array = header_map.keys()
	keys.sort()
	var sign_str := ""
	for k in keys:
		sign_str += k + ":" + header_map[k] + "\n"
	sign_str = sign_str.trim_suffix("\n")

	var hmac := _crypto.hmac_digest(HashingContext.HASH_SHA256, config.access_key_secret.to_utf8_buffer(), sign_str.to_utf8_buffer())
	var signature := hmac.hex_encode()

	# 4. Final Headers
	var headers := PackedStringArray()
	for k in keys:
		headers.append(k + ":" + header_map[k])
	headers.append("Authorization:" + signature)
	headers.append("Content-Type:application/json")
	headers.append("Accept:application/json")

	return headers


func _send_ws_heartbeat() -> void:
	if _ws.get_ready_state() == WebSocketPeer.STATE_OPEN:
		var pkt := BiliLiveProto.pack(BiliLiveProto.OP_HEARTBEAT, PackedByteArray())
		_ws.put_packet(pkt)


func _send_app_heartbeat() -> void:
	_api_request("/v2/app/heartbeat", {"game_id": _game_id})


func _log(msg: String, level: int = 0) -> void:
	if not print_log:
		return
	var time := Time.get_datetime_string_from_system(false, true)
	var content := "[BiliLive {time}] {msg}".format({"time": time, "msg": msg})
	if level > 0:
		printerr(content)
	else:
		print(content)
