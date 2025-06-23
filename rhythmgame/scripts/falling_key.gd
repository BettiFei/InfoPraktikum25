extends Sprite2D

@export var fall_speed: float = 2.0

var init_y_pos: float = -150

func _init():
	set_process(false)

func _process(_delta):
	global_position += Vector2(0, fall_speed)
	
	# returns time in seconds that it takes for falling key to reach critical spot
	if global_position.y > 120 and not $Timer.is_stopped():
		print($Timer.wait_time - $Timer.time_left)
		$Timer.stop()

func setup(target_x: float, target_frame: int):
	global_position = Vector2(target_x, init_y_pos)
	frame = target_frame
	set_process(true)

func _on_destroy_timer_timeout() -> void:
	queue_free()
