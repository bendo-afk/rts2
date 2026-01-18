extends VBoxContainer

var hp_bars: Array[HBoxContainer]

var units: Array[Unit]
var team: Team
var is_ally: bool

@export var side_hp_scene: PackedScene


func setup() -> void:
	for u in units:
		if u.team != team:
			continue
		
		var hp_bar := side_hp_scene.instantiate()
		add_child(hp_bar)
		hp_bars.append(hp_bar)
		
		hp_bar.set_parameters(
			u.move_comp.speed,
			u.attack_comp.damage,
			u.vision_comp.height
		)
		
		u.hp_comp.hp_changed.connect(hp_bar.set_hp)
		u.attack_comp.reload_changed.connect(hp_bar.set_reload)
	
	apply_settings()
	
	for u in units:
		if u.team != team:
			continue
		u.hp_comp.hp_changed.emit(u.hp_comp.hp, u.hp_comp.max_hp)


func apply_settings() -> void:
	var s := GlobalSettings.ui_settings
	
	var names := s.names
	
	for i in hp_bars.size():
		var bar := hp_bars[i]
		bar.apply_settings(is_ally)
		bar.set_unit_name(names[i])
	
	call_deferred("_apply_all_widths")
	

func _apply_name_widths() -> void:
	var max_width := 0.0

	for b in hp_bars:
		var w: float = b.name_label.get_combined_minimum_size().x
		max_width = maxf(max_width, w)

	for b in hp_bars:
		b.name_label.custom_minimum_size.x = max_width


func _apply_uniform_label_width(get_label: Callable) -> void:
	var max_width := 0.0

	for b in hp_bars:
		var label: Label = get_label.call(b)
		max_width = maxf(max_width, label.get_combined_minimum_size().x)

	for b in hp_bars:
		var label: Label = get_label.call(b)
		label.custom_minimum_size.x = max_width


func _apply_all_widths() -> void:
	_apply_uniform_label_width(func(b: Node) -> Node: return b.name_label)
	_apply_uniform_label_width(func(b: Node) -> Node: return b.parameters_label)
