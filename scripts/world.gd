extends Node2D

class_name World

@export var unit_scene: PackedScene

@onready var map := $TileMapLayer
@onready var units := $Units
@onready var teams := $Teams

@onready var move_system := $MoveSystem

@onready var ex_con := $ExternalControl


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

func setup_units() -> void:
	var unit := unit_scene.instantiate()
	unit.team = teams.ally
	unit.world = self
	unit.position = map.map_to_local(Vector2i.ZERO)
	units.add_child(unit)
	unit.move_comp.speed = 1
	units.units.append(unit)

func _physics_process(delta: float) -> void:
	move_system.physics(delta)
