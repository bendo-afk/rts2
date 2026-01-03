extends Resource

class_name ParameterDef

@export var name: String

@export var min_value: float
@export var step: float


func to_level(x: float) -> int:
	return int((x - min_value) / step) + 1

func set_values(name_arg: String, min_arg: float, step_arg: float) -> void:
	name = name_arg
	min_value = min_arg
	step = step_arg
