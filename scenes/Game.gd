extends Node
class_name Game

onready var Player = preload("res://entities/Player.tscn")
onready var Planet = preload("res://entities/Planet.tscn")
onready var Indicator = preload("res://entities/Indicator.tscn")


func _ready() -> void:
	# init first player
	var player1 = Player.instance()
	_setup_player(player1, Vector2(1, 1))

	# init second player
	var player2 = Player.instance()
	_setup_player(player2, Vector2($Grid.grid_size.x - 2, $Grid.grid_size.y - 2))


func _setup_player(player: Player, grid_position: Vector2) -> void:
	add_child(player)

	# Add planet for the player
	var planet = Planet.instance()
	$Grid.add_object(planet, grid_position)

	# Add indicator for the player
	var indicator = Indicator.instance()
	indicator.player = player
	$Grid.add_object(indicator, grid_position)