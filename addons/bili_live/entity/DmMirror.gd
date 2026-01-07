## 跨房弹幕信息
class_name BiliLiveDmMirror
extends RefCounted

## 当前收到这条弹幕的直播间
var room_id: int = 0
## 弹幕内容
var msg: String = ""
## 消息唯一id
var msg_id: String = ""
## 弹幕发送时间秒级时间戳
var timestamp: int = 0
## 表情包图片地址
var emoji_img_url: String = ""
## 弹幕类型 0普通弹幕 1表情包弹幕
var dm_type: int = 0


static func from_dict(data: Dictionary) -> BiliLiveDmMirror:
	var instance := BiliLiveDmMirror.new()
	instance.room_id = data.get("room_id", 0)
	instance.msg = data.get("msg", "")
	instance.msg_id = data.get("msg_id", "")
	instance.timestamp = data.get("timestamp", 0)
	instance.emoji_img_url = data.get("emoji_img_url", "")
	instance.dm_type = data.get("dm_type", 0)
	return instance
