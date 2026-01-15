extends System

var units: Array[Unit]
var map: TileMapLayer
var teams: Node


func physics() -> void:
	for u in units:
		if u.attack_comp.left_reload_time == 0:
			var min_angle_diff: float = u.attack_comp.angle_margin
			var target_enemy: Unit = null
			for v: Unit in u.vision_comp.visible_enemies:
				if v.hp_comp.hp <= 0:
					continue

				var angle_diff: float = abs(angle_difference((v.position - u.position).angle(), u.attack_comp.turret_angle))
				if angle_diff < min_angle_diff:
					min_angle_diff = angle_diff
					target_enemy = v
				if u.position == v.position:
					target_enemy = v
					break
			if target_enemy != null:
				u.attack_comp.shoot(target_enemy)
