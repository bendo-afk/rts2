extends HBoxContainer

@export var score_container: PackedScene

var score_size: float
var cd_size: float
var teams: Node

var ally_score: HBoxContainer
var enemy_score: HBoxContainer

func setup() -> void:
	add_theme_constant_override("separation", 20)

	ally_score = _create_score(
		teams.ally,
		false
	)

	enemy_score = _create_score(
		teams.enemy,
		true
	)

func _create_score(team: Team, reverse: bool) -> HBoxContainer:
	var score := score_container.instantiate()
	add_child(score)
	score.set_sizes(score_size, cd_size)
	team.score_changed.connect(score.set_score)

	if reverse:
		score.move_child(score.score_label, 0)

	return score

func _process(_delta: float) -> void:
	ally_score.set_cd(teams.ally.left_height_cd)
	enemy_score.set_cd(teams.enemy.left_height_cd)
