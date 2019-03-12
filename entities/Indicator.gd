extends Node2D

var direction = Vector2(0, 0)
var type = "indicator"
var player = null

onready var grid = get_parent()

func _process(delta):
	var is_moving = Input.is_action_pressed("ui_down") or Input.is_action_pressed("ui_right") \
				or Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_up")
				
	if is_moving:
		set_process(false)
		if Input.is_action_pressed("ui_down"):
			direction += Vector2(0, 1)
		if Input.is_action_pressed("ui_up"):
			direction += Vector2(0, -1)
		if Input.is_action_pressed("ui_left"):
			direction += Vector2(-1, 0)
		if Input.is_action_pressed("ui_right"):
			direction += Vector2(1, 0)
		
		$timer.start()
		grid.update_child_position(position, direction, type, player)
		direction = Vector2.ZERO

func _on_timer_timeout():
	set_process(true)
