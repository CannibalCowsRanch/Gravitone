extends "res://entities/Entity.gd"
class_name Bullet

var damage = 100
var direction = Vector2.ZERO

func _ready() -> void:
	$Body.apply_impulse(Vector2.ZERO, direction)