extends Node

@onready var selection_manager := $SelectionManager
var unit_manager: Node
var selected_units: Array[Unit]

func _ready() -> void:
	selection_manager.released.connect(_on_selection_released)

func _on_selection_released() -> void:
