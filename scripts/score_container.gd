extends HBoxContainer

var score_size: float = 40
var cd_size: float = 30

@onready var score_label := $Score
@onready var cd_label := $Cooldown

func set_sizes() -> void:
	cd_label.add_theme_font_size_override("font_size", cd_size)
	score_label.add_theme_font_size_override("font_size", score_size)

func set_score(score: float) -> void:
	score_label.text = str(score)

func set_cd(cd: float) -> void:
	cd_label.text = str(cd) + "s"
