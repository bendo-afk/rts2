extends Node2D

@onready var world := $World
@onready var input_controller := $InputController


func setup(ally_params: Array[Dictionary], enemy_params: Array[Dictionary]) -> void:
	world.setup(ally_params, enemy_params)
	
	connect_inputs()


func connect_inputs() -> void:
	input_controller.drag.released.connect(world.ex_con.select_by_box)
	
	input_controller.click.right_clicked.connect(world.ex_con.set_path)
	
	input_controller.click.side1_clicked.connect(world.ex_con.set_target_pos)
