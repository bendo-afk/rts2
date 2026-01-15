extends Control

var units: Array[Unit]
var team: Team

var unit_to_ui: Dictionary[Unit, HBoxContainer] = {}

@export var in_hp_scene: PackedScene
@export var stack_offset := Vector2(0, 0)

func _process(_delta: float) -> void:
	var groups: Dictionary[Vector2, Array]= {}

	# 1. 位置が近いユニットをグループ化
	for u: Unit in unit_to_ui.keys():
		var key := u.global_position.round()
		if not groups.has(key):
			groups[key] = []
		groups[key].append(u)

	# 2. グループ内でUIをずらす
	for key in groups:
		var list := groups[key]
		for i in list.size():
			var u: Unit = list[i]
			var ui := unit_to_ui[u]
			ui.follow(stack_offset * i)

func setup() -> void:
	for u in units:
		if u.team == team:
			var in_hp := in_hp_scene.instantiate()
			add_child(in_hp)
			
			in_hp.unit = u
			in_hp.set_unit_name("1")
			in_hp.set_hp(u.hp_comp.hp, u.hp_comp.max_hp)
			
			u.hp_comp.hp_changed.connect(in_hp.set_hp)
			u.attack_comp.reload_changed.connect(in_hp.set_reload)
			
			if u.team != team:
				in_hp.visible = false
			unit_to_ui[u] = in_hp
			u.tree_exiting.connect(remove_unit.bind(u))


func remove_unit(u: Unit) -> void:
	unit_to_ui[u].queue_free()
	unit_to_ui.erase(u)
