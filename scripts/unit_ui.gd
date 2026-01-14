extends Node2D

var units: Array[Unit]
var teams: Node
var map: TileMapLayer

var size := 10
var ally_color := Color.BLUE
var enemy_color := Color.RED
var turret_color := Color.WHEAT


func _process(_delta: float) -> void:
	queue_redraw()


func _draw() -> void:
	draw_units()


# ユニット自体の描画と、砲塔の描画
func draw_units() -> void:
	for u in units:
		if not should_draw(u):
			continue

		draw_circle(u.position, size, get_unit_color(u), true, -1, true)
		draw_turret(u)


func should_draw(u: Unit) -> bool:
	return u.team == teams.ally or u.vision_comp.visible_state == CustomEnums.VisibleState.VISIBLE


func get_unit_color(u: Unit) -> Color:
	return ally_color if u.team == teams.ally else enemy_color


func draw_turret(u: Unit) -> void:
	var angle: float = u.attack_comp.turret_angle
	var margin: float = u.attack_comp.angle_margin
	var pos := u.position

	draw_line(pos, pos + 1000 * Vector2(cos(angle), sin(angle)), turret_color, 2, true)
	draw_line(pos, pos + 1000 * Vector2(cos(angle + margin), sin(angle + margin)), turret_color, 2, true)
	draw_line(pos, pos + 1000 * Vector2(cos(angle - margin), sin(angle - margin)), turret_color, 2, true)
