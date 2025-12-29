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
@onready var vision_comp := $VisionComp

# visible status
var path_2i: PackedVector2Array:
	set(value):
		path_2i = value
		path_changed.emit()

signal path_changed

func _ready() -> void:
	connect_signals()

func connect_signals() -> void:
	move_comp.move_completed.connect(_on_move_completed)

func setup(hp: int, damage: int, speed: int, height: float, pos: Vector2) -> void:
	attack_comp.traverse_speed = speed
	attack_comp.damage = damage
	hp_comp.max_hp = hp
	vision_comp.height = height
	move_comp.speed = speed
	position = pos

func _on_move_completed() -> void:
	remove_path(0)

func request_height_change(pos: Vector2, is_raise: bool) -> void:
	if height_action_comp.is_changing or move_comp.moving_weight != 0:
		return
	world.height_system.try_start(self, pos, is_raise)

func add_path(x: PackedVector2Array) -> void:
	path_2i.append_array(x)
	path_changed.emit()

func remove_path(i: int) -> void:
	path_2i.remove_at(i)
	path_changed.emit()
