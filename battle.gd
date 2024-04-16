extends Node2D

const tile_width: = 114
const tile_height: = 97

const grass_tile_scene: = preload("res://tiles/grass_tile.tscn")
const ordinary_merc_scene: = preload("res://actors/mercs/ordinary_mercenary.tscn")
const ordinary_enemy_scene: = preload("res://actors/enemies/ordinary_enemy.tscn")

enum Phase {
	PLAN,
	EXECUTE
}

@onready var tiles: = $Tiles
@onready var units: = $Units

var units_map: Dictionary = {}

var selected_mercenary: Node2D = null
var selected_tile: Tile = null

func _ready() -> void:
	_generate_tiles()
	add_mercenary_to(1, 0)
	add_mercenary_to(2, 3)
	add_enemy_to(7, 2)

func _generate_tiles() -> void:
	for row: int in range(5):
		for col: int in range(12):
			var tile: Tile = grass_tile_scene.instantiate()
			tile.name = "%d_%d" % [col, row]
			tile.position.x = col * tile_width * 0.75
			tile.position.y = tile_height * row + tile_height * ((col + 1) % 2)  * 0.5
			tiles.add_child(tile)
			tile.clicked.connect(_on_tile_click.bind(Vector2i(col, row)))

func add_mercenary_to(x: int, y: int) -> void:
	var coords: = Vector2i(x, y)
	var tile: = get_tile(coords)
	
	var merc = ordinary_merc_scene.instantiate()
	units.add_child(merc)
	merc.global_position = tile.global_position
	merc.coords = Vector2i(0, 0)
	units_map[coords] = merc

func add_enemy_to(x: int, y: int) -> void:
	var coords: = Vector2i(x, y)
	var tile: = get_tile(coords)
	
	var enemy = ordinary_enemy_scene.instantiate()
	units.add_child(enemy)
	enemy.global_position = tile.global_position
	enemy.coords = Vector2i(0, 0)
	units_map[coords] = enemy

func _on_tile_click(coords: Vector2i) -> void:
	if selected_mercenary:
		selected_mercenary.is_selected = false
		selected_mercenary = null
	if selected_tile:
		selected_tile.is_selected = false
		selected_tile = null
	
	if (not coords in units_map) or (not units_map[coords] is Ally):
		return
	else:
		selected_mercenary = units_map[coords]
		selected_mercenary.is_selected = true
		selected_tile = get_tile(coords)
		selected_tile.is_selected = true

func get_tile(coords: Vector2i) -> Node2D:
	return get_node("Tiles/%d_%d" % [coords.x, coords.y])
