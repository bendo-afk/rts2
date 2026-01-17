extends Control

var side_margin: float
var side_size: float
var names: Array

var units: Array[Unit]
var teams: Node

@export var side_container_scene: PackedScene

func setup() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	
	create_side(teams.ally, false)
	create_side(teams.enemy, true)


func create_side(team: Team, reverse: bool) -> void:
	var side_container := side_container_scene.instantiate()
	add_child(side_container)
	side_container.side_size = side_size
	side_container.names = names
	side_container.units = units
	side_container.team = team
	side_container.setup()
	
	if reverse:
		side_container.set_anchors_and_offsets_preset(1, false)
		side_container.set_h_grow_direction(0)

	side_container.set_offset(Side.SIDE_TOP, side_margin)
