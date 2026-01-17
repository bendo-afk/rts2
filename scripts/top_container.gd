extends HBoxContainer

@export var score_container: PackedScene

var teams: Node

var ally_score: HBoxContainer
var enemy_score: HBoxContainer

func setup() -> void:
	add_theme_constant_override("separation", 20)

	ally_score = _create_score(teams.ally, false)
	enemy_score = _create_score(teams.enemy, true)
	
	apply_settings()

func _create_score(team: Team, reverse: bool) -> HBoxContainer:
	var score := score_container.instantiate()
	add_child(score)
	team.score_changed.connect(score.set_score)

	if reverse:
		score.move_child(score.score_label, 0)

	return score


func _process(_delta: float) -> void:
	ally_score.set_cd(teams.ally.left_height_cd)
	enemy_score.set_cd(teams.enemy.left_height_cd)


func apply_settings() -> void:
	var score_size := GlobalSettings.ui_settings.score_size
	var cd_size := GlobalSettings.ui_settings.cd_size
	
	if ally_score:
		ally_score.set_sizes(score_size, cd_size)
	if enemy_score:
		enemy_score.set_sizes(score_size, cd_size)
