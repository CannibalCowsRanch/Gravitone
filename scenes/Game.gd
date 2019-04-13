extends Node
class_name Game

const Asteroid = preload("res://entities/Asteroid.tscn")
const Cannon = preload("res://entities/Cannon.tscn")
const Player = preload("res://entities/Player.tscn")
const Planet = preload("res://entities/Planet.tscn")
const Indicator = preload("res://entities/Indicator.tscn")

func _ready() -> void:
	# init first player
	var player1: Player = Player.instance()
	_setup_player(player1, Vector2(1, 1))

	# init second player
	#var player2: Player = Player.instance()
	#_setup_player(player2, Vector2($Grid.grid_size.x - 2, $Grid.grid_size.y - 2))

	$Grid.add_object(Asteroid.instance(), Vector2(4, 2))
	$Grid.add_object(Asteroid.instance(), Vector2(6, 2))
	$Grid.add_object(Asteroid.instance(), Vector2(4, 4))
	$Grid.add_object(Asteroid.instance(), Vector2(2, 4))
	$Grid.add_object(Asteroid.instance(), Vector2(2, 6))

func _setup_player(player: Player, grid_position: Vector2) -> void:
	add_child(player)

	# Add planet for the player
	var planet: Planet = Planet.instance()
	planet.player = player
	$Grid.add_object(planet, grid_position)

	# Add indicator for the player
	var indicator: Indicator = Indicator.instance()
	indicator.connect("action", self, "_on_action")
	indicator.player = player
	$Grid.add_object(indicator, grid_position)

func _on_action(player: Player, grid_position: Vector2) -> void:
	var entity = $Grid.get_entity(grid_position)
	if entity == null:
		var cannon: Cannon = Cannon.instance()
		cannon.player = player
		cannon.action()
		$Grid.add_object(cannon, grid_position)
	else:
		# propagate the action only if the player owns the object
		if entity.player == player:
			entity.action()