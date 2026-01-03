extends HBoxContainer

func setup_ticks(param_def: ParameterDef) -> void:
	for i in range(param_def.count):
		var label := Label.new()
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.text = str(param_def.min_value + param_def.step * i)
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		add_child(label)
