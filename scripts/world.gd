extends Node2D

class_name World

@onready var map := $TileMapLayer

func _ready() -> void:
	var childs := get_children(false)
	for c in childs:
		if c.is_class("System"):
			c.units = $Units
			c.map = $TileMapLayer
