extends System

var units: Array[Unit]
var map: TileMapLayer
var teams: Node

var angle_margin := 0.1

func shoot() -> void:
	for u in units:
		if u.attack_comp.left_reload_time == 0:
			var min_angle_diff: float = angle_margin
			var target_enemy: Unit = null
			for v: Unit in u.vision_comp.visible_enemies:
				var angle_diff: float = abs(angle_difference((v.position - u.position).angle(), u.attack_comp.turret_angle))
				if angle_diff < min_angle_diff:
					min_angle_diff = angle_diff
					target_enemy = v
			if target_enemy != null:
				u.attack_comp.shoot(target_enemy)
