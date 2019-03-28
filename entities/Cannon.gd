extends "res://entities/Entity.gd"
class_name Cannon

onready var Bullet = preload("res://entities/Bullet.tscn")

export var cooldown = 1;
export var thrust = 400;

func _ready() -> void:
	$Timer.wait_time = cooldown

func _on_Timer_timeout() -> void:
	var bullet = Bullet.instance()
	bullet.direction = Vector2(1, 0) * thrust
	add_child(bullet)
