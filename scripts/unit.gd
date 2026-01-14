extends Node2D
class_name Unit

signal path_changed
signal height_request(unit: Unit, pos: Vector2, is_raise: bool)

#components
@onready var hp_comp := $HPComp
@onready var attack_comp := $AttackComp
@onready var move_comp := $MoveComp
@onready var height_action_comp := $HeightActionComp
@onready var vision_comp := $VisionComp

var team: Team
var selected: bool
# visible status
var path_2i: PackedVector2Array:
	set(value):
		path_2i = value
		path_changed.emit()


func _ready() -> void:
	connect_signals()


func connect_signals() -> void:
	move_comp.move_completed.connect(_on_move_completed)


func setup(hp: int, damage: int, speed: int, height: float, pos: Vector2) -> void:
	hp_comp.max_hp = hp
	hp_comp.hp = hp
	attack_comp.damage = damage
	attack_comp.max_reload_time = damage
	attack_comp.traverse_speed = speed
	move_comp.speed = speed
	vision_comp.height = height
	position = pos

func _on_move_completed() -> void:
	remove_path(0)


func request_height_change(pos: Vector2, is_raise: bool) -> void:
	if height_action_comp.is_changing or move_comp.moving_weight != 0:
		return
	height_request.emit(self, pos, is_raise)


func add_path(x: PackedVector2Array) -> void:
	path_2i.append_array(x)
	path_changed.emit()


func remove_path(i: int) -> void:
	path_2i.remove_at(i)
	path_changed.emit()
