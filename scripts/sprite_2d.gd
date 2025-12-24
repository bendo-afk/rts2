extends Sprite2D

var size: float = 10
var color: Color = Color.BLUE

func _draw() -> void:
	draw_circle(Vector2.ZERO, size, color, true, -1, true)
