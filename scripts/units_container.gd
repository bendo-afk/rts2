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
	return arr
