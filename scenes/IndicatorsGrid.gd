extends BaseGrid
class_name IndicatorsGrid

func _get_grid_type(child_node: Node2D):
	"""
	Returns the key that will be used to store the object
	in a cell of the grid.
	"""
	return (child_node as Indicator).player.number

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
	Move the node in the internal grid data structure based
	on the value of its `direction` property and returns
	a new world position, that can be used to set node position.
	"""
	var grid_type = self._get_grid_type(child_node)
	var grid_pos = world_to_map(child_node.position)
	var new_pos = grid_pos + child_node.direction

	# get the entity on the grid of the same type
	# of the object that wants to update its position
	var entity = self._grid[grid_pos.x][grid_pos.y][grid_type]

	# move the item on the grid
	self._grid[grid_pos.x][grid_pos.y].erase(grid_type)
	self._grid[new_pos.x][new_pos.y][grid_type] = entity

	# returns the new position the item should have
	# on the physical world
	return map_to_world(new_pos) + half_tile_size