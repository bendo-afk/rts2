extends Node

var units: Array[Unit]
var map: TileMapLayer
var teams: Node

func set_path(click_pos: Vector2) -> void:
	for u in units:
		if u.selected and u.team == teams.ally:
			var to_tile := map.local_to_map(click_pos)
			if u.move_comp.moving_weight != 0:
				var added_path_2i: PackedVector2Array = map.calc_path(u.path_2i[1], to_tile)
				u.path_2i.resize(1)
				u.path_2i.append_array(added_path_2i)
			else:
				var from_tile := map.local_to_map(u.position)
				u.path_2i = map.calc_path(from_tile, to_tile)

func set_target_pos(click_pos: Vector2) -> void:
	for u in units:
		if u.selected and u.team == teams.ally:
			u.attack_comp.target_pos = click_pos

func change_height(click_pos: Vector2, is_raise: bool) -> void:
	for u in units:
		if u.selected and u.team == teams.ally:
			u.request_height_change(click_pos, is_raise)

func select_by_box(rect: Rect2) -> void:
	for u in units:
		if u.team == teams.ally:
			if rect.has_point(u.position):
				u.selected = true

func deselect() -> void:
	for u in units:
		u.selected = false
