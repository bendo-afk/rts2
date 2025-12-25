extends System

var units: Array[Unit]
var map: TileMapLayer
# parameter to set
var margin_s: float = 0
var margin_l: float = 0

func _process(_delta: float) -> void:
	if Input.is_action_pressed("test"):
		#print("state", is_visible(units[0].position, map.map_to_local(Vector2i(3,3)), 0, 0))
		print("state", is_visible(Vector2(224,240.5), map.map_to_local(Vector2i(3,3)), 0, 0))

func get_tiles_between(from_pos: Vector2, to_pos: Vector2) -> Array:
	var to_tile := map.local_to_map(to_pos)
	
	var nexts: Array[Vector2i]
	var cur1: Vector2i
	var cur2: Vector2i
	var last1: Vector2i
	var last2: Vector2i
	
	cur1 = map.local_to_map(from_pos)
	cur2 = Vector2i(-1, -1)
	
	var max_dist: float = 0
	var max_index: int = 0
	for i in range(6):
		var d := to_pos.distance_to(get_vertex_pos(cur1, i))
		if d > max_dist:
			max_dist = d
			max_index = i
	last1 = get_adjacent_tile(cur1, max_index)
	last2 = get_adjacent_tile(cur1, (max_index + 5) % 6)
	
	var tiles := []
	while true:
		tiles.append(cur1)
		if cur2 != Vector2i(-1, -1):
			tiles.append(cur2)
		if cur1 == to_tile:
			break
		nexts = []
		next_hexas(cur1, cur2, nexts, last1, last2, from_pos, to_pos)
		if cur2 != Vector2i(-1, -1):
			next_hexas(cur2, cur1, nexts, last1, last2, from_pos, to_pos)
		last1 = cur1
		last2 = cur2
		cur1 = nexts[0]
		if nexts.size() > 1:
			cur2 = nexts[1]
		else:
			cur2 = Vector2i(-1, -1)
	return tiles

func next_hexas(cur: Vector2i, cur2: Vector2i, nexts: Array[Vector2i], last1: Vector2i, last2: Vector2i, pos1: Vector2, pos2: Vector2) -> void:
	var tile: Vector2i
	
	for i in range(6):
		var turn1 := turn(pos1, pos2, get_vertex_pos(cur, i))
		var turn2 := turn(pos1, pos2, get_vertex_pos(cur, (i+1)%6 ))
		if (turn1 == 0 or turn2 == 0 or turn1 != turn2):
			tile = get_adjacent_tile(cur, i)
			if (tile != cur and tile != cur2 and (not nexts.has(tile)) and tile != last1 and tile != last2):
				if nexts.size() == 0:
					nexts.append(tile)
				elif nexts.size() == 1:
					nexts.append(tile)
			if turn1 == 0:
				tile = get_adjacent_tile(cur, (i + 5) % 6)
				if (tile != cur and tile != cur2 and (not nexts.has(tile)) and tile != last1 and tile != last2):
					if nexts.size() == 0:
						nexts.append(tile)
					elif nexts.size() == 1:
						nexts.append(tile)
			if turn2 == 0:
				tile = get_adjacent_tile(cur, (i + 1) % 6)
				if (tile != cur and tile != cur2 and (not nexts.has(tile)) and tile != last1 and tile != last2):
					if nexts.size() == 0:
						nexts.append(tile)
					elif nexts.size() == 1:
						nexts.append(tile)

func turn(pos0: Vector2, pos1: Vector2, pos2: Vector2) -> int:
	var cross := (pos1 - pos0).cross(pos2 - pos0)
	return sign(cross)

func get_vertex_pos(tile: Vector2i, index: int) -> Vector2:
	var hsize: float = map.hsize
	var vsize: float = map.vsize
	var center_pos := map.map_to_local(tile)
	
	if index == 0:
		return center_pos + Vector2(0,-vsize/2.0)
	if index == 1:
		return center_pos + Vector2(hsize/2.0,-vsize/4.0)
	if index == 2:
		return center_pos + Vector2(hsize/2.0,vsize/4.0)
	if index == 3:
		return center_pos + Vector2(0,vsize/2.0)
	if index == 4:
		return center_pos + Vector2(-hsize/2.0,vsize/4.0)
	if index == 5:
		return center_pos + Vector2(-hsize/2.0,-vsize/4.0)
	return Vector2.ZERO

func get_adjacent_tile(tile: Vector2i, index: int) -> Vector2i:
	var offsets: Array[Vector2i]
	if tile.y % 2:
		offsets = [
			Vector2(1, -1),
			Vector2(1, 0),
			Vector2(1, 1),
			Vector2(0, 1),
			Vector2(-1, 0),
			Vector2(0, -1)
		]
	else:
		offsets = [
			Vector2(0, -1),
			Vector2(1, 0),
			Vector2(0, 1),
			Vector2(-1, 1),
			Vector2(-1, 0),
			Vector2(-1, -1)
		]
	return tile + offsets[index]


func is_visible(from_pos: Vector2, to_pos: Vector2, unit_height1: float, unit_height2: float) -> CustomEnums.VisibleState:
	var to_tile := map.local_to_map(to_pos)
	
	var nexts: Array[Vector2i]
	var cur1: Vector2i
	var cur2: Vector2i
	var last1: Vector2i
	var last2: Vector2i
	
	cur1 = map.local_to_map(from_pos)
	cur2 = Vector2i(-1, -1)
	if cur1 == to_tile:
		return CustomEnums.VisibleState.VISIBLE
	
	var max_dist: float = 0
	var max_index: int = 0
	for i in range(6):
		var d := to_pos.distance_to(get_vertex_pos(cur1, i))
		if d > max_dist:
			max_dist = d
			max_index = i
	last1 = get_adjacent_tile(cur1, max_index)
	last2 = get_adjacent_tile(cur1, (max_index + 5) % 6)
	
	var tile1 := map.local_to_map(from_pos)
	var tile2 := map.local_to_map(to_pos)
	var height1 := unit_height1 + map.get_cell_source_id(tile1)
	var height2 := unit_height2 + map.get_cell_source_id(tile2)
	var slope := (height2 - height1) / calc_dist(tile1, tile2)
	
	var min_margin := INF
	
	
	for i in range(100):
		print(nexts)
		#if i > 90:
			#print(from_pos)
		nexts = []
		next_hexas(cur1, cur2, nexts, last1, last2, from_pos, to_pos)
		if cur2 != Vector2i(-1, -1):
			next_hexas(cur2, cur1, nexts, last1, last2, from_pos, to_pos)
		last1 = cur1
		last2 = cur2
		if nexts.has(to_tile):
			break
		cur1 = nexts[0]
		if nexts.size() > 1:
			cur2 = nexts[1]
		else:
			cur2 = Vector2i(-1, -1)
		for n in nexts:
			var t_height := map.get_cell_source_id(n)
			var t_dist := calc_dist(tile1, n)
			var t_margin := (slope * t_dist) + height1 - t_height
			if t_margin < min_margin:
				if t_margin + margin_l < 0:
					return CustomEnums.VisibleState.NOT
				min_margin = t_margin

	if min_margin + margin_s < 0:
		return CustomEnums.VisibleState.HALF
	else:
		return CustomEnums.VisibleState.VISIBLE



func calc_dist(a: Vector2, b: Vector2) -> int:
	var ac := oddr_to_axial(a)
	var bc := oddr_to_axial(b)
	return axial_dist(ac, bc)

func oddr_to_axial(tile: Vector2i) -> Vector2i:
	var parity := tile.y&1
	var q := int(tile.x - (tile.y - parity) / 2.0)
	var r := tile.y
	return Vector2i(q, r)

func axial_dist(a: Vector2i, b: Vector2i) -> int:
	return (abs(a.x - b.x) + abs(a.x + a.y - b.x - b.y) + abs(a.y - b.y)) /2
