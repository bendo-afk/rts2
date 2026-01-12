extends TileMapLayer

var hsize: int = 128
var vsize: int = 148
var max_height := 4
const MIN := 0

var n_x := 20
var n_y := 20
var height_arr: Array[int]

@onready var teximage: Resource = preload("res://prepaired_data/images/EDGE2_128.png")

var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var fnl: FastNoiseLite = FastNoiseLite.new()

@onready var astar: AStar2D = AStar2D.new()

func _ready() -> void:
	tile_set = make_tileset()
	setup_map()
	setup_astar()

func make_tileset() -> TileSet:
	var ts: TileSet = TileSet.new()
	ts.tile_shape = TileSet.TILE_SHAPE_HEXAGON
	ts.tile_size = Vector2i(hsize,vsize)
	make_tile(ts,0)
	make_tile(ts,1)
	make_tile(ts,2)
	make_tile(ts,3)
	make_tile(ts,4)
	return ts

func make_tile(ts: TileSet , height: int) -> void:
	var tsas: TileSetAtlasSource = TileSetAtlasSource.new()
	tsas.margins = Vector2i(0,0)
	tsas.texture_region_size = Vector2i(hsize,vsize)
	tsas.texture = teximage
	tsas.create_tile(Vector2i(0,0), Vector2i(1,1))
	var tile_data: TileData = tsas.get_tile_data(Vector2i(0,0) , 0)
	tile_data.modulate = Color(0,0.99 * height , 0,1)
	
	ts.add_source(tsas)

func setup_map() -> void:
	randomize()
	fnl.seed = randi()
	fnl.noise_type = FastNoiseLite.TYPE_SIMPLEX
	fnl.fractal_octaves = 3
	fnl.fractal_gain = 0.5
	fnl.set_frequency(0.2)
	for y in range(n_y):
		for x in range(n_x - y):
			var n: float = fnl.get_noise_2d(x,y)
			n = (n + 1) / 2.0
			n = pow(n, 2)
			n *= 5
			var height := int(n) 
			set_cell(Vector2i(x,y) , height , Vector2i(0,0) , 0)
			set_cell(Vector2i(19-x, 19 - y), height, Vector2i(0,0), 0)

func setup_astar() ->void:
	#各グリッドをastarに追加
	astar.clear()
	var cells: Array[Vector2i] = get_used_cells()
	for i in range(cells.size()):
		astar.add_point(i , cells[i])
	
	#高さに合わせてコネクト
	for i in range(cells.size()):
		var neibors: Array[Vector2i] = get_surrounding_cells(cells[i])
		for n in neibors:
			if get_cell_source_id(n) != -1 and i != astar.get_closest_point(n):
				if get_cell_source_id(cells[i]) - get_cell_source_id(n) > -2:
					astar.connect_points(i , astar.get_closest_point(n) , false)

func calc_path(from_pos: Vector2 , to_pos: Vector2) -> PackedVector2Array:
	var from_id: int = astar.get_closest_point(from_pos)
	var to_id: int = astar.get_closest_point(to_pos)
	var path: PackedVector2Array = astar.get_point_path(from_id , to_id , true)
	return path

func map_to_local_array(map_2i_array: PackedVector2Array) -> PackedVector2Array:
	var local_packedarray: PackedVector2Array
	var array_size := map_2i_array.size()
	local_packedarray.resize(array_size)
	for i in array_size:
		local_packedarray[i] = map_to_local(map_2i_array[i])
	return local_packedarray

func change_height(height_action: HeightAction) -> void:
	var diff: int
	if height_action.is_raise:
		diff = 1
	else:
		diff = -1 
	set_cell(height_action.tile, get_cell_source_id(height_action.tile) + diff, Vector2i(0,0), 0)
	setup_astar()

func can_change_height(tile: Vector2i, is_raise: bool) -> bool:
	var h: int = get_cell_source_id(tile)
	return not ((is_raise and h == max_height) or (!is_raise and h == MIN))

func is_movable_adjacent(tile1: Vector2i, tile2: Vector2i) -> bool:
	var path_2i: PackedVector2Array = calc_path(tile1, tile2)
	if path_2i.size() == 2:
		return true
	return false

func pos_to_tile(pos: Vector2) -> Vector2i:
	return local_to_map(pos)

func pos_to_height(pos: Vector2) -> int:
	var tile: Vector2i = local_to_map(pos)
	return get_cell_source_id(tile)
