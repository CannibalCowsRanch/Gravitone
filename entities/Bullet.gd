extends "res://entities/Entity.gd"
class_name Bullet

var damage = 100
var direction = Vector2.ZERO

func _ready() -> void:
	self.apply_impulse(Vector2.ZERO, direction)

func _on_Timer_timeout() -> void:
	# If timer reaches timeout we will destory the object.
	self.queue_free()

func _on_body_entered(body: Node) -> void:
	body.health -= 10
	if body.health <= 0:
		body.queue_free()
	self.queue_free()
