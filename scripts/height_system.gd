extends System

var units: Array[Unit]
var map: TileMapLayer

var teams: Array

func try_start(unit: Unit, pos: Vector2, is_raise: bool) -> void:
	var team: Team = unit.team
	var tile := map.local_to_map(pos)
	if not team.can_start_height_action():
		return
	if not can_unit_change_height(unit, tile, is_raise):
		return

	unit.height_action_comp.is_changing = true
	team.lock(unit)
	team.height_action.tile = tile
	team.height_action.is_raise = is_raise

func can_unit_change_height(unit: Unit, tile: Vector2i, is_raise: bool) -> bool:
	if not map.is_movable_adjacent(map.pos_to_tile(unit.position), tile):
		return false
	if not map.can_change_height(tile, is_raise):
		return false
	return true

func physics(_delta: float) -> void:
	for t: Team in teams:
		var u: Unit = t.locked_unit
		if u:
			if u.height_comp.left_timer <= 0:
				excecute(t)

func excecute(team: Team) -> void:
	map.change_height(team.height_action)
	
	var height_comp: Node2D = team.locked_unit.height_action_comp
	height_comp.is_changing = false
	height_comp.left_timer = height_comp.max_timer
	team.unlock()
	team.start_cooldown()
