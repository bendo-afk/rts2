extends Node

signal move_completed


# parameters to set
var speed: int
# status
var moving_weight: float = 0
# control
var target_pos: Vector2

func move_to_next(from_pos: Vector2, to_pos: Vector2, speed_multiplier: float, delta: float) -> void:
	var effective_speed := speed_multiplier * speed
	moving_weight = clampf(moving_weight + effective_speed * delta, 0, 1)
	get_parent().position = lerp(from_pos, to_pos, moving_weight)
	if moving_weight == 1:
		complete_move()

func complete_move() -> void:
	moving_weight = 0
	move_completed.emit()
