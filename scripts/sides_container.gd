extends Control

var side_margin: float
var side_size: float
var names: Array

var side_containers: Array[Node] = []

var units: Array[Unit]
var teams: Node

@export var side_container_scene: PackedScene

func setup() -> void:
	set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)

	side_containers.append(create_side(teams.ally, false))
	side_containers.append(create_side(teams.enemy, true))

	apply_settings()



func create_side(team: Team, reverse: bool) -> Node:
	var side_container := side_container_scene.instantiate()
	add_child(side_container)
	
	side_container.units = units
	side_container.team = team
	
	side_container.setup()
	
	if reverse:
		side_container.set_anchors_and_offsets_preset(1, false)
		side_container.set_h_grow_direction(0)

	return side_container


func apply_settings() -> void:
	var s := GlobalSettings.ui_settings

	side_margin = s.side_margin

	for side_container in side_containers:
		side_container.set_offset(Side.SIDE_TOP, side_margin)
		side_container.apply_settings()
