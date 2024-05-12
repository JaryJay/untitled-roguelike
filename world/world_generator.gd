class_name WorldGenerator extends Object

const battle_location_scene: = preload("res://world/battle_location.tscn")

@export var width: float = 500
@export var vert_separation: float = 50

func generate_locations(num_layers: int) -> Array[Location]:
	#print(get_possible_connections(0, 3, [0, 1, 2, 3]))
	#print(get_possible_connections(1, 3, [0, 1, 2, 3]))
	#print(get_possible_connections(2, 3, [0, 1, 2, 3]))
	#print(get_possible_connections(0, 3, [0, 1, 2, 3, 4]))
	#print(get_possible_connections(1, 3, [0, 1, 2, 3, 4]))
	#print(get_possible_connections(2, 3, [0, 1, 2, 3, 4]))
	print(get_possible_connections(0, 4, [0, 1, 2, 3]))
	#print(get_possible_connections(1, 4, [0, 1, 2, 3]))
	#print(get_possible_connections(2, 4, [0, 1, 2, 3]))
	#print(get_possible_connections(3, 4, [0, 1, 2, 3]))
	
	var all_locations: Array[Location] = []
	
	var prev_layer: Array[Location] = []
	var current_layer: Array[Location] = []
	
	# Procedurally generate locations
	for i: int in range(1, num_layers + 1): # from 1 to num_layers, inclusive
		var prev_num_locs: = prev_layer.size()
		
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
			var location: = battle_location_scene.instantiate()
			location.position.x = 1. * width / (num_locs + 1) + randf_range(-500, 500) # TODO
			location.position.y = -i * vert_separation
			all_locations.append(location)
			current_layer.append(location)
		
		# Generate connections
		for j: int in range(prev_layer.size()):
			var loc: = prev_layer
			var possible_connections: = get_possible_connections(j, prev_layer.size(), current_layer)
			
		
		prev_layer = current_layer
		current_layer = []
	
	all_locations[0].disabled = false
	return all_locations

func connect_locations(prev_layer: Array[Location], current_layer: Array[Location]) -> void:
	assert(absi(prev_layer.size() - current_layer.size()) <= 2, "Cannot connect layers.")
	if prev_layer.size() < current_layer.size():
		_connect_locations_variant1(prev_layer, current_layer)

func _connect_locations_variant1(prev_layer: Array[Location], current_layer: Array[Location]) -> void:
	for loc: Location in prev_layer:
		pass

func get_possible_connections(index: int, layer_size: int, to: Array[Variant]) -> Array[Variant]:
	var to_size: = to.size()
	if layer_size % 2 == to_size % 2:
		var mid: = index + (to_size - layer_size) / 2
		return to.slice(max(mid - 1, 0), mid + 2)
	else:
		var r: = index + (1 if to_size > layer_size else 0)
		return to.slice(max(r - 1, 0), r + 1)
