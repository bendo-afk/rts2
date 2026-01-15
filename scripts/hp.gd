extends Node2D

# parameters to set
var max_hp: int

var hp: int

#signal die
signal hp_changed(hp_arg: int, max_hp_arg: int)
#signal died(unit: Unit)

func take_damage(damage: int) -> void:
	hp = maxi(0, hp - damage)
	hp_changed.emit(hp, max_hp)
	if hp <= 0:
		get_parent().queue_free()
		#died.emit(get_parent())
