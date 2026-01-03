extends Control

var match_rule: MatchRule
var params_container: VBoxContainer

func _ready() -> void:
	match_rule = MatchRule.new()
	params_container = $ParamsContainer
	setup()

func setup() -> void:
	var arr: Array[ParameterDef] = [match_rule.hp_def, match_rule.damage_def, match_rule.speed_def, match_rule.height_def]
	params_container.setup(arr)
