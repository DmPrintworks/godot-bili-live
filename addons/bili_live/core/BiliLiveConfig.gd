## 存储进行长连的认证信息
class_name BiliLiveConfig
extends Resource

@export_group("身份认证")
## 主播身份码 (必填)
@export var id_code: String = ""
## 项目ID (必填)
@export var app_id: int = 0
## 开发者 Access Key (必填)
@export var access_key_id: String = ""
## 开发者 Secret Key (必填)
@export var access_key_secret: String = ""

@export_group("网络配置")
## API地址
@export var host: String = "https://live-open.biliapi.com"
## WebSocket 心跳间隔 (秒)
@export var ws_heartbeat_interval: float = 20.0
## 项目心跳间隔 (秒)
@export var app_heartbeat_interval: float = 20.0
