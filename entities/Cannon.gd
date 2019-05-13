extends "res://entities/Entity.gd"
class_name Cannon

const Bullet = preload("res://entities/Bullet.tscn")

const COOLDOWN = 1.0
const MAX_COOLDOWN_DELTA = 0.5;
const MIN_COOLDOWN_DELTA = -0.5;

var _cooldown_delta: float = 0.0 setget _set_cooldown
export var thrust = 400;

enum States {
	IDLE,
	INTERACT
}

var _state = States.IDLE

func _ready() -> void:
	# Set the type of the object
	self.type = Types.EntityType.CANNON
	$Timer.wait_time = self.COOLDOWN

func _set_cooldown(new_value: float) -> void:
	_cooldown_delta = new_value
	$Timer.wait_time = self.COOLDOWN + self._cooldown_delta
	$CooldownLabel.text = "%.1f" % self._cooldown_delta

func _on_Timer_timeout() -> void:
	var bullet = Bullet.instance()
	# FIXME: all these params could be computed only when $Direction's
	# rotation changes
	bullet.position = $Direction/SpawnPoint.position.rotated($Direction.rotation)
	bullet.rotation = $Direction.rotation
	bullet.direction = (Vector2(1, 0) * thrust).rotated($Direction.rotation)
	add_child(bullet)

func _process(delta: float) -> void:
	if self._state == States.INTERACT:
		self._process_interact(delta)

func _process_interact(delta) -> void:
	# Moves direction up and down
	if Input.is_action_pressed(self.player.action.move_down):
		$Direction.rotate(2.0 * delta)
	if Input.is_action_pressed(self.player.action.move_up):
		$Direction.rotate(-2.0 * delta)

	# Increase or Decrease cooldown
	if Input.is_action_just_pressed(self.player.action.move_left):
		self._cooldown_delta = max(self._cooldown_delta - 0.1, self.MIN_COOLDOWN_DELTA)
	if Input.is_action_just_pressed(self.player.action.move_right):
		self._cooldown_delta = min(self._cooldown_delta + 0.1, self.MAX_COOLDOWN_DELTA)

func interact() -> void:
	# Here we change some properties of the
	# Cooldown and Direction nodes.
	# TODO: This SHOULD be done with animations
	if self._state == States.INTERACT:
		$CooldownLabel.visible = false
		$Direction.modulate = Color(1, 1, 1, 0.5)
		self._state = States.IDLE

	elif self._state == States.IDLE:
		$CooldownLabel.visible = true
		$Direction.modulate = Color(1, 1, 1, 1)
		self._state = States.INTERACT
