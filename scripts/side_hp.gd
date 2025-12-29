extends HBoxContainer

@onready var name_label := $Name
@onready var parameters_label := $Parameters
@onready var reload_label := $Reload
@onready var hp_label := $HP

func set_parameters(speed: int, damage: int, height: float) -> void:
	parameters_label.text = str(speed) + "/" + str(damage) + "/" + str(height)

func set_hp(hp: int, max_hp: int) -> void:
	hp_label.text = str(hp) + "/" + str(max_hp)

func set_reload(left_time: float, max_time: float) -> void:
	reload_label.text = str(left_time) + "/" + str(max_time)

func set_unit_name(name_str: String) -> void:
	name_label.text = name_str
