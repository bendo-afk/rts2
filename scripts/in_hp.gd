extends HBoxContainer

var unit: Unit

@onready var name_label := $Name
@onready var hp_bar := $Bars/HPBar
@onready var hp_label := $Bars/HPBar/HPLabel
@onready var reload_bar := $Bars/ReloadBar


func set_font_size(font_size: float) -> void:
	name_label.add_theme_font_size_override("font_size", font_size)


func follow(offset: Vector2) -> void:
	var screen_pos :=  unit.get_global_transform_with_canvas().origin
	position = screen_pos + offset


func set_hp(hp: int, max_hp: int) -> void:
	hp_bar.set_ratio(1.0 * hp / max_hp)
	#hp_label.text = str(hp) + "/" + str(max_hp)
	hp_label.text = str(hp)


func set_reload(left_time: float, max_time: float) -> void:
	var r := 1.0 if left_time == 0 else left_time / max_time
	
	reload_bar.set_ratio(r)


func set_unit_name(name_str: String) -> void:
	name_label.text = name_str


func apply_bar_settings(is_ally: bool) -> void:
	var s := GlobalSettings.ui_settings
	
	var hp_y := s.in_font_size * s.in_hp_ratio
	var size_vec := Vector2(s.in_bar_x, hp_y)
	var main_color := s.ally_color if is_ally else s.enemy_color
	hp_bar.apply_delayed_settings(size_vec, s.bar_bg, main_color, s.delayed_bar_alpha)

	hp_bar.move_child(hp_label, -1)
	hp_label.add_theme_font_size_override("font_size", hp_y)
	hp_label.call_deferred("set_anchors_and_offsets_preset", Control.PRESET_CENTER)
	
	var reload_y := s.in_font_size * (1 - s.in_hp_ratio)
	size_vec.y = reload_y
	reload_bar.apply_settings(size_vec, s.bar_bg, s.in_reload_color)
