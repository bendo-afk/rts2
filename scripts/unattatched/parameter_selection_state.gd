extends RefCounted
class_name ParameterSelectionState

signal selection_changed(name: String, index: int)

var parameter_count: int

var defs: Dictionary[String, ParameterDef] = {}
var selections: Dictionary[String, int]

func setup(param_defs: Array[ParameterDef], total_count: int) -> void:
	parameter_count = total_count
	
	defs.clear()
	selections.clear()
	
	for def in param_defs:
		defs[def.name] = def
		selections[def.name] = 0
	
func get_used_count() -> int:
	var sum: int = 0
	for name: String in selections.keys():
		var def := defs[name]
		if not def.trade_off:
			continue
		sum += selections[name]
	return sum
