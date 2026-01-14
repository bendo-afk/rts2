extends System

var units: Array[Unit]
var map: TileMapLayer
var teams: Node


func physics(delta: float) -> void:
	for u in units:
		move_a_unit(u, delta)
		u.attack_comp.physics(delta)


func move_a_unit(unit: Unit, delta: float) -> void:
	var path_2i := unit.path_2i
	if path_2i.size() < 2:
		return
	var from_pos := map.map_to_local(path_2i[0])
	var to_pos := map.map_to_local(path_2i[1])
	
	var from_height := map.get_cell_source_id(path_2i[0])
	var to_height := map.get_cell_source_id(path_2i[1])
	var height_diff := to_height - from_height
	var speed_multiplier: float = unit.move_comp.height_diff_to_speed(height_diff)
	
	unit.move_comp.move_to_next(from_pos, to_pos, speed_multiplier, delta)
