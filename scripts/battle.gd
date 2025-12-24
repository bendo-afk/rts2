extends Node2D

@onready var world := $World
@onready var unit_manager := $UnitManager
@onready var input_controller := $InputController

@export var unit_scene: PackedScene

func _ready() -> void:
	var unit := unit_scene.instantiate()
	unit.position = world.map.map_to_local(Vector2i.ZERO)
	unit_manager.add_child(unit)
	
	input_controller.unit_manager = unit_manager
