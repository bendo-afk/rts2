extends CanvasLayer

var units: Array[Unit]
var teams: Node
var map: TileMapLayer

@export var score_container: PackedScene
@export var in_hp_scene: PackedScene
@export var side_hp_scene: PackedScene

@onready var top_container := $TopContainer
@onready var ally_side := $Ally
@onready var enemy_side := $Enemy

func setup() -> void:
	var ally_score := score_container.instantiate()
	top_container.add_child(ally_score)
	ally_score.set_score(0)
	ally_score.set_cd(1)
	ally_score.set_sizes(30,30)
	
	var enemy_score := score_container.instantiate()
	top_container.add_child(enemy_score)
	enemy_score.set_score(0)
	enemy_score.set_cd(1)
	enemy_score.set_sizes(30,30)
	enemy_score.move_child(enemy_score.score_label, 0)
	
