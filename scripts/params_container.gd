extends VBoxContainer

@export var param_container_scene: PackedScene

func setup(param_def_array: Array[ParameterDef]) -> void:
	for p in param_def_array:
		var param_container := param_container_scene.instantiate()
		add_child(param_container)
		param_container.setup(p)
