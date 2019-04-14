extends "res://entities/Entity.gd"
class_name Planet

export var resource_quantity = 100;

func _ready() -> void:
	self.type = GridObjectType.PLANET

func action() -> void:
	# This method is needed because the game
	# calls `action` method on the entity that
	# is under the indicator. The default impl
	# is empty at the moment
	pass