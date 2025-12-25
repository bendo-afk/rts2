extends Node2D

signal right_clicked(pos: Vector2)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			right_clicked.emit(get_global_mouse_position())
