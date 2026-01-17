extends Control
class_name BarBase

var ratio := 1.0

var bg_color: Color
var main_color: Color
var x_size: float
var y_size: float

var bg: ColorRect
var main: ColorRect


func _ready() -> void:
	bg = ColorRect.new()
	add_child(bg)
	bg.size.x = x_size
	bg.size.y = y_size
	main = ColorRect.new()
	add_child(main)
	main.size.x = x_size
	main.size.y = y_size

func set_raito(r: float) -> void:
	ratio = clampf(r, 0.0, 1.0)
	main.size.x = bg.size.x * ratio
