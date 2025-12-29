extends Node2D

class_name World

@export var unit_scene: PackedScene

@onready var map := $TileMapLayer
@onready var units := $Units
@onready var teams := $Teams

@onready var move_system := $MoveSystem

@onready var ex_con := $ExternalControl
@onready var world_ui := $WorldUI


func _ready() -> void:
	var childs := get_children(false)
	for c in childs:
		if c is System:
			c.units = $Units.units
			c.map = $TileMapLayer
	$ExternalControl.units = $Units.units
	$ExternalControl.map = $TileMapLayer
	$ExternalControl.teams = $Teams
	
	setup_units()
	
	setup_ui()

func setup_ui() -> void:
	for ui_node in world_ui.get_children(false):
		ui_node.units = units.units
		ui_node.teams = teams
		ui_node.map = map

	world_ui.path_ui.setup()
	world_ui.ui_canvas.setup()

func setup_units() -> void:
	var unit := unit_scene.instantiate()
	unit.team = teams.ally
	unit.world = self
	units.add_child(unit)
	unit.setup(3, 3, 1, 1, map.map_to_local(Vector2i.ZERO))
	units.units.append(unit)

func _physics_process(delta: float) -> void:
	move_system.physics(delta)
