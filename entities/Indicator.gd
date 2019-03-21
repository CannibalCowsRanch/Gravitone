extends Node2D
class_name Grid

# The movement speed of the indicator
const SPEED = 20.0

const PAUSE_DURATION_SLOW = 0.15
const PAUSE_DURATION_FAST = 0.03

# Represents how long the cursor wait before
# it can move again
var _pause_duration: float = PAUSE_DURATION_SLOW

var direction: Vector2 = Vector2.ZERO

# This is used to decrease change pause duration
# to implement fast moving when player moves only
# in one direction
var _last_direction: Vector2 = Vector2.ZERO

# Stores where the object was when the movement started
# This member variable is needed to interpolate movement
var _start_position: Vector2 = Vector2.ZERO
# Stores where the movement should end
var _target_position: Vector2 = Vector2.ZERO

var type = "indicator"
var player = null

onready var grid: Grid = get_parent()

enum States {
	IDLE,
	MOVING,
	PAUSE,
}

var _state = States.IDLE
var _elapsed = 0

static func get_input_direction() -> Vector2:
	return Vector2(
		float(Input.is_action_pressed("move_right")) - float(Input.is_action_pressed("move_left")),
		float(Input.is_action_pressed("move_down")) - float(Input.is_action_pressed("move_up"))
	)

func _process(delta: float) -> void:
	if _state == States.IDLE:
		process_idle()
	elif _state == States.MOVING:
		process_moving(delta)
	elif _state == States.PAUSE:
		process_pause(delta)

func process_idle() -> void:
	direction = get_input_direction()

	# if the user is moving in the same direction again decrease
	# the pause duration to allow fast movement
	if direction == Vector2.ZERO or _last_direction != direction:
		_pause_duration = PAUSE_DURATION_SLOW
	else:
		_pause_duration = PAUSE_DURATION_FAST

	# stores that last direction which will be use on the
	# next frame to increase/decrease pause duration
	_last_direction = direction

	if direction != Vector2.ZERO:
		if grid.can_move(self, direction):
			_target_position = grid.update_child_position(self)
			_start_position = position
			_state = States.MOVING

func process_moving(delta: float) -> void:
	_elapsed += delta
	var weight = _elapsed * SPEED
	position = _start_position.linear_interpolate(_target_position, min(weight, 1))
	if weight >= 1:
		_elapsed = 0
		_state = States.PAUSE

func process_pause(delta: float) -> void:
	_elapsed += delta
	if _elapsed >= _pause_duration:
		_elapsed = 0
		_state = States.IDLE
