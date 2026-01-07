extends Node2D

@onready var client: BiliLiveClient = $BiliLiveClient
@onready var title_label: Label = $CanvasLayer/TitlePanel/Label
@onready var content_label: Label = $CanvasLayer/ContentPanel/Label


func _ready() -> void:
	pass


func _on_start_button_pressed() -> void:
	client.start()


func _on_end_button_pressed() -> void:
	client.stop()


func _on_bili_live_client_connected() -> void:
	title_label.text = "✅已成功建立连接"
	content_label.text = ""


func _on_bili_live_client_disconnected() -> void:
	title_label.text = "🛑已断开连接"
	content_label.text = ""


func _on_bili_live_client_live_dm(data: BiliLiveDm) -> void:
	title_label.text = data.msg


func _on_bili_live_client_live_room_enter(data: BiliLiveRoomEnter) -> void:
	title_label.text = data.uname + "进入直播间"


func _on_bili_live_client_live_data(data: Dictionary) -> void:
	content_label.text = str(data)
