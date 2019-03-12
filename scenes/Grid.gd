extends TileMap

var tile_size = get_cell_size()
var half_tile_size = self.tile_size / 2

# here we could compute the grid size using 
# the viewport size divided by the cell size
onready var grid_size = Vector2(960 / tile_size.x, 
								512 / tile_size.y)
var grid = []

onready var Player = preload("res://entities/Player.tscn")
onready var Indicator = preload("res://entities/Indicator.tscn")


func _ready():
	# Create the grid cells
	for x in range(grid_size.x):
		grid.append([])
		for y in range(grid_size.y):
			grid[x].append({})
	
	# init first player
	var player1 = Player.instance()
	player1.position = map_to_world(Vector2(1, 1)) + self.half_tile_size
	player1.top_left = Vector2.ZERO
	player1.bottom_right = Vector2(floor(grid_size.x / 2), grid_size.y) 
	grid[1][1][player1.type] = player1
	add_child(player1)
	
	# init second player
	var player2 = Player.instance()
	player2.position = map_to_world(Vector2(grid_size.x - 2, grid_size.y - 2)) + self.half_tile_size
	player2.top_left = Vector2(ceil(grid_size.x / 2), 0)
	player2.bottom_right = grid_size
	grid[grid_size.x - 2][grid_size.y - 2][player2.type] = player2
	add_child(player2)
	
	# indicator instance
	var indicator = Indicator.instance()
	indicator.position = player1.position
	indicator.player = player1
	grid[1][1][indicator.type] = indicator
	add_child(indicator)

func is_valid_position(player, grid_position):
	if grid_position.x < player.bottom_right.x and grid_position.x >= player.top_left.x:
		if grid_position.y < player.bottom_right.y and grid_position.y >= player.top_left.y:
			return true
	return false

func update_child_position(position, direction, type, player):
	var grid_pos = world_to_map(position)
	var new_pos = grid_pos + direction
	# here we check that the current position is not on the boundaries
	# if it's not we can move :D
	if is_valid_position(player, new_pos):
		# get the entity on the grid of the same type
		# of the object that wants to update its position
		var entity = grid[grid_pos.x][grid_pos.y][type]
		
		# move the item on the grid
		grid[grid_pos.x][grid_pos.y].erase(type)
		grid[new_pos.x][new_pos.y][type] = entity
		# move the item on the physical world 
		# TODO: this part could be handled by the item directly 
		#       returning the new pos
		entity.position = map_to_world(new_pos) + half_tile_size
		