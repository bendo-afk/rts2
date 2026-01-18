extends HBoxContainer

@onready var name_label := $Name
@onready var parameters_label := $Parameters
@onready var hp_bar := $HPBar
@onready var hp_label := $HPBar/HPLabel
@onready var reload_label := $Reload


func set_label_sizes(font_size: float) -> void:
	for c in get_children(false):
		c.add_theme_font_size_override("font_size", font_size)


func set_parameters(speed: int, damage: int, height: float) -> void:
	parameters_label.text = str(damage) + "/" + str(speed) + "/" + str(height)


func set_hp(hp: int, max_hp: int) -> void:
	hp_bar.set_ratio(1.0 * hp / max_hp)
	hp_label.text = str(hp) + "/" + str(max_hp)


func set_reload(left_time: float, max_time: float) -> void:
	reload_label.text = "%.1f/%.1f" % [left_time, max_time]


func set_unit_name(name_str: String) -> void:
	name_label.text = name_str


func apply_settings(is_ally: bool) -> void:
	var s := GlobalSettings.ui_settings
	var font_size := s.side_font_size
	
	for c: Label in [
		name_label,
		parameters_label,
		hp_label,
		reload_label,
	]:
		c.add_theme_font_size_override("font_size", font_size)
	
	var size_vec := Vector2(s.side_bar_x, font_size)
	var main_color := s.ally_color if is_ally else s.enemy_color
	hp_bar.apply_delayed_settings(size_vec, s.bar_bg, main_color, s.delayed_bar_alpha)
	hp_bar.set_v_size_flags(Control.SIZE_SHRINK_CENTER)

	hp_bar.move_child(hp_label, -1)
	hp_label.call_deferred("set_anchors_and_offsets_preset", Control.PRESET_CENTER)
	
	if not is_ally:
		layout_direction = Control.LAYOUT_DIRECTION_RTL
