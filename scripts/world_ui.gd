extends Node

@onready var unit_ui := $UnitUI
@onready var ui_canvas := $UICanvas
@onready var path_ui := $PathUI


func _ready() -> void:
	apply_settings()


func setup(units: Array[Unit], teams: Node, map: TileMapLayer) -> void:
	for c: Node in [unit_ui, ui_canvas, path_ui]:
		c.units = units
		c.teams = teams
		c.map = map
	
	path_ui.setup()
	ui_canvas.setup()


func apply_settings() -> void:
	unit_ui.apply_settings()
	ui_canvas.apply_settings()
	path_ui.apply_settings()
