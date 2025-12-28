extends Node2D

var units: Array[Unit]
var teams: Node
var map: TileMapLayer

var size := 10
var ally_color := Color.BLUE

func _draw() -> void:
	draw_units()

# ユニット自体の描画と、砲塔の描画
func draw_units() -> void:
	for a in units:
		if a.team == teams.ally:
			draw_circle(a.position, size, ally_color, true, -1, true)
			
			var angle: float = a.attack_comp.turret_angle
			draw_line(a.position, 1000*Vector2(cos(angle), sin(angle)), Color.WHEAT, 2, true)
			angle += a.attack_comp.angle_margin
			draw_line(a.position, 1000*Vector2(cos(angle), sin(angle)), Color.WHEAT, 2, true)
			angle -= 2 * a.attack_comp.angle_margin
			draw_line(a.position, 1000*Vector2(cos(angle), sin(angle)), Color.WHEAT, 2, true)

func _process(_delta: float) -> void:
	queue_redraw()
