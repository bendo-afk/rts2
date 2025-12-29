extends HBoxContainer

var teams: Node

var ally_score: HBoxContainer
var enemy_score: HBoxContainer

@export var score_container: PackedScene

func setup() -> void:
	ally_score = score_container.instantiate()
	add_child(ally_score)
	ally_score.set_sizes(30,30)
	teams.ally.score_changed.connect(ally_score.set_score)

	enemy_score = score_container.instantiate()
	add_child(enemy_score)
	enemy_score.set_sizes(30,30)
	teams.enemy.score_changed.connect(enemy_score.set_score)
	enemy_score.move_child(enemy_score.score_label, 0)

func _process(_delta: float) -> void:
	ally_score.set_cd(teams.ally.left_height_cd)
	enemy_score.set_cd(teams.enemy.left_height_cd)
