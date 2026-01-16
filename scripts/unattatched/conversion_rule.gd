extends Resource
class_name ConversionRule

@export var base: float
@export var growth: float
@export var exponent: float
# base + growth * (value ^ exponent)

func convert(value: float) -> float:
	return base + growth * (value ** exponent)
