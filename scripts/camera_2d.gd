extends Camera2D

var pivot_camera: Vector2 = Vector2.ZERO

var zoom_level: float = 1
var min_zoom: float = 0.3
var max_zoom: float = 10
var zoom_speed:float = 0.2

func _process(_delta: float) -> void:
	handle_panning()
	handle_zoom()
	

func handle_panning() -> void:
	if Input.is_action_just_pressed("grab_camera"):
		pivot_camera = get_global_mouse_position()
	if Input.is_action_pressed("grab_camera"):
		var gap: Vector2 = pivot_camera - get_global_mouse_position()
		offset += gap

func handle_zoom() -> void:
	zoom_level = clamp(zoom_level, min_zoom, max_zoom)
	zoom = Vector2(1,1) * zoom_level

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		zoom_level *= (1 + zoom_speed)
	elif event.is_action_pressed("zoom_out"):
		zoom_level *= (1 - zoom_speed)
