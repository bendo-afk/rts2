extends Node

class_name Team
var max_height_cd: int
var left_height_cd := 0.0
var locked_unit: Unit = null
var height_action := HeightAction.new()


func physics(delta: float) -> void:
	left_height_cd = maxf(0, left_height_cd - delta)
	

func can_start_height_action() -> bool:
	return left_height_cd <= 0 and locked_unit == null

func lock(unit: Unit) -> void:
	locked_unit = unit

func unlock() -> void:
	locked_unit = null

func start_cooldown() -> void:
	left_height_cd = max_height_cd
