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

var hex_grid_math: HexGridMath


func setup() -> void:
	hex_grid_math = HexGridMath.new()
	hex_grid_math.setup(map.vsize, map.hsize)


func physics() -> void:
	set_states()

func _process(_delta: float) -> void:
	if Input.is_action_pressed("test"):
		print("state", is_visible(units[0].position, map.map_to_local(Vector2i(3,3)), 0, 0))


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


func first_step(
		last1: Vector2i,
		last2: Vector2i,
		cur1: Vector2i,
		cur2: Vector2i,
		_next1: Vector2i,
		_next2: Vector2i,
		pos1: Vector2,
		pos2: Vector2) -> PackedVector2Array:
	cur1 = map.local_to_map(pos1)
	var to_tile := map.local_to_map(pos2)
	var cands1 := Candidates.new()
	var cands2 := Candidates.new()
	last1 = cur1
	for i in range(6):
		var turn1: int = hex_grid_math.turn(pos1, pos2, hex_grid_math.get_vertex_pos(map.map_to_local(cur1), i))
		var turn2: int = hex_grid_math.turn(pos1, pos2, hex_grid_math.get_vertex_pos(map.map_to_local(cur1), (i+1)%6 ))
		if turn1 == 0 and turn2 == 0:
			last2 = hex_grid_math.get_adjacent_tile(cur1, i)
			var tile1: Vector2i = hex_grid_math.get_adjacent_tile(cur1, (i+1)%6)
			var tile5: Vector2i = hex_grid_math.get_adjacent_tile(cur1, (i+5)%6)
			if hex_grid_math.calc_dist(to_tile, tile1) < hex_grid_math.calc_dist(to_tile, tile5):
				cur1 = tile1
			else:
				cur1 = tile5
			return [last1, last2, cur1, cur2]
		elif turn1 * turn2 == -1:
			if cands1.t1 == Vector2i.MIN:
				cands1.t1 = hex_grid_math.get_adjacent_tile(cur1, i)
			else:
				cands2.t1 = hex_grid_math.get_adjacent_tile(cur1, i)
		elif turn1 == 0:
			if cands1.t1 == Vector2i.MIN:
				cands1.t1 = hex_grid_math.get_adjacent_tile(cur1, (i+5)%6)
				cands1.t2 = hex_grid_math.get_adjacent_tile(cur1, i)
			else:
				cands2.t1 = hex_grid_math.get_adjacent_tile(cur1, (i+5)%6)
				cands2.t2 = hex_grid_math.get_adjacent_tile(cur1, i)
	if hex_grid_math.calc_dist(to_tile, cands1.t1) < hex_grid_math.calc_dist(to_tile, cands2.t1):
		cur1 = cands1.t1
		if cands1.t2 != Vector2i.MIN:
			cur2 = cands1.t2
	else:
		cur1 = cands2.t1
		if cands2.t2 != Vector2i.MIN:
			cur2 = cands2.t2
	return [last1, last2, cur1, cur2]

func next_hexas(
		last1: Vector2i,
		last2: Vector2i,
		cur1: Vector2i,
		cur2: Vector2i,
		next1: Vector2i,
		next2: Vector2i,
		pos1: Vector2,
		pos2: Vector2) -> PackedVector2Array:
	var tile: Vector2i
	
	for i in range(6):
		var turn1: int = hex_grid_math.turn(pos1, pos2, hex_grid_math.get_vertex_pos(map.map_to_local(cur1), i))
		var turn2: int = hex_grid_math.turn(pos1, pos2, hex_grid_math.get_vertex_pos(map.map_to_local(cur1), (i+1)%6 ))
		if (turn1 == 0 or turn2 == 0 or turn1 != turn2):
			tile = hex_grid_math.get_adjacent_tile(cur1, i)
			if (tile != cur1 and tile != cur2 and tile != next1 and tile != next2 and tile != last1 and tile != last2):
				if next1 == Vector2i.MIN:
					next1 = tile
				elif next2 == Vector2i.MIN:
					next2 = tile
			if turn1 == 0:
				tile = hex_grid_math.get_adjacent_tile(cur1, (i + 5) % 6)
				if (tile != cur1 and tile != cur2 and tile != next1 and tile != next2 and tile != last1 and tile != last2):
					if next1 == Vector2i.MIN:
						next1 = tile
					elif next2 == Vector2i.MIN:
						next2 = tile
			if turn2 == 0:
				tile = hex_grid_math.get_adjacent_tile(cur1, (i + 1) % 6)
				if (tile != cur1 and tile != cur2 and tile != next1 and tile != next2 and tile != last1 and tile != last2):
					if next1 == Vector2i.MIN:
						next1 = tile
					elif next2 == Vector2i.MIN:
						next2 = tile
	return [last1, last2]

func is_visible(from_pos: Vector2, to_pos: Vector2, unit_height1: float, unit_height2: float) -> CustomEnums.VisibleState:
	var to_tile := map.local_to_map(to_pos)
	
	var from_tile := map.local_to_map(from_pos)
	if from_tile == to_tile:
		return CustomEnums.VisibleState.VISIBLE
	
	var tile1 := from_tile
	var tile2 := to_tile
	var height1 := unit_height1 + map.get_cell_source_id(tile1)
	var height2 := unit_height2 + map.get_cell_source_id(tile2)
	var slope := (height2 - height1) / hex_grid_math.calc_dist(tile1, tile2)
	
	var min_margin := INF
	
	var last1 := Vector2i.MIN
	var last2 := Vector2i.MIN
	var cur1 := Vector2i.MIN
	var cur2 := Vector2i.MIN
	var next1 := Vector2i.MIN
	var next2 := Vector2i.MIN
	var arr: PackedVector2Array= [last1, last2, cur1, cur2]
	arr = first_step(
			last1,
			last2,
			cur1,
			cur2,
			next1,
			next2,
			from_pos,
			to_pos)


	for i in range(1000):
		if cur1 == to_tile or cur2 == to_tile:
			break
		# next1 は必ず評価
		var n := cur1
		var t_height := map.get_cell_source_id(n)
		var t_dist := hex_grid_math.calc_dist(tile1, n)
		var t_margin := (slope * t_dist) + height1 - t_height
		if t_margin < min_margin:
			if t_margin + margin_l < 0:
				return CustomEnums.VisibleState.NOT
			min_margin = t_margin

		# next2 は存在するときだけ
		if cur2 != Vector2i.MIN:
			n = cur2
			t_height = map.get_cell_source_id(n)
			t_dist = hex_grid_math.calc_dist(tile1, n)
			t_margin = (slope * t_dist) + height1 - t_height
			if t_margin < min_margin:
				if t_margin + margin_l < 0:
					return CustomEnums.VisibleState.NOT
				min_margin = t_margin
		
		next1 = Vector2i.MIN
		next2 = Vector2i.MIN
		next_hexas(
			last1,
			last2,
			cur1,
			cur2,
			next1,
			next2,
			from_pos,
			to_pos)
		if cur2 != Vector2i.MIN:
			next_hexas(
			last1,
			last2,
			cur2,
			cur1,
			next1,
			next2,
			from_pos,
			to_pos)
		last1 = cur1
		last2 = cur2
		cur1 = next1
		cur2 = next2
	
	if min_margin + margin_s < 0:
		return CustomEnums.VisibleState.HALF
	else:
		return CustomEnums.VisibleState.VISIBLE
