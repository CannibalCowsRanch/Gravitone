extends Node
class_name Game

const Asteroid = preload("res://entities/Asteroid.tscn")
const Cannon = preload("res://entities/Cannon.tscn")
const Planet = preload("res://entities/Planet.tscn")
const Indicator = preload("res://entities/Indicator.tscn")
const Player = preload("res://entities/Player.gd")

func _ready() -> void:
	# init first player
	var player1: Player = Player.new(Types.PlayerNumber.PLAYER_1)
	_setup_player(player1, Vector2(1, 1))

	# init second player
	var player2: Player = Player.new(Types.PlayerNumber.PLAYER_2)
	_setup_player(player2, Vector2($EntitiesGrid.grid_size.x - 2, $EntitiesGrid.grid_size.y - 2))

	$EntitiesGrid.add_object(Asteroid.instance(), Vector2(4, 2))
	$EntitiesGrid.add_object(Asteroid.instance(), Vector2(6, 2))
	$EntitiesGrid.add_object(Asteroid.instance(), Vector2(4, 4))
	$EntitiesGrid.add_object(Asteroid.instance(), Vector2(2, 4))
	$EntitiesGrid.add_object(Asteroid.instance(), Vector2(2, 6))

func _setup_player(player: Player, grid_position: Vector2) -> void:
	add_child(player)

	# Add planet for the player
	var planet: Planet = Planet.instance()
	planet.player = player
	$EntitiesGrid.add_object(planet, grid_position)

	# Add indicator for the player
	var indicator: Indicator = Indicator.instance()
	if indicator.connect("interact", self, "_on_interact") != OK:
		print("Connection to `interact` signal failed.")
	if indicator.connect("move", self, "_on_move", [indicator]) != OK:
		print("Connection to `move` signal failed.")

	indicator.player = player
	$IndicatorsGrid.add_object(indicator, grid_position)

func _on_interact(player: Player, position: Vector2) -> void:
	var grid_position = $IndicatorsGrid.world_to_map(position)
	var entity = $EntitiesGrid.get_entity(grid_position)
	if entity == null:
		var cannon: Cannon = Cannon.instance()
		cannon.player = player
		cannon.interact()
		$EntitiesGrid.add_object(cannon, grid_position)
	else:
		# propagate the action only if the player owns the object
		if entity.player == player:
			entity.interact()

func _on_move(direction: Vector2, indicator: Indicator) -> void:
	if $IndicatorsGrid.can_move(indicator, direction):
		var new_position: Vector2 = $IndicatorsGrid.update_child_position(indicator)
		indicator.begin_move(new_position)