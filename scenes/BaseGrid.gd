extends TileMap
class_name BaseGrid

var tile_size : Vector2 = Vector2.ZERO
var half_tile_size : Vector2 = Vector2.ZERO

# here we could compute the grid size using
# the viewport size divided by the cell size
var grid_size : Vector2 = Vector2.ZERO

# This is the data structure where we store a reference
# to the objects contained into each cell of the grid.
var _grid = []

func _ready():
	# First we set the tile size to the current cell_size
	self.tile_size = self.cell_size
	self.half_tile_size = self.tile_size / 2

	# here we could compute the grid size using
	# the viewport size divided by the cell size
	self.grid_size = Vector2(960 / self.tile_size.x,
							 512 / self.tile_size.y)

	# Create the grid cells
	self.init_grid()

func init_grid() -> void:
	# Here we create the initialize the grid cells.
	# A subclass could override this method to customize
	# the initialization of a grid cell.
	for x in range(self.grid_size.x):
		self._grid.append([])
		for _y in range(self.grid_size.y):
			self._grid[x].append({})

func add_object(child_node: Node2D, grid_position: Vector2) -> void:
	var grid_type = self._get_grid_type(child_node)
	child_node.position = self.map_to_world(grid_position) + self.half_tile_size
	self._grid[grid_position.x][grid_position.y][grid_type] = child_node
	self.add_child(child_node)

func _get_grid_type(child_node: Node2D):
	"""
	Returns the key that will be used to store the object
	in a cell of the grid.
	"""
	return child_node.get_instance_id()

