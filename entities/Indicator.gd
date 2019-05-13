extends Node2D
class_name Indicator

const type = Types.EntityType.INDICATOR

signal interact(player, position)
signal move(direction)

# The movement speed of the indicator
const SPEED = 30.0

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

var player: Player = null

enum States {
	IDLE,
	MOVING,
	PAUSE,
	INTERACT,
}

var _state = States.IDLE
var _elapsed = 0

func _get_input_direction() -> Vector2:
	return Vector2(
		float(Input.is_action_pressed(self.player.action.move_right)) - float(Input.is_action_pressed(self.player.action.move_left)),
		float(Input.is_action_pressed(self.player.action.move_down)) - float(Input.is_action_pressed(self.player.action.move_up))
	)

func _process(delta: float) -> void:
	if self._state == States.INTERACT:
		self._process_interact()
	elif self._state == States.IDLE:
		self._process_idle()
	elif self._state == States.MOVING:
		self._process_moving(delta)
	elif self._state == States.PAUSE:
		self._process_pause(delta)

func _process_interact() -> void:
	if Input.is_action_just_pressed(self.player.action.interact):
		self._state = States.IDLE
		emit_signal("interact", player, position)

func _process_idle() -> void:
	if Input.is_action_just_pressed(self.player.action.interact):
		self._state = States.INTERACT
		emit_signal("interact", player, position)
		return

	self.direction = self._get_input_direction()

	# if the user is moving in the same direction again decrease
	# the pause duration to allow fast movement
	if self.direction == Vector2.ZERO or self._last_direction != self.direction:
		self._pause_duration = self.PAUSE_DURATION_SLOW
	else:
		self._pause_duration = self.PAUSE_DURATION_FAST

	# stores that last direction which will be use on the
	# next frame to increase/decrease pause duration
	self._last_direction = self.direction

	if self.direction != Vector2.ZERO:
		emit_signal("move", self.direction)

func begin_move(target_position: Vector2) -> void:
	"""
	To begin movement animation one should call this method.
	Usually this is called from the main scene which has access
	ot the indicators' grid to compute the target position.
	"""
	self._target_position = target_position
	self._start_position = self.position
	self._state = States.MOVING

func _process_moving(delta: float) -> void:
	self._elapsed += delta
	var weight = self._elapsed * self.SPEED
	position = self._start_position.linear_interpolate(self._target_position, min(weight, 1))
	if weight >= 1:
		self._elapsed = 0
		self._state = States.PAUSE

func _process_pause(delta: float) -> void:
	self._elapsed += delta
	if self._elapsed >= self._pause_duration:
		self._elapsed = 0
		self._state = States.IDLE
