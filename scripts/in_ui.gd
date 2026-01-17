extends Control

var units: Array[Unit]
var team: Team

var unit_to_ui: Dictionary[Unit, HBoxContainer] = {}

@export var in_hp_scene: PackedScene
@export var stack_offset := Vector2(0, 0)
@export var base_stack_offset := Vector2(0, 0)

func _process(_delta: float) -> void:
	var groups: Dictionary[Vector2, Array]= {}

	# 1. 位置が近いユニットをグループ化
	for u: Unit in unit_to_ui.keys():
		unit_to_ui[u].visible = false
		if u.team == team or u.vision_comp.visible_state == CustomEnums.VisibleState.VISIBLE:
			unit_to_ui[u].visible = true
			
			var key := u.global_position.round()
			if not groups.has(key):
				groups[key] = []
			groups[key].append(u)

	# 2. グループ内でUIをずらす
	for key in groups:
		var list := groups[key]
		list.reverse()
		for i in list.size():
			var u: Unit = list[i]
			var ui := unit_to_ui[u]
			ui.follow(stack_offset * i)


func setup() -> void:
	for u in units:
		var in_hp := in_hp_scene.instantiate()
		add_child(in_hp)
		
		in_hp.unit = u
		unit_to_ui[u] = in_hp
		
		u.hp_comp.hp_changed.connect(in_hp.set_hp)
		u.attack_comp.reload_changed.connect(in_hp.set_reload)
		
		u.tree_exiting.connect(remove_unit.bind(u))
	
	apply_settings()
	
	for u in units:
		unit_to_ui[u].set_hp(u.hp_comp.hp, u.hp_comp.max_hp)
		#print(unit_to_ui[u].hp_bar.visible)


func remove_unit(u: Unit) -> void:
	unit_to_ui[u].queue_free()
	unit_to_ui.erase(u)


func apply_settings() -> void:
	var s := GlobalSettings.ui_settings
	
	var font_size := s.in_font_size
	var names := s.names
	
	stack_offset = base_stack_offset
	stack_offset.y = - font_size
	
	for ui: HBoxContainer in unit_to_ui.values():
		ui.set_font_size(font_size)
	
	apply_bar_settings()
	apply_names(names)


func apply_names(names: Array) -> void:
	var indices := [0, 0]
	
	for u: Unit in unit_to_ui.keys():
		var team_index := 0 if u.team == team else 1
		var ui := unit_to_ui[u]

		if indices[team_index] < names.size():
			ui.set_unit_name(names[indices[team_index]])
		else:
			ui.set_unit_name("")

		indices[team_index] += 1


func apply_bar_settings() -> void:
	for u in units:
		var is_ally := true if u.team == team else false
		unit_to_ui[u].apply_bar_settings(is_ally)
