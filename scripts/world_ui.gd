extends Node

var ui_settings: UISettings

@onready var unit_ui := $UnitUI
@onready var ui_canvas := $UICanvas
@onready var path_ui := $PathUI


func _ready() -> void:
	ui_settings = GlobalSettings.ui_settings
	reflect_ui_settings()


func reflect_ui_settings() -> void:
	unit_ui.size = ui_settings.unit_size
	unit_ui.ally_color = ui_settings.ally_color
	unit_ui.enemy_color = ui_settings.enemy_color
	unit_ui.turret_color = ui_settings.turret_color
	unit_ui.turret_width = ui_settings.turret_width
	
	ui_canvas.top_container.score_size = ui_settings.score_size
	ui_canvas.top_container.cd_size = ui_settings.cd_size
	ui_canvas.sides_container.side_margin = ui_settings.side_margin
	ui_canvas.sides_container.side_size = ui_settings.side_size
	ui_canvas.in_ui.font_size = ui_settings.in_size
	
	path_ui.line_color = ui_settings.path_color
	path_ui.line_width = ui_settings.path_width
