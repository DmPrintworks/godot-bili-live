## 长连数据协议
class_name BiliLiveProto
extends RefCounted

## Header的长度，固定为16
const HEADER_LEN: int = 16
const VER_JSON: int = 0
const VER_ZLIB: int = 2

## 客户端发送的心跳包
const OP_HEARTBEAT: int = 2
## 服务器收到心跳包的回复
const OP_HEARTBEAT_REPLY: int = 3
## 服务器推送的弹幕消息包
const OP_SEND_SMS_REPLY: int = 5
## 客户端发送的鉴权包(客户端发送的第一个包)
const OP_AUTH: int = 7
## 服务器收到鉴权包后的回复
const OP_AUTH_REPLY: int = 8


class Packet:
	## 	整个Packet的长度，包含Header
	var packet_len: int
	## Header的长度，固定为16
	var header_len: int
	## Version
	var ver: int
	## 消息的类型
	var op: int
	## 保留字段，可以忽略
	var seq: int
	## 消息体，客户端解析Body之前请先解析Version字段
	var body: PackedByteArray
	## body的内容
	var json_data: Variant = null


## 打包数据 (Client -> Server)
static func pack(op: int, body: PackedByteArray, seq: int = 1) -> PackedByteArray:
	var header_len := HEADER_LEN
	var packet_len := body.size() + header_len
	var ver: int = 0  # 发送通常使用 0

	var buf := StreamPeerBuffer.new()
	buf.big_endian = true

	buf.put_32(packet_len)
	buf.put_16(header_len)
	buf.put_16(ver)
	buf.put_32(op)
	buf.put_32(seq)
	buf.put_data(body)

	return buf.data_array


## 解包数据 (Server -> Client)
static func unpack(data: PackedByteArray) -> Array[Packet]:
	var packets: Array[Packet] = []
	var offset: int = 0
	var total_len := data.size()

	while offset < total_len:
		# 1. 最小包头校验 (16字节)
		if total_len - offset < HEADER_LEN:
			break

		var buf := StreamPeerBuffer.new()
		buf.data_array = data
		buf.big_endian = true
		buf.seek(offset)

		var packet_len := buf.get_32()
		var header_len := buf.get_16()
		var ver := buf.get_16()
		var op := buf.get_32()
		var seq := buf.get_32()

		# 2. 合法性检查：防止 packet_len 异常导致死循环或 OOM
		if packet_len < HEADER_LEN or offset + packet_len > total_len:
			break

		# 3. 提取 Body
		var body := data.slice(offset + header_len, offset + packet_len)

		# 指针移动到下一个包起始位置
		offset += packet_len

		# 4. 根据版本处理递归或解析
		match ver:
			VER_ZLIB:
				# -1 代表不限制解压后的大小，Godot 会自动分配
				var decompressed := body.decompress_dynamic(-1, FileAccess.COMPRESSION_DEFLATE)
				if not decompressed.is_empty():
					# 解析解压后的二进制流
					packets.append_array(unpack(decompressed))
				else:
					printerr("[BiliProto] Zlib 解压失败")
			_:
				# 标准包解析 (Version 0)
				var p := Packet.new()
				p.packet_len = packet_len
				p.header_len = header_len
				p.ver = ver
				p.op = op
				p.seq = seq
				p.body = body

				# 预处理业务数据
				if op == OP_SEND_SMS_REPLY:
					var json_str := body.get_string_from_utf8()
					var json: Dictionary = JSON.parse_string(json_str)
					if json:
						p.json_data = json

				packets.append(p)

	return packets
