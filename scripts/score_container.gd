extends HBoxContainer

@onready var score_label := $Score
@onready var cd_label := $Cooldown

func set_sizes(score_size: float, cd_size: float) -> void:
	cd_label.add_theme_font_size_override("font_size", cd_size)
	score_label.add_theme_font_size_override("font_size", score_size)

func set_score(score: float) -> void:
	score_label.text = str(score)

func set_cd(cd: float) -> void:
	cd_label.text = str(cd) + "s"
