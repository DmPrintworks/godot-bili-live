## 弹幕信息
class_name BiliLiveDm
extends RefCounted

## 弹幕接收的直播间
var room_id: int = 0
## 用户UID(已废弃，固定为0)
var uid: int = 0
## 用户唯一标识
var open_id: String = ""
## 用户在同一个开发者下的唯一标识(默认为空，根据业务需求单独申请开通)
var union_id: String = ""
## 用户昵称
var uname: String = ""
## 弹幕内容
var msg: String = ""
## 消息唯一id
var msg_id: String = ""
## 对应房间勋章信息
var fans_medal_level: int = 0
## 粉丝勋章名
var fans_medal_name: String = ""
## 该房间粉丝勋章佩戴情况
var fans_medal_wearing_status: bool = false
## 对应房间大航海等级 1总督 2提督 3舰长
var guard_level: int = 0
## 弹幕发送时间秒级时间戳
var timestamp: int = 0
## 用户头像
var uface: String = ""
## 表情包图片地址
var emoji_img_url: String = ""
## 弹幕类型 0普通弹幕 1表情包弹幕
var dm_type: int = 0
## 直播荣耀等级
var glory_level: int = 0
## 被at用户唯一标识
var reply_open_id: String = ""
## 被at的用户昵称
var reply_uname: String = ""
## 发送弹幕的用户是否是房管，取值范围0或1，取值为1时是房管
var is_admin: int = 0


static func from_dict(data: Dictionary) -> BiliLiveDm:
	var instance := BiliLiveDm.new()
	instance.room_id = data.get("room_id", 0)
	instance.uid = data.get("uid", 0)
	instance.open_id = data.get("open_id", "")
	instance.union_id = data.get("union_id", "")
	instance.uname = data.get("uname", "")
	instance.msg = data.get("msg", "")
	instance.msg_id = data.get("msg_id", "")
	instance.fans_medal_level = data.get("fans_medal_level", 0)
	instance.fans_medal_name = data.get("fans_medal_name", "")
	instance.fans_medal_wearing_status = data.get("fans_medal_wearing_status", false)
	instance.guard_level = data.get("guard_level", 0)
	instance.timestamp = data.get("timestamp", 0)
	instance.uface = data.get("uface", "")
	instance.emoji_img_url = data.get("emoji_img_url", "")
	instance.dm_type = data.get("dm_type", 0)
	instance.glory_level = data.get("glory_level", 0)
	instance.reply_open_id = data.get("reply_open_id", "")
	instance.reply_uname = data.get("reply_uname", "")
	instance.is_admin = data.get("is_admin", 0)
	return instance
