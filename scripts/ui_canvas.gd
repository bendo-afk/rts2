extends CanvasLayer

var units: Array[Unit]
var teams: Node
var map: TileMapLayer

@onready var sides_container := $SidesContainer
@onready var top_container := $TopContainer
@onready var in_ui := $InUI

func setup() -> void:
	top_container.teams = teams
	top_container.setup()

	sides_container.units = units
	sides_container.teams = teams
	sides_container.setup()
	
	in_ui.units = units
	in_ui.team = teams.ally
	in_ui.setup()
