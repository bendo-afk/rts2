extends VBoxContainer

var hp_bars: Array[HBoxContainer]

var units: Array[Unit]
var team: Team

@export var side_hp_scene: PackedScene


func setup() -> void:
	for u in units:
		if u.team == team:
			var hp_bar := side_hp_scene.instantiate()
			add_child(hp_bar)
			hp_bar.set_parameters(u.move_comp.speed, u.attack_comp.damage, u.vision_comp.height)
			hp_bar.set_unit_name("1")
			hp_bar.set_hp(u.hp_comp.hp, u.hp_comp.max_hp)
			u.hp_comp.hp_changed.connect(hp_bar.set_hp)
			u.attack_comp.reload_changed.connect(hp_bar.set_reload)
	
