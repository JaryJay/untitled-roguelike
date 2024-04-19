class_name Map extends Resource

## Map from Vector2i to Tiles
var _tile_map: Dictionary = {}
## Map from Vector2i to Units
var _unit_map: Dictionary = {}

var bound_left: = 0
var bound_right: = 11
var bound_top: = 0
var bound_bottom: = 4

func get_tile(pos: Vector2i) -> Tile:
	return _tile_map.get(pos)
func set_tile(pos: Vector2i, tile: Tile) -> void:
	if _tile_map.has(pos):
		printerr("Cannot put tile at %s because it already contains something." % pos)
		return
	_tile_map[pos] = tile
func remove_tile(pos: Vector2i) -> void:
	_tile_map.erase(pos)
func has_unit(pos: Vector2i) -> bool:
	return _unit_map.has(pos)
func get_unit(pos: Vector2i) -> Unit:
	return _unit_map.get(pos)
func add_unit(pos: Vector2i, unit: Unit) -> void:
	if _unit_map.has(pos):
		printerr("Cannot put unit in %s because it already contains something." % pos)
		return
	_unit_map[pos] = unit
	unit.pos = pos
	unit.global_position = get_tile(pos).global_position
func remove_unit(pos: Vector2i) -> void:
	_unit_map.erase(pos)

func get_positions_within_distance(pos: Vector2i, dist: int, include_valid_only: = true) -> Array[Vector2i]:
	var result: Array[Vector2i] = []
	for y: int in range(pos.y - dist, pos.y + dist + 1):
		for x: int in range(pos.x - dist, pos.x + dist + 1):
			if include_valid_only and not _tile_map.has(Vector2i(x, y)):
				continue
			
			result.append(Vector2i(x, y))
	return result

func distance_between(pos1: Vector2i, pos2: Vector2i) -> int:
	var diff: Vector2i = pos2 - pos1
	var abs_diff_x: int = abs(diff.x)

	var y_diff_achieved_going_along_x: int
	if (pos1.x % 2 == pos2.x % 2):
		y_diff_achieved_going_along_x = abs_diff_x / 2;
	elif (pos1.x % 2 == 0):
		if (diff.y < 0):
			y_diff_achieved_going_along_x = (abs_diff_x - 1) / 2
		else:
			y_diff_achieved_going_along_x = (abs_diff_x + 1) / 2
	else:
		if (diff.y < 0):
			y_diff_achieved_going_along_x = (abs_diff_x + 1) / 2
		else:
			y_diff_achieved_going_along_x = (abs_diff_x - 1) / 2
	if (y_diff_achieved_going_along_x >= abs(diff.y)):
		return abs_diff_x
	else:
		return abs_diff_x + abs(diff.y) - y_diff_achieved_going_along_x
