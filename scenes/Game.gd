extends Node
class_name Game

onready var Player = preload("res://entities/Player.tscn")
onready var Indicator = preload("res://entities/Indicator.tscn")

func _ready() -> void:
	var grid: Grid = $Grid

		# init first player
	var player1 = Player.instance()
	grid.add_object(player1, Vector2(1, 1))
	player1.top_left = Vector2.ZERO
	player1.bottom_right = Vector2(floor(grid.grid_size.x / 2), grid.grid_size.y)

	# init second player
	var player2 = Player.instance()
	grid.add_object(player2, Vector2(grid.grid_size.x - 2, grid.grid_size.y - 2))
	player2.top_left = Vector2(ceil(grid.grid_size.x / 2), 0)
	player2.bottom_right = grid.grid_size

	# indicator instance
	var indicator = Indicator.instance()
	indicator.player = player1
	grid.add_object(indicator, Vector2(1, 1))