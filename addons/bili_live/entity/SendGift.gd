## 礼物信息
class_name BiliLiveSendGift
extends RefCounted

## 直播间(演播厅模式则为演播厅直播间,非演播厅模式则为收礼直播间)
var room_id: int = 0
## 用户UID（已废弃）
var uid: int = 0
## 用户唯一标识
var open_id: String = ""
## 用户在同一开发者下的唯一标识
var union_id: String = ""
## 送礼用户昵称
var uname: String = ""
## 送礼用户头像
var uface: String = ""
## 道具id(盲盒:爆出道具id)
var gift_id: int = 0
## 道具名(盲盒:爆出道具名)
var gift_name: String = ""
## 赠送道具数量
var gift_num: int = 0
## 礼物爆出单价，(1000 = 1元 = 10电池),盲盒:爆出道具的价值
var price: int = 0
## 实际价值(1000 = 1元 = 10电池),盲盒:爆出道具的价值
var r_price: int = 0
## 是否是付费道具
var paid: bool = false
## 实际送礼人的勋章信息
var fans_medal_level: int = 0
## 粉丝勋章名
var fans_medal_name: String = ""
## 该房间粉丝勋章佩戴情况
var fans_medal_wearing_status: bool = false
## 大航海等级
var guard_level: int = 0
## 收礼时间秒级时间戳
var timestamp: int = 0
## 消息唯一id
var msg_id: String = ""
## 道具icon
var gift_icon: String = ""
## 是否是combo道具
var combo_gift: bool = false
## 主播信息
var anchor_info: BiliLiveSendGift.AnchorInfo = null
## 连击信息
var combo_info: BiliLiveSendGift.ComboInfo = null
## 盲盒信息
var blind_gift: BiliLiveSendGift.BlindGift = null


## 从字典反序列化创建实例
static func from_dict(data: Dictionary) -> BiliLiveSendGift:
	var instance := BiliLiveSendGift.new()
	instance.room_id = data.get("room_id", 0)
	instance.uid = data.get("uid", 0)
	instance.open_id = data.get("open_id", "")
	instance.union_id = data.get("union_id", "")
	instance.uname = data.get("uname", "")
	instance.uface = data.get("uface", "")
	instance.gift_id = data.get("gift_id", 0)
	instance.gift_name = data.get("gift_name", "")
	instance.gift_num = data.get("gift_num", 0)
	instance.price = data.get("price", 0)
	instance.paid = data.get("paid", false)
	instance.fans_medal_level = data.get("fans_medal_level", 0)
	instance.fans_medal_name = data.get("fans_medal_name", "")
	instance.fans_medal_wearing_status = data.get("fans_medal_wearing_status", false)
	instance.guard_level = data.get("guard_level", 0)
	instance.timestamp = data.get("timestamp", 0)
	instance.msg_id = data.get("msg_id", "")
	instance.gift_icon = data.get("gift_icon", "")
	instance.combo_gift = data.get("combo_gift", false)

	var anchor_dict := data.get("anchor_info", null)
	if anchor_dict is Dictionary:
		instance.anchor_info = BiliLiveSendGift.AnchorInfo.from_dict(anchor_dict)

	var combo_dict := data.get("combo_info", null)
	if combo_dict is Dictionary:
		instance.combo_info = BiliLiveSendGift.ComboInfo.from_dict(combo_dict)

	var blind_dict := data.get("blind_gift", null)
	if blind_dict is Dictionary:
		instance.blind_gift = BiliLiveSendGift.BlindGift.from_dict(blind_dict)

	return instance


## 序列化为字典
func to_dict() -> Dictionary:
	var dict := {
		"room_id": room_id,
		"uid": uid,
		"open_id": open_id,
		"union_id": union_id,
		"uname": uname,
		"uface": uface,
		"gift_id": gift_id,
		"gift_name": gift_name,
		"gift_num": gift_num,
		"price": price,
		"r_price": r_price,
		"paid": paid,
		"fans_medal_level": fans_medal_level,
		"fans_medal_name": fans_medal_name,
		"fans_medal_wearing_status": fans_medal_wearing_status,
		"guard_level": guard_level,
		"timestamp": timestamp,
		"msg_id": msg_id,
		"gift_icon": gift_icon,
		"combo_gift": combo_gift,
	}
	if anchor_info:
		dict["anchor_info"] = anchor_info.to_dict()
	if combo_info:
		dict["combo_info"] = combo_info.to_dict()
	if blind_gift:
		dict["blind_gift"] = blind_gift.to_dict()
	return dict


## 主播信息
class AnchorInfo:
	extends RefCounted
	## 收礼主播uid
	var uid: int = 0
	## 收礼主播唯一标识
	var open_id: String = ""
	## 用户在同一个开发者下的唯一标识(默认为空，根据业务需求单独申请开通)
	var union_id: String = ""
	## 收礼主播昵称
	var uname: String = ""
	## 收礼主播头像
	var uface: String = ""

	## 从字典反序列化创建实例
	static func from_dict(data: Dictionary) -> AnchorInfo:
		var instance := AnchorInfo.new()
		instance.uid = data.get("uid", 0)
		instance.open_id = data.get("open_id", "")
		instance.union_id = data.get("union_id", "")
		instance.uname = data.get("uname", "")
		instance.uface = data.get("uface", "")
		return instance

	## 序列化为字典
	func to_dict() -> Dictionary:
		return {
			"uid": uid,
			"open_id": open_id,
			"union_id": union_id,
			"uname": uname,
			"uface": uface,
		}


## 连击信息
class ComboInfo:
	extends RefCounted
	## 每次连击赠送的道具数量
	var combo_base_num: int = 0
	## 连击次数
	var combo_count: int = 0
	## 连击id
	var combo_id: String = ""
	## 连击有效期秒
	var combo_timeout: int = 0

	## 从字典反序列化创建实例
	static func from_dict(data: Dictionary) -> ComboInfo:
		var instance := ComboInfo.new()
		instance.combo_base_num = data.get("combo_base_num", 0)
		instance.combo_count = data.get("combo_count", 0)
		instance.combo_id = data.get("combo_id", "")
		instance.combo_timeout = data.get("combo_timeout", 0)
		return instance

	## 序列化为字典
	func to_dict() -> Dictionary:
		return {
			"combo_base_num": combo_base_num,
			"combo_count": combo_count,
			"combo_id": combo_id,
			"combo_timeout": combo_timeout,
		}


## 盲盒信息
class BlindGift:
	extends RefCounted
	## 盲盒id
	var blind_gift_id: int = 0
	## 是否是盲盒
	var status: bool = false

	## 从字典反序列化创建实例
	static func from_dict(data: Dictionary) -> BlindGift:
		var instance := BlindGift.new()
		instance.blind_gift_id = data.get("blind_gift_id", 0)
		instance.status = data.get("status", false)
		return instance

	## 序列化为字典
	func to_dict() -> Dictionary:
		return {
			"blind_gift_id": blind_gift_id,
			"status": status,
		}
