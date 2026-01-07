## 消息推送结束通知信息
class_name BiliLiveInteractionEnd
extends RefCounted

## 结束消息推送的game_id
var game_id: String = ""
## 发生的时间戳
var timestamp: int = 0


static func from_dict(data: Dictionary) -> BiliLiveInteractionEnd:
	var instance := BiliLiveInteractionEnd.new()
	instance.game_id = data.get("game_id", "")
	instance.timestamp = data.get("timestamp", 0)
	return instance
