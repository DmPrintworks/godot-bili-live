@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("BiliLiveClient", "Node", preload("res://addons/bili_live/core/BiliLiveClient.gd"), preload("res://addons/bili_live/icon.svg"))
	print("BiliLive 插件已加载")


func _exit_tree():
	remove_custom_type("BiliLiveClient")
	print("BiliLive 插件已卸载")
