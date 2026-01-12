## 结束直播信息
class_name BiliLiveLiveEnd
extends RefCounted

## 开播二级分区名称
var area_name: String = ""
## 用户唯一标识
var open_id: String = ""
## 用户在同一个开发者下的唯一标识(默认为空，根据业务需求单独申请开通)
var union_id: String = ""
## 发生的直播间
var room_id: int = 0
## 发生的时间戳
var timestamp: int = 0
## 开播时刻，直播间的标题
var title: String = ""


## 从字典反序列化创建实例
static func from_dict(data: Dictionary) -> BiliLiveLiveEnd:
	var instance := BiliLiveLiveEnd.new()
	instance.area_name = data.get("area_name", "")
	instance.open_id = data.get("open_id", "")
	instance.union_id = data.get("union_id", "")
	instance.room_id = data.get("room_id", 0)
	instance.timestamp = data.get("timestamp", 0)
	instance.title = data.get("title", "")
	return instance


## 序列化为字典
func to_dict() -> Dictionary:
	return {
		"area_name": area_name,
		"open_id": open_id,
		"union_id": union_id,
		"room_id": room_id,
		"timestamp": timestamp,
		"title": title,
	}
