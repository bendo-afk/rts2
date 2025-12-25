extends Node2D

@onready var world := $World
@onready var input_controller := $InputController

func _ready() -> void:
	connect_inputs()

func connect_inputs() -> void:
	input_controller.drag.released.connect(world.ex_con.select_by_box)
	
	input_controller.click.right_clicked.connect(world.ex_con.set_path)
