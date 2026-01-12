## 点赞信息
class_name BiliLiveLike
extends RefCounted

## 用户昵称
var uname: String = ""
## 用户UID（已废弃，固定为0）
var uid: int = 0
## 用户唯一标识
var open_id: String = ""
## 用户在同一个开发者下的唯一标识(默认为空，根据业务需求单独申请开通)
var union_id: String = ""
## 用户头像
var uface: String = ""
## 时间秒级时间戳
var timestamp: int = 0
## 点赞文案( "xxx点赞了")
var like_text: String = ""
## 对单个用户最近2秒的点赞次数聚合
var like_count: int = 0
## 该房间粉丝勋章佩戴情况
var fans_medal_wearing_status: bool = false
## 粉丝勋章名
var fans_medal_name: String = ""
## 对应房间勋章信息
var fans_medal_level: int = 0
## 消息唯一id
var msg_id: String = ""
## 发生的直播间
var room_id: int = 0


## 从字典反序列化创建实例
static func from_dict(data: Dictionary) -> BiliLiveLike:
	var instance := BiliLiveLike.new()
	instance.uname = data.get("uname", "")
	instance.uid = data.get("uid", 0)
	instance.open_id = data.get("open_id", "")
	instance.union_id = data.get("union_id", "")
	instance.uface = data.get("uface", "")
	instance.timestamp = data.get("timestamp", 0)
	instance.like_text = data.get("like_text", "")
	instance.like_count = data.get("like_count", 0)
	instance.fans_medal_wearing_status = data.get("fans_medal_wearing_status", false)
	instance.fans_medal_name = data.get("fans_medal_name", "")
	instance.fans_medal_level = data.get("fans_medal_level", 0)
	instance.msg_id = data.get("msg_id", "")
	instance.room_id = data.get("room_id", 0)
	return instance


## 序列化为字典
func to_dict() -> Dictionary:
	return {
		"uname": uname,
		"uid": uid,
		"open_id": open_id,
		"union_id": union_id,
		"uface": uface,
		"timestamp": timestamp,
		"like_text": like_text,
		"like_count": like_count,
		"fans_medal_wearing_status": fans_medal_wearing_status,
		"fans_medal_name": fans_medal_name,
		"fans_medal_level": fans_medal_level,
		"msg_id": msg_id,
		"room_id": room_id,
	}
