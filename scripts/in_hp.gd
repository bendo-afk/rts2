extends HBoxContainer

var unit: Unit

@onready var  hp_label := $HP
@onready var reload_label := $Reload
@onready var name_label := $Name


func set_font_size(font_size: float) -> void:
	for c in get_children(false):
		c.add_theme_font_size_override("font_size", font_size)


func follow(offset: Vector2) -> void:
	var screen_pos :=  unit.get_global_transform_with_canvas().origin
	position = screen_pos + offset


func set_hp(hp: int, max_hp: int) -> void:
	hp_label.text = str(hp) + "/" + str(max_hp)


func set_reload(left_time: float, max_time: float) -> void:
	reload_label.text = str(left_time) + "/" + str(max_time)


func set_unit_name(name_str: String) -> void:
	name_label.text = name_str
