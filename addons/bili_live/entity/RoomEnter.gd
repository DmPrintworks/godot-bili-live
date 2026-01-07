## 进入房间信息
class_name BiliLiveRoomEnter
extends RefCounted

## 发生的直播间
var room_id: int = 0
## 用户头像
var uface: String = ""
## 用户昵称
var uname: String = ""
## 用户唯一标识
var open_id: String = ""
## 用户在同一个开发者下的唯一标识(默认为空，根据业务需求单独申请开通)
var union_id: String = ""
## 发生的时间戳
var timestamp: int = 0


static func from_dict(data: Dictionary) -> BiliLiveRoomEnter:
	var instance := BiliLiveRoomEnter.new()
	instance.room_id = data.get("room_id", 0)
	instance.uface = data.get("uface", "")
	instance.uname = data.get("uname", "")
	instance.open_id = data.get("open_id", "")
	instance.union_id = data.get("union_id", "")
	instance.timestamp = data.get("timestamp", 0)
	return instance
