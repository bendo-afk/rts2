extends Node2D

# parameters to set
var speed: int

# status
var moving_weight: float

# control
var target_pos: Vector2

func move_to_next(from_pos: Vector2, to_pos: Vector2, delta: float) -> void:
	moving_weight = clampf(moving_weight + speed * delta, 0, 1)
	position = lerp(from_pos, to_pos, moving_weight)
	if moving_weight == 1:
		complete_move()

func complete_move() -> void:
	pass
