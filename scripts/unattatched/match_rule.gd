extends RefCounted

class_name MatchRule

# about units
var n_unit: int = 7

var parameter_count: int = 3

var hp_def := preload("res://resources/hp_def.tres")
var damage_def := preload("res://resources/damage_def.tres")
var speed_def := preload("res://resources/speed_def.tres")
var height_def := preload("res://resources/height_def.tres")


var speed_to_traverse := preload("res://resources/speed2traverse.tres")
var damage_to_reload := preload("res://resources/damage2reload.tres")

# map
var max_height: int = 5
var n_x: int = 20
var n_y: int = 20

# system
var angle_margin: float = 0.1
var height_diff_to_speed := preload("res://resources/diff_to_speed.tres")

var l_margin: float = 0
var s_margin: float = 0

var height_cd: float = 10
var height_action_time: float = 1

var score_interval: float = 9
var socre_kaisuu: int = 3
var score_base: float = 10
var dist_to_penalty := preload("res://resources/dist2penalty.tres")
