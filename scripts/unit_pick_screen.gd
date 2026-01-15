extends Control

var match_rule: MatchRule

@export var battle_scene: PackedScene

@onready var units_container := $UnitsContainer
@onready var ok_button := $OKButton

func _ready() -> void:
	match_rule = MatchRule.new()
	setup()
	
	ok_button.pressed.connect(go_battle)


func setup() -> void:
	var arr: Array[ParameterDef] = [
		match_rule.hp_def,
		match_rule.damage_def,
		match_rule.speed_def,
		match_rule.height_def,
	]
	units_container.setup(arr, match_rule.n_unit)


func go_battle() -> void:
	var battle := battle_scene.instantiate()
	var node_a := get_tree().current_scene
	get_tree().root.add_child(battle)
	get_tree().current_scene = battle
	node_a.call_deferred("free")

	var ally_params: Array = units_container.get_units_params()
	battle.setup(ally_params, ally_params)
