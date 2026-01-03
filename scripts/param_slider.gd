extends HSlider

func setup(min_arg: float, step_arg: float, count: int) -> void:
	min_value = min_arg
	step = step_arg
	max_value = step * (count - 1) + min_value
	tick_count = count
