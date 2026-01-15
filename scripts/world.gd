extends Node2D
class_name World

var units: Array[Unit]

@export var unit_scene: PackedScene

@onready var map := $TileMapLayer
@onready var teams := $Teams

@onready var height_system := $HeightSystem
@onready var vision_system := $VisionSystem
@onready var score_system := $ScoreSystem
@onready var move_system := $MoveSystem
@onready var shoot_system := $ShootSystem

@onready var ex_con := $ExternalControl
@onready var world_ui := $WorldUI


func setup(ally_params: Array[Dictionary], enemy_params: Array[Dictionary]) -> void:
	setup_units(ally_params, teams.ally)
	setup_units(enemy_params, teams.enemy)
	
	var childs := get_children(false)
	for c in childs:
		if c is System:
			c.units = units
			c.map = map
			c.teams = teams
	ex_con.units = units
	ex_con.map = map
	ex_con.teams = teams
	
	setup_ui()


func _physics_process(delta: float) -> void:
	height_system.physics()
	move_system.physics(delta)
	score_system.physics(delta)
	vision_system.physics()
	shoot_system.physics()


func setup_ui() -> void:
	for ui_node in world_ui.get_children(false):
		ui_node.units = units
		ui_node.teams = teams
		ui_node.map = map

	world_ui.path_ui.setup()
	world_ui.ui_canvas.setup()


func setup_units(params_arr: Array[Dictionary], team: Team) -> void:
	for d in params_arr:
		setup_a_unit(d, team)

func setup_a_unit(param_dict: Dictionary, team: Team) -> void:
	var unit := unit_scene.instantiate()
	add_child(unit)
	unit.height_request.connect(height_system.try_start)
	unit.team = team
	var tile := Vector2i(0,0) if team == teams.ally else Vector2i(map.n_x - 1, map.n_y - 1)
	unit.setup(param_dict["hp"], param_dict["damage"], param_dict["speed"], param_dict["height"], map.map_to_local(tile))
	unit.tree_exiting.connect(remove_unit.bind(unit))
	units.append(unit)
	

func remove_unit(u: Unit) -> void:
	units.erase(u)
