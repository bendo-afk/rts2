extends System

var units: Array[Unit]
var map: TileMapLayer
var teams: Node

var ally_tiles: Array[Vector2i]
var enemy_tiles: Array[Vector2i]


func _on_tiled_changed(team: Team, tile: Vector2i) -> void:
	if team == teams.ally:
		ally_tiles.append(tile)
	else:
		enemy_tiles.append(tile)

func get_score() -> void:
	pass
