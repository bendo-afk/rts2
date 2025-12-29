extends Node2D

# parameters to set
var max_hp: int

var hp: int

signal die
signal hp_changed(hp_arg: int, max_hp_arg: int)

func take_damage(damage: int) -> void:
	hp -= damage
	hp_changed.emit(hp, max_hp)
	if hp <= 0:
		die.emit()
