extends System

var units: Array[Unit]
var map: TileMapLayer
var teams: Node

var score_interval := 10.0
var score_kaisuu := 3
var base_point := 10.0
var dist2pena: ConversionRule

var tiles: Array[EffectiveTile]

class EffectiveTile:
	var team: Team
	var tile: Vector2i
	var left_time: float
	var count: int
	var frame_created: int

func _on_tiled_changed(team: Team, tile: Vector2i) -> void:
	var eff_tile := EffectiveTile.new()
	eff_tile.team = team
	eff_tile.tile = tile
	eff_tile.left_time = score_interval
	eff_tile.count = score_kaisuu
	eff_tile.frame_created = Engine.get_physics_frames()
	tiles.append(eff_tile)
	
	for i in range(tiles.size() - 1, -1, -1):
		var ef_t := tiles[i]
		if ef_t.tile == eff_tile.tile and ef_t.team != eff_tile.team:
			if ef_t.frame_created != eff_tile.frame_created:
				tiles.remove_at(i)	

func physics(delta: float) -> void:
	for i in range(tiles.size() - 1, -1, -1):
		var ef_t := tiles[i]
		ef_t.left_time -= delta
		if ef_t.left_time <= 0:
			get_score(i)
			

func get_score(index: int) -> void:
	var ef_t := tiles[index]
	ef_t.team.score += calc_score(ef_t)
	ef_t.count -= 1
	if ef_t.count == 0:
		tiles.remove_at(index)
	else:
		ef_t.left_time = score_interval

func calc_score(ef_t: EffectiveTile) -> float:
	var penalty := 0.0
	for t in tiles:
		if t == ef_t:
			continue
		if t.team == ef_t.team:
			var dist := calc_dist(ef_t.tile, t.tile)
			if dist != 0:
				penalty += dist2pena.convert(dist)
			else:
				return 0
	return max(base_point - penalty, 0)

func calc_dist(a: Vector2i, b: Vector2i) -> int:
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
