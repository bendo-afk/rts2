extends Sprite2D

var size: float = 10
var color: Color = Color.BLUE

@onready var attack_comp := $"../AttackComp"

func _draw() -> void:
	draw_circle(Vector2.ZERO, size, color, true, -1, true)
	var angle: float = attack_comp.turret_angle
	draw_line(Vector2.ZERO, 1000*Vector2(cos(angle), sin(angle)), Color.WHEAT, 2, true)

func _process(_delta: float) -> void:
	queue_redraw()
