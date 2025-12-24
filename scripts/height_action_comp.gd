extends Node2D


var is_changing: bool
var max_timer: float
var left_timer: float

func physics(delta: float) -> void:
	if is_changing:
		left_timer -= delta
