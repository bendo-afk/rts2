extends System

var units: Array[Unit]
var map: TileMapLayer
var teams: Node
# parameter to set
var margin_s: float = 0
var margin_l: float = 0

class Tiles:
	var last1 := Vector2i.MIN
	var last2 := Vector2i.MIN
	var cur1 := Vector2i.MIN
	var cur2 := Vector2i.MIN
	var next1 := Vector2i.MIN
	var next2 := Vector2i.MIN

class Candidates:
	var t1 := Vector2i.MIN
	var t2 := Vector2i.MIN


func physics() -> void:
	set_states()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("test"):
		#print("state", is_visible(units[0].position, map.map_to_local(Vector2i(3,3)), 0, 0))
		print("state", is_visible(units[0].position, map.map_to_local(Vector2i(3,3)), 0, 0))
		#print(get_tiles_between(units[0].position, map.map_to_local(Vector2i(3,3))))

func set_states() -> void:
	for u in units:
		u.vision_comp.visible_state = CustomEnums.VisibleState.NOT
		u.vision_comp.visible_enemies.clear()

	for a in units:
		if a.team == teams.ally:
			for e in units:
				if e.team == teams.enemy:
					var vis_state := is_visible(a.position, e.position, a.vision_comp.height, e.vision_comp.height)
					a.vision_comp.visible_state = maxi(a.vision_comp.visible_state, vis_state)
					e.vision_comp.visible_state = maxi(e.vision_comp.visible_state, vis_state)
					if vis_state == CustomEnums.VisibleState.VISIBLE:
						a.vision_comp.visible_enemies.append(e)
						e.vision_comp.visible_enemies.append(a)

func first_step(tiles: Tiles, pos1: Vector2, pos2: Vector2) -> void:
	tiles.cur1 = map.local_to_map(pos1)
	var to_tile := map.local_to_map(pos2)
	var cands1 := Candidates.new()
	var cands2 := Candidates.new()
	tiles.last1 = tiles.cur1
	for i in range(6):
		var turn1 := turn(pos1, pos2, get_vertex_pos(tiles.cur1, i))
		var turn2 := turn(pos1, pos2, get_vertex_pos(tiles.cur1, (i+1)%6 ))
		if turn1 == 0 and turn2 == 0:
			tiles.last2 = get_adjacent_tile(tiles.cur1, i)
			var tile1 := get_adjacent_tile(tiles.cur1, (i+1)%6)
			var tile5 := get_adjacent_tile(tiles.cur1, (i+5)%6)
			if calc_dist(to_tile, tile1) < calc_dist(to_tile, tile5):
				tiles.cur1 = tile1
			else:
				tiles.cur1 = tile5
			return
		elif turn1 * turn2 == -1:
			if cands1.t1 == Vector2i.MIN:
				cands1.t1 = get_adjacent_tile(tiles.cur1, i)
			else:
				cands2.t1 = get_adjacent_tile(tiles.cur1, i)
		elif turn1 == 0:
			if cands1.t1 == Vector2i.MIN:
				cands1.t1 = get_adjacent_tile(tiles.cur1, (i+5)%6)
				cands1.t2 = get_adjacent_tile(tiles.cur1, i)
			else:
				cands2.t1 = get_adjacent_tile(tiles.cur1, (i+5)%6)
				cands2.t2 = get_adjacent_tile(tiles.cur1, i)
	if calc_dist(to_tile, cands1.t1) < calc_dist(to_tile, cands2.t1):
		tiles.cur1 = cands1.t1
		if cands1.t2 != Vector2i.MIN:
			tiles.cur2 = cands1.t2
	else:
		tiles.cur1 = cands2.t1
		if cands2.t2 != Vector2i.MIN:
			tiles.cur2 = cands2.t2
		


func get_tiles_between(from_pos: Vector2, to_pos: Vector2) -> Array:
	var to_tile := map.local_to_map(to_pos)
	
	var tiles := Tiles.new()
	first_step(tiles, from_pos, to_pos)
	
	var tiles_between := []
	while true:
		
		tiles_between.append(tiles.cur1)
		if tiles.cur2 != Vector2i.MIN:
			tiles_between.append(tiles.cur2)
		if tiles.cur1 == to_tile or tiles.cur2 == to_tile:
			break
		tiles.next1 = Vector2i.MIN
		tiles.next2 = Vector2i.MIN
		next_hexas(tiles.cur1, tiles, from_pos, to_pos)
		if tiles.cur2 != Vector2i.MIN:
			next_hexas(tiles.cur2, tiles, from_pos, to_pos)
		tiles.last1 = tiles.cur1
		tiles.last2 = tiles.cur2
		tiles.cur1 = tiles.next1
		tiles.cur2 = tiles.next2
	return tiles_between

func next_hexas(cur1: Vector2i, tiles: Tiles, pos1: Vector2, pos2: Vector2) -> void:
	var tile: Vector2i
	
	for i in range(6):
		var turn1 := turn(pos1, pos2, get_vertex_pos(cur1, i))
		var turn2 := turn(pos1, pos2, get_vertex_pos(cur1, (i+1)%6 ))
		if (turn1 == 0 or turn2 == 0 or turn1 != turn2):
			tile = get_adjacent_tile(cur1, i)
			if (tile != tiles.cur1 and tile != tiles.cur2 and tile != tiles.next1 and tile != tiles.next2 and tile != tiles.last1 and tile != tiles.last2):
				if tiles.next1 == Vector2i.MIN:
					tiles.next1 = tile
				elif tiles.next2 == Vector2i.MIN:
					tiles.next2 = tile
			if turn1 == 0:
				tile = get_adjacent_tile(cur1, (i + 5) % 6)
				if (tile != tiles.cur1 and tile != tiles.cur2 and tile != tiles.next1 and tile != tiles.next2 and tile != tiles.last1 and tile != tiles.last2):
					if tiles.next1 == Vector2i.MIN:
						tiles.next1 = tile
					elif tiles.next2 == Vector2i.MIN:
						tiles.next2 = tile
			if turn2 == 0:
				tile = get_adjacent_tile(cur1, (i + 1) % 6)
				if (tile != tiles.cur1 and tile != tiles.cur2 and tile != tiles.next1 and tile != tiles.next2 and tile != tiles.last1 and tile != tiles.last2):
					if tiles.next1 == Vector2i.MIN:
						tiles.next1 = tile
					elif tiles.next2 == Vector2i.MIN:
						tiles.next2 = tile

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
	
	var from_tile := map.local_to_map(from_pos)
	if from_tile == to_tile:
		return CustomEnums.VisibleState.VISIBLE
	
	
	var tile1 := from_tile
	var tile2 := to_tile
	var height1 := unit_height1 + map.get_cell_source_id(tile1)
	var height2 := unit_height2 + map.get_cell_source_id(tile2)
	var slope := (height2 - height1) / calc_dist(tile1, tile2)
	
	var min_margin := INF
	
	var tiles := Tiles.new()
	first_step(tiles, from_pos, to_pos)
	
	
	
	
	for i in range(1000):
		if tiles.cur1 == to_tile or tiles.cur2 == to_tile:
			break
		# next1 は必ず評価
		var n := tiles.cur1
		var t_height := map.get_cell_source_id(n)
		var t_dist := calc_dist(tile1, n)
		var t_margin := (slope * t_dist) + height1 - t_height
		if t_margin < min_margin:
			if t_margin + margin_l < 0:
				return CustomEnums.VisibleState.NOT
			min_margin = t_margin

		# next2 は存在するときだけ
		if tiles.cur2 != Vector2i.MIN:
			n = tiles.cur2
			t_height = map.get_cell_source_id(n)
			t_dist = calc_dist(tile1, n)
			t_margin = (slope * t_dist) + height1 - t_height
			if t_margin < min_margin:
				if t_margin + margin_l < 0:
					return CustomEnums.VisibleState.NOT
				min_margin = t_margin
		
	
		tiles.next1 = Vector2i.MIN
		tiles.next2 = Vector2i.MIN
		next_hexas(tiles.cur1, tiles, from_pos, to_pos)
		if tiles.cur2 != Vector2i.MIN:
			next_hexas(tiles.cur2, tiles, from_pos, to_pos)
		tiles.last1 = tiles.cur1
		tiles.last2 = tiles.cur2
		tiles.cur1 = tiles.next1
		tiles.cur2 = tiles.next2
		
		


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
