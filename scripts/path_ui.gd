extends Node2D

var units: Array[Unit]
var teams: Node
var map: TileMapLayer

var line_color := Color.WHITE
var line_width := 2


func setup() -> void:
	for a in units:
		if a.team == teams.ally:
			a.path_changed.connect(_on_path_changed)

func draw_path() -> void:
	for a in units:
		if a.team == teams.ally:
			if a.path_2i.size() > 1:
				draw_polyline(v2i_to_v2(a.path_2i), line_color, line_width, true)

func _draw() -> void:
	draw_path()

func _on_path_changed() -> void:
	queue_redraw()

func v2i_to_v2(v2i: PackedVector2Array) -> PackedVector2Array:
	var v2_array: PackedVector2Array
	var array_size := v2i.size()
	v2_array.resize(array_size)
	for i in array_size:
		v2_array[i] = map.map_to_local(v2i[i])
	return v2_array
