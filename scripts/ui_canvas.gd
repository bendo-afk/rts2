extends CanvasLayer

var units: Array[Unit]
var teams: Node
var map: TileMapLayer

@export var in_hp_scene: PackedScene
@export var side_container_scene: PackedScene

@onready var top_container := $TopContainer

func setup() -> void:
	top_container.teams = teams
	top_container.setup()

	setup_sides()

func setup_sides() -> void:
	var ally_side := side_container_scene.instantiate()
	add_child(ally_side)
	ally_side.units = units
	ally_side.team = teams.ally
	ally_side.setup()
	
	var enemy_side := side_container_scene.instantiate()
	add_child(enemy_side)
	enemy_side.units = units
	enemy_side.team = teams.enemy
	enemy_side.setup()
