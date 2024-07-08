class_name WorldGenerator extends Object

const battle_location_scene: = preload("res://world/battle_location.tscn")
const choice_location_scene: = preload("res://world/choice_location.tscn")

@export var width: float = 500
@export var vert_separation: float = 100

func generate_locations(num_layers: int) -> Array[Location]:
	var all_locations: Array[Location] = []
	
	var prev_layer: Array[Location] = []
	var current_layer: Array[Location] = []
	
	# Procedurally generate locations
	for i: int in range(1, num_layers + 1): # from 1 to num_layers, inclusive
		# Decide number of locations
		var num_locs: int
		if i <= 3:
			num_locs = i
		elif i >= num_layers - 2:
			num_locs = num_layers - i + 1
		else:
			num_locs = randi_range(2, 4)
		
		# Generate locations
		for j: int in range(num_locs):
			var location: = generate_location()
			location.position.x = (j + 1) * width / (num_locs + 1) - width / 2
			location.position.y = -i * vert_separation
			all_locations.append(location)
			current_layer.append(location)
		
		# Generate connections
		if not prev_layer.is_empty():
			connect_locations(prev_layer, current_layer)
		
		prev_layer = current_layer
		current_layer = []
	
	all_locations[0].disabled = false
	return all_locations

func connect_locations(prev_layer: Array[Location], current_layer: Array[Location]) -> void:
	assert(absi(prev_layer.size() - current_layer.size()) <= 2, "Cannot connect layers.")
	if prev_layer.size() < current_layer.size():
		_connect_locations_variant1(prev_layer, current_layer)
	else:
		_connect_locations_variant2(prev_layer, current_layer)

# When prev_layer.size() < current_layer.size()
func _connect_locations_variant1(prev_layer: Array[Location], current_layer: Array[Location]) -> void:
	for i: int in prev_layer.size():
		var possible_connections: = get_possible_connections(i, prev_layer.size(), current_layer)
		prev_layer[i].connect_to(possible_connections.pick_random())
	for i: int in current_layer.size():
		if current_layer[i].unlocked_by.is_empty():
			var possible_connections: = get_possible_connections(i, current_layer.size(), prev_layer)
			possible_connections.pick_random().connect_to(current_layer[i])

# When prev_layer.size() >= current_layer.size()
func _connect_locations_variant2(prev_layer: Array[Location], current_layer: Array[Location]) -> void:
	for i: int in prev_layer.size():
		var possible_connections: = get_possible_connections(i, prev_layer.size(), current_layer)
		prev_layer[i].connect_to(possible_connections.pick_random())
	for i: int in current_layer.size():
		if current_layer[i].unlocked_by.is_empty():
			var possible_connections: = get_possible_connections(i, current_layer.size(), prev_layer)
			possible_connections.pick_random().connect_to(current_layer[i])

func get_possible_connections(index: int, layer_size: int, to: Array[Variant]) -> Array[Variant]:
	var to_size: = to.size()
	if layer_size % 2 == to_size % 2:
		var mid: = index + (to_size - layer_size) / 2
		return to.slice(max(mid - 1, 0), mid + 2)
	else:
		var r: = index + (1 if to_size > layer_size else 0)
		return to.slice(max(r - 1, 0), r + 1)

func generate_location() -> Location:
	var possibilities: Array[PackedScene] = [battle_location_scene, choice_location_scene]
	var weights: Array[int] = [80, 0]
	var index: = Random.weighted(weights)
	return possibilities[index].instantiate() as Location
