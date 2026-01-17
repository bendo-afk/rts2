extends Node2D
class_name World

var units: Array[Unit]
var map: TileMapLayer

var match_rule: MatchRule

@export var unit_scene: PackedScene
@export var map_scene: PackedScene

@onready var teams := $Teams

@onready var height_system := $HeightSystem
@onready var vision_system := $VisionSystem
@onready var score_system := $ScoreSystem
@onready var move_system := $MoveSystem
@onready var shoot_system := $ShootSystem

@onready var ex_con := $ExternalControl
@onready var world_ui := $WorldUI


func setup(ally_params: Array[Dictionary], enemy_params: Array[Dictionary]) -> void:
	setup_map()
	
	setup_units(ally_params, teams.ally)
	setup_units(enemy_params, teams.enemy)
	
	setup_systems()
	
	ex_con.units = units
	ex_con.map = map
	ex_con.teams = teams
	
	world_ui.setup(units, teams, map)


func _physics_process(delta: float) -> void:
	height_system.physics()
	move_system.physics(delta)
	score_system.physics(delta)
	vision_system.physics()
	shoot_system.physics()


func setup_units(params_arr: Array[Dictionary], team: Team) -> void:
	for d in params_arr:
		setup_a_unit(d, team)

func setup_a_unit(param_dict: Dictionary, team: Team) -> void:
	var unit := unit_scene.instantiate()
	add_child(unit)
	unit.height_request.connect(height_system.try_start)
	unit.team = team
	var tile := Vector2i(0,0) if team == teams.ally else Vector2i(map.n_x - 1, map.n_y - 1)
	unit.setup(param_dict["hp"],
			param_dict["damage"],
			param_dict["speed"],
			param_dict["height"],
			map.map_to_local(tile),
			match_rule.damage_to_reload,
			match_rule.speed_to_traverse,
			match_rule.angle_margin)
	unit.tree_exiting.connect(remove_unit.bind(unit))
	units.append(unit)
	

func remove_unit(u: Unit) -> void:
	units.erase(u)


func setup_map() -> void:
	map = map_scene.instantiate()
	add_child(map)
	
	map.max_height = match_rule.max_height
	map.n_x = match_rule.n_x
	map.n_y = match_rule.n_y
	map.map_mode = match_rule.map_mode
	
	map.setup()


func setup_systems() -> void:
	var childs := get_children(false)
	for c in childs:
		if c is System:
			c.units = units
			c.map = map
			c.teams = teams

	setup_move()
	setup_vision()
	setup_height()
	setup_score()


func setup_move() -> void:
	move_system.diff_to_speed = match_rule.height_diff_to_speed


func setup_vision() -> void:
	vision_system.margin_s = match_rule.s_margin
	vision_system.margin_l = match_rule.l_margin


func setup_height() -> void:
	for t in teams.get_children(false):
		t.max_height_cd = match_rule.height_cd

	for u in units:
		u.height_action_comp.max_timer = match_rule.height_action_time


func setup_score() -> void:
	score_system.score_interval = match_rule.score_interval
	score_system.score_kaisuu = match_rule.score_kaisuu
	score_system.base_point = match_rule.score_base
	score_system.dist2pena = match_rule.dist_to_penalty
