extends VBoxContainer

@export var params_container: PackedScene


func setup(arr: Array[ParameterDef], num: int) -> void:
	for i in num:
		var params_con := params_container.instantiate()
		add_child(params_con)
		params_con.setup(arr)


func get_units_params() -> Array[Dictionary]:
	var arr: Array[Dictionary] = []
	for c in get_children():
		arr.append(c.get_parameters())
	arr.sort_custom(sort_params)
	return arr


func sort_params(a: Dictionary, b: Dictionary) -> bool:
	if a["hp"] > b["hp"]:
		return true
	elif a["hp"] < b["hp"]:
		return false
	elif a["damage"] > b["damage"]:
		return true
	else:
		return false
	
