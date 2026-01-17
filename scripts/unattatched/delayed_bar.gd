extends BarBase
class_name DelayedBar

var timer: float = 0

var delayed_time: float = 1
var color: Color

var delayed: ColorRect


func _ready() -> void:
	delayed = ColorRect.new()
	add_child(delayed)
	delayed.size.x = x_size
	delayed.size.y = y_size


func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		delayed.size.x = main.size.x
		set_process(false)


func set_raito(r: float) -> void:
	super.set_raito(r)
	timer = delayed_time
	set_process(true)
