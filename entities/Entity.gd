extends RigidBody2D
class_name Entity

var type = Types.EntityType.INVALID

var player: Player = null
var health: int = 100

func interact() -> void:
	# This method is needed because the game
	# calls `interact` method on the entity that
	# is under the indicator. The default impl
	# is empty at the moment
	pass