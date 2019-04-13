extends Node2D
class_name Indicator

const type = GridObjectType.INDICATOR

signal action(player, position)

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

onready var grid: Grid = get_node("/root/Game/Grid")

enum States {
	IDLE,
	MOVING,
	PAUSE,
	ACTION,
}

var _state = States.IDLE
var _elapsed = 0

static func get_input_direction() -> Vector2:
	return Vector2(
		float(Input.is_action_pressed("move_right")) - float(Input.is_action_pressed("move_left")),
		float(Input.is_action_pressed("move_down")) - float(Input.is_action_pressed("move_up"))
	)

func _process(delta: float) -> void:
	if self._state == States.ACTION:
		self.process_action()
	elif self._state == States.IDLE:
		self.process_idle()
	elif self._state == States.MOVING:
		self.process_moving(delta)
	elif self._state == States.PAUSE:
		self.process_pause(delta)

func process_action() -> void:
	if Input.is_action_just_pressed("action"):
		self._state = States.IDLE
		emit_signal("action", player, grid.world_to_map(position))

func process_idle() -> void:
	if Input.is_action_just_pressed("action"):
		self._state = States.ACTION
		emit_signal("action", player, grid.world_to_map(position))
		return

	self.direction = self.get_input_direction()

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
		if self.grid.can_move(self, self.direction):
			self._target_position = self.grid.update_child_position(self)
			self._start_position = self.position
			self._state = States.MOVING

func process_moving(delta: float) -> void:
	self._elapsed += delta
	var weight = self._elapsed * self.SPEED
	position = self._start_position.linear_interpolate(self._target_position, min(weight, 1))
	if weight >= 1:
		self._elapsed = 0
		self._state = States.PAUSE

func process_pause(delta: float) -> void:
	self._elapsed += delta
	if self._elapsed >= self._pause_duration:
		self._elapsed = 0
		self._state = States.IDLE
