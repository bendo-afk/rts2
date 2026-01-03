extends VBoxContainer

var param_name: String
var trade_off: bool

@onready var label := $Label
@onready var param_slider := $ParamSlider
@onready var tick_labels := $TickLabels

func setup(param_def: ParameterDef) -> void:
	param_name = param_def.name
	param_slider.setup(param_def.min_value, param_def.step, param_def.count)
	trade_off = param_def.trade_off
	setup_label()
	tick_labels.setup_ticks(param_def)

func setup_label() -> void:
	label.text = param_name
