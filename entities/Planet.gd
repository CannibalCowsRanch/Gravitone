extends "res://entities/Entity.gd"
class_name Planet

export var resource_quantity = 100;

func _ready() -> void:
	self.type = Types.EntityType.PLANET