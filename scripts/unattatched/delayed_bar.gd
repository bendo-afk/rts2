extends BarBase
class_name DelayedBar

var timer: float = 0

var delayed_time: float = 1

var delayed := ColorRect.new()


func _ready() -> void:
	super._ready()
	add_child(delayed)
	move_child(delayed, 1)


func _process(delta: float) -> void:
	timer -= delta
	if timer <= 0:
		delayed.size.x = main.size.x
		set_process(false)


func set_ratio(r: float) -> void:
	super.set_ratio(r)
	timer = delayed_time
	set_process(true)


func apply_delayed_settings(size_vec: Vector2, bg_color: Color, main_color: Color, delayed_alpha: float) -> void:
	super.apply_settings(size_vec, bg_color, main_color)
	delayed.color = Color(main_color, delayed_alpha)
	
