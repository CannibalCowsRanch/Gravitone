extends TileMap
class_name Grid

var tile_size : Vector2 = get_cell_size()
var half_tile_size : Vector2 = self.tile_size / 2

# here we could compute the grid size using
# the viewport size divided by the cell size
onready var grid_size = Vector2(960 / tile_size.x,
								512 / tile_size.y)

# This is the data structure where we store a reference
# to the objects contained by each cell of the grid
var _grid = []

func _ready():
	# Create the grid cells
	for x in range(grid_size.x):
		self._grid.append([])
		for _y in range(grid_size.y):
			self._grid[x].append({})

func add_object(child_node: Node2D, grid_position: Vector2) -> void:
	child_node.position = map_to_world(grid_position) + self.half_tile_size
	self._grid[grid_position.x][grid_position.y][child_node.type] = child_node
	add_child(child_node)

func can_move(child_node, direction) -> bool:
	"""
	This function check if a node can move from its postion on the grid toward
	to the input `direction`.
	The check relies on the boundaries stored on the player instance which
	should be bound to the `child_node`.
	"""
	# TODO: could be better to move this method on the player itself
	#       because its the one the owns the boundaries of the area
	#       where bound nodes can move.
	var grid_position: Vector2 = world_to_map(child_node.position) + direction
	var player: Player = child_node.player

	if grid_position.x < player.bottom_right.x and grid_position.x >= player.top_left.x:
		if grid_position.y < player.bottom_right.y and grid_position.y >= player.top_left.y:
			return true
	return false

func update_child_position(child_node) -> Vector2:
	var grid_pos = world_to_map(child_node.position)
	var new_pos = grid_pos + child_node.direction

	# get the entity on the grid of the same type
	# of the object that wants to update its position
	var entity = self._grid[grid_pos.x][grid_pos.y][child_node.type]

	# move the item on the grid
	self._grid[grid_pos.x][grid_pos.y].erase(child_node.type)
	self._grid[new_pos.x][new_pos.y][child_node.type] = entity

	# returns the new position the item should have
	# on the physical world
	return map_to_world(new_pos) + half_tile_size