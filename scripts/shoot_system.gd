extends System

var units: Array[Unit]
var map: TileMapLayer
var teams: Node

var angle_margin := 0.1

func shoot() -> void:
	for u in units:
		if u.attack_comp.left_reload_time == 0:
			var min_angle_diff: float = 4
			var target_enemy: Unit
			for v in units:
				if v.team != u.team and v.vision_comp.visible_state == 2:
					var angle_diff: float = abs(angle_difference((v.position - u.position).angle(), u.attack_comp.turret_angle))
					if angle_diff < angle_margin:
						min_angle_diff = angle_diff
						target_enemy = v
			if min_angle_diff <= angle_margin:
				u.attack_comp.shoot(target_enemy)
