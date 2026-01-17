extends Control
class_name BarBase

var ratio := 1.0

var bg := ColorRect.new()
var main := ColorRect.new()


func _ready() -> void:
	add_child(bg)
	add_child(main)


func set_ratio(r: float) -> void:
	ratio = clampf(r, 0.0, 1.0)
	main.size.x = bg.size.x * ratio


func apply_settings(size_vec: Vector2, bg_color: Color, main_color: Color) -> void:
	custom_minimum_size = size_vec
	for r: ColorRect in [bg, main]:
		r.size = size_vec
	bg.color = bg_color
	main.color = main_color
