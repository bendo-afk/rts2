extends Node2D

# parameters to set
var damage: int
var traverse_speed: float
# endogenous
var max_reload_time: float
# status
var left_reload_time: float
var turret_angle: float
# control
var target_pos: Vector2


func _ready() -> void:
	left_reload_time = max_reload_time

func pseudo_process(delta: float) -> void:
	var rel_target_pos := calc_rel_target_pos(get_parent().position, target_pos)
	rotate_turret(rel_target_pos, delta)
	left_reload_time = max(0, left_reload_time - delta)

func shoot(target: Unit) -> int:
	target.hp_comp.take_damge()
	left_reload_time = max_reload_time
	return damage

func calc_rel_target_pos(unit_pos: Vector2, global_target_pos: Vector2) -> Vector2:
	return global_target_pos - unit_pos


func rotate_turret(rel_target_pos: Vector2, delta: float) -> void:
	var to_angle := rel_target_pos.angle()
	turret_angle = rotate_toward(turret_angle, to_angle, traverse_speed * PI * delta)
	
