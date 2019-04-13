extends TileMap
class_name Grid

var tile_size : Vector2 = get_cell_size()
var half_tile_size : Vector2 = self.tile_size / 2

# here we could compute the grid size using
# the viewport size divided by the cell size
onready var grid_size = Vector2(960 / tile_size.x,
								512 / tile_size.y)

const GRID_INDICATORS = "indicators"
const GRID_ENTITY = "entity"
# This is the data structure where we store a reference
# to the objects contained into each cell of the grid.
#
#	{
#		GRID_INDICATORS: {
#		},
#		GRID_ENTITY: null
#	}
var _grid = []

func _ready():
	# Create the grid cells
	for x in range(grid_size.x):
		self._grid.append([])
		for _y in range(grid_size.y):
			self._grid[x].append({
				GRID_INDICATORS: {},
				GRID_ENTITY: null,
			})

func _get_grid_type(child_node: Node2D) -> String:
	if child_node.type == GridObjectType.INDICATOR:
		return GRID_INDICATORS
	else:
		return GRID_ENTITY

func add_object(child_node: Node2D, grid_position: Vector2) -> void:
	var grid_type = self._get_grid_type(child_node)

	child_node.position = self.map_to_world(grid_position) + self.half_tile_size
	if grid_type == GRID_INDICATORS:
		self._grid[grid_position.x][grid_position.y][grid_type][child_node.get_instance_id()] = child_node
	else:
		self._grid[grid_position.x][grid_position.y][grid_type] = child_node
	self.add_child(child_node)

func can_move(child_node, direction) -> bool:
	"""
	This function check if a node can move from its postion on the grid toward
	to the input `direction`.
	"""
	var grid_position: Vector2 = self.world_to_map(child_node.position) + direction

	if grid_position.x < self.grid_size.x and grid_position.x >= 0:
		if grid_position.y < self.grid_size.y and grid_position.y >= 0:
			return true
	return false

func update_child_position(child_node: Node2D) -> Vector2:
	"""
	Move the node in the internal grid data structure and return
	a new world position, that can be used to set node position.
	"""
	var grid_type = self._get_grid_type(child_node)
	var grid_pos = world_to_map(child_node.position)
	var new_pos = grid_pos + child_node.direction

	var instance_id = child_node.get_instance_id()
	# get the entity on the grid of the same type
	# of the object that wants to update its position
	var entity = self._grid[grid_pos.x][grid_pos.y][grid_type][instance_id]

	# move the item on the grid
	self._grid[grid_pos.x][grid_pos.y][grid_type].erase(instance_id)
	self._grid[new_pos.x][new_pos.y][grid_type][instance_id] = entity

	# returns the new position the item should have
	# on the physical world
	return map_to_world(new_pos) + half_tile_size

func get_entity(grid_position: Vector2) -> Node2D:
	# Check if position is inside the grid boundaries
	if grid_position.x >= self.grid_size.x and grid_position.x < 0:
		if grid_position.y >= self.grid_size.y and grid_position.y < 0:
			return null

	return self._grid[grid_position.x][grid_position.y][GRID_ENTITY]