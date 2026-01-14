extends CanvasLayer

var units: Array[Unit]
var teams: Node
var map: TileMapLayer

@export var side_container_scene: PackedScene

@onready var top_container := $TopContainer
@onready var in_ui := $InUI
@onready var side_container := $SideContainer

func setup() -> void:
	top_container.teams = teams
	top_container.setup()

	setup_sides()
	
	in_ui.units = units
	in_ui.team = teams.ally
	in_ui.setup()

func setup_sides() -> void:
	side_container.set_anchors_and_offsets_preset(10)
	
	var ally_side := side_container_scene.instantiate()
	side_container.add_child(ally_side)
	ally_side.units = units
	ally_side.team = teams.ally
	ally_side.setup()
	
	var enemy_side := side_container_scene.instantiate()
	side_container.add_child(enemy_side)
	enemy_side.set_anchors_and_offsets_preset(1, true)
	enemy_side.set_h_grow_direction(0)
	enemy_side.units = units
	enemy_side.team = teams.enemy
	enemy_side.setup()
