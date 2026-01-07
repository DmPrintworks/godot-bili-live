## 付费大航海信息
class_name BiliLiveGuard
extends RefCounted

## 大航海等级 1总督 2提督 3舰长
var guard_level: int = 0
## 大航海数量
var guard_num: int = 0
## 大航海单位(正常单位为“月”，如为其他内容，无视 guard_num 以本字段内容为准，例如 *3天 )
var guard_unit: String = ""
## 大航海金瓜子
var price: int = 0
## 粉丝勋章等级
var fans_medal_level: int = 0
## 粉丝勋章名
var fans_medal_name: String = ""
## 该房间粉丝勋章佩戴情况
var fans_medal_wearing_status: bool = false
## 上舰时间秒级时间戳
var timestamp: int = 0
## 房间号
var room_id: int = 0
## 消息唯一id
var msg_id: String = ""
## 用户信息
var user_infoa: UserInfo = null


static func from_dict(data: Dictionary) -> BiliLiveGuard:
	var instance := BiliLiveGuard.new()
	instance.user_info = UserInfo.from_dict(data.get("user_info", {}))
	instance.guard_level = data.get("guard_level", 0)
	instance.guard_num = data.get("guard_num", 0)
	instance.guard_unit = data.get("guard_unit", "")
	instance.price = data.get("price", 0)
	instance.fans_medal_level = data.get("fans_medal_level", 0)
	instance.fans_medal_name = data.get("fans_medal_name", "")
	instance.fans_medal_wearing_status = data.get("fans_medal_wearing_status", false)
	instance.timestamp = data.get("timestamp", 0)
	instance.room_id = data.get("room_id", 0)
	instance.msg_id = data.get("msg_id", "")
	return instance


## 用户信息
class UserInfo:
	## 用户UID（已废弃，固定为0）
	var uid: int = 0
	## 用户唯一标识
	var open_id: String = ""
	## 用户在同一个开发者下的唯一标识（默认为空，根据业务需求单独申请开通）
	var union_id: String = ""
	## 用户昵称
	var uname: String = ""
	## 用户头像
	var uface: String = ""

	static func from_dict(data: Dictionary) -> UserInfo:
		var instance := UserInfo.new()
		instance.uid = data.get("uid", 0)
		instance.open_id = data.get("open_id", "")
		instance.union_id = data.get("union_id", "")
		instance.uname = data.get("uname", "")
		instance.uface = data.get("uface", "")
		return instance
