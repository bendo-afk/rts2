extends Node2D

#selection
var drag_start: Vector2 = Vector2.ZERO
var drag_end: Vector2 = Vector2.ZERO
var dragging: bool = false
signal released
var rect : Rect2

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_start = get_local_mouse_position()
		elif dragging:
			dragging = false
			queue_redraw()
			released.emit()
	if event is InputEventMouseMotion and dragging:
		drag_end = get_local_mouse_position()
		queue_redraw()

func _draw() -> void:
	if dragging:
		rect = Rect2(drag_start, drag_end - drag_start).abs()
		draw_rect(rect, Color(0, 0.5, 1, 0.6), false, 1)  # 緑色の枠線
		draw_rect(rect, Color(0, 0.7, 1, 0.3), true)  # 半透明の塗りつぶし
