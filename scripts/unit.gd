extends Node2D

class_name Unit

var team: Team
var world: World

var selected: bool
#components
@onready var hp_comp := $HPComp
@onready var attack_comp := $AttackComp
@onready var move_comp := $MoveComp
@onready var height_action_comp := $HeightActionComp

# visible status
var path_2i: PackedVector2Array

func _ready() -> void:
	connect_signals()

func connect_signals() -> void:
	move_comp.move_completed.connect(_on_move_completed)

#func process_movement(delta: float) -> void:
	#if path_2i.size() < 2:
		#return
	#var from_pos := world.pos_to_tile(path_2i[0])
	#var to_pos := world.pos_to_tile(path_2i[1])
	#
	#var from_height := world.pos_to_height(path_2i[0])
	#var to_height := world.pos_to_height(path_2i[1])
	#var height_diff := to_height - from_height
	#var speed_multiplier: float = move_comp.height_diff_to_speed(height_diff)
	#
	#move_comp.move_to_next(from_pos, to_pos, speed_multiplier, delta)

func _on_move_completed() -> void:
	path_2i.remove_at(0)

func request_height_change(pos: Vector2, is_raise: bool) -> void:
	if height_action_comp.is_changing or move_comp.moving_weight != 0:
		return
	world.height_system.try_start(self, pos, is_raise)
