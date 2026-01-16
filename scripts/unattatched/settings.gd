extends Node

var ui_settings: UISettings


func _ready() -> void:
	load_ui_settings()


func load_ui_settings() -> void:
	ui_settings = load("res://resources/ui_settings.tres")
