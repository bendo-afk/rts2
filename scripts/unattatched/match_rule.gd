extends RefCounted

class_name MatchRule

# about units
var n_unit: int = 7

var parameter_count: int = 3

var hp_def: ParameterDef
var damage_def: ParameterDef
var speed_def: ParameterDef
var height_def: ParameterDef


var speed_to_traverse: ConversionRule
var damage_to_reload: ConversionRule

# map
var n_height: int = 5
var x_map: int = 20
var y_map: int = 20

# system
var angle_margin: float = 0.1
var height_diff_to_speed: ConversionRule

var l_margin: float = 0
var s_margin: float = 0

var height_cd: float = 10
var height_action_time: float = 1

var score_interval: float = 9
var socre_kaisuu: int = 3
var score_base: float = 10
var dist_to_penalty: ConversionRule

func _init() -> void:
	hp_def = preload("res://resources/hp_def.tres")
	damage_def = preload("res://resources/damage_def.tres")
	speed_def = preload("res://resources/speed_def.tres")
	height_def = preload("res://resources/height_def.tres")
	speed_to_traverse = preload("res://resources/speed2traverse.tres")
	damage_to_reload = preload("res://resources/damage2reload.tres")
	height_diff_to_speed = preload("res://resources/diff_to_speed.tres")
	dist_to_penalty = preload("res://resources/dist2penalty.tres")
