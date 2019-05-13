extends BaseGrid
class_name EntitiesGrid

const GRID_ENTITY = "entity"

func _get_grid_type(child_node: Node2D) -> String:
	return GRID_ENTITY

func get_entity(grid_position: Vector2) -> Node2D:
	# Check if position is inside the grid boundaries
	if grid_position.x >= self.grid_size.x and grid_position.x < 0:
		if grid_position.y >= self.grid_size.y and grid_position.y < 0:
			return null

	return self._grid[grid_position.x][grid_position.y].get(GRID_ENTITY)