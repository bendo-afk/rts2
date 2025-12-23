extends Node2D

# parameters to set
var max_hp: int

var hp: int

signal die

func take_damage(damage: int) -> void:
	hp -= damage
	if hp <= 0:
		die.emit()
