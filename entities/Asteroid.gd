extends "res://entities/Entity.gd"
class_name Asteroid

export var total_resource = 100;

func _ready() -> void:
	self.type = GridObjectType.ASTEROID