##　付费留言下线信息
class_name BiliLiveSuperChatDel
extends RefCounted

## 直播间id
var room_id: int = 0
## 留言id
var message_ids: Array = []
## 消息唯一id
var msg_id: String = ""


## 从字典反序列化创建实例
static func from_dict(data: Dictionary) -> BiliLiveSuperChatDel:
	var instance := BiliLiveSuperChatDel.new()
	instance.room_id = data.get("room_id", 0)
	instance.message_ids = data.get("message_ids", [])
	instance.msg_id = data.get("msg_id", "")
	return instance


## 序列化为字典
func to_dict() -> Dictionary:
	return {
		"room_id": room_id,
		"message_ids": message_ids,
		"msg_id": msg_id,
	}
