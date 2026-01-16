extends Control

var side_margin: float
var side_size: float

var units: Array[Unit]
var teams: Node

@export var side_container_scene: PackedScene

func setup() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	
	var ally_side := side_container_scene.instantiate()
	add_child(ally_side)
	ally_side.units = units
	ally_side.team = teams.ally
	ally_side.setup()
	
	var enemy_side := side_container_scene.instantiate()
	add_child(enemy_side)
	enemy_side.set_anchors_and_offsets_preset(1, true)
	enemy_side.set_h_grow_direction(0)
	enemy_side.units = units
	enemy_side.team = teams.enemy
	enemy_side.setup()
