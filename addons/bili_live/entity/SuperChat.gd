## 付费留言信息
class_name BiliLiveSuperChat
extends RefCounted

## 直播间id
var room_id: int = 0
## 购买用户UID(已废弃，固定为0)
var uid: int = 0
## 用户唯一标识
var open_id: String = ""
## 用户在同一个开发者下的唯一标识(默认为空，根据业务需求单独申请开通)
var union_id: String = ""
## 购买的用户昵称
var uname: String = ""
## 购买用户头像
var uface: String = ""
## 留言id(风控场景下撤回留言需要)
var message_id: int = 0
## 留言内容
var message: String = ""
## 消息唯一id
var msg_id: String = ""
## 支付金额(元)
var rmb: int = 0
## 赠送时间秒级
var timestamp: int = 0
## 生效开始时间
var start_time: int = 0
## 生效结束时间
var end_time: int = 0
## 对应房间大航海等级
var guard_level: int = 0
## 对应房间勋章信息
var fans_medal_level: int = 0
## 对应房间勋章名字
var fans_medal_name: String = ""
## 该房间粉丝勋章佩戴情况
var fans_medal_wearing_status: bool = false


## 从字典反序列化创建实例
static func from_dict(data: Dictionary) -> BiliLiveSuperChat:
	var instance := BiliLiveSuperChat.new()
	instance.room_id = data.get("room_id", 0)
	instance.uid = data.get("uid", 0)
	instance.open_id = data.get("open_id", "")
	instance.union_id = data.get("union_id", "")
	instance.uname = data.get("uname", "")
	instance.uface = data.get("uface", "")
	instance.message_id = data.get("message_id", 0)
	instance.message = data.get("message", "")
	instance.msg_id = data.get("msg_id", "")
	instance.rmb = data.get("rmb", 0)
	instance.timestamp = data.get("timestamp", 0)
	instance.start_time = data.get("start_time", 0)
	instance.end_time = data.get("end_time", 0)
	instance.guard_level = data.get("guard_level", 0)
	instance.fans_medal_level = data.get("fans_medal_level", 0)
	instance.fans_medal_name = data.get("fans_medal_name", "")
	instance.fans_medal_wearing_status = data.get("fans_medal_wearing_status", false)
	return instance


## 序列化为字典
func to_dict() -> Dictionary:
	return {
		"room_id": room_id,
		"uid": uid,
		"open_id": open_id,
		"union_id": union_id,
		"uname": uname,
		"uface": uface,
		"message_id": message_id,
		"message": message,
		"msg_id": msg_id,
		"rmb": rmb,
		"timestamp": timestamp,
		"start_time": start_time,
		"end_time": end_time,
		"guard_level": guard_level,
		"fans_medal_level": fans_medal_level,
		"fans_medal_name": fans_medal_name,
		"fans_medal_wearing_status": fans_medal_wearing_status,
	}
