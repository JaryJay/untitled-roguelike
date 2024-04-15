extends Node2D

const tile_width: = 65
const tile_height: = 67

const grass_tile_scene: = preload("res://tiles/grass_tile.tscn")
const ordinary_merc_scene: = preload("res://actors/mercs/ordinary_mercenary.tscn")

enum Phase {
	PLAN,
	EXECUTE
}

@onready var tiles: = $Tiles
@onready var units: = $Units

func _ready() -> void:
	_generate_tiles()
	add_mercenaries()

func _generate_tiles() -> void:
	for row: int in range(7):
		for col: int in range(11):
			var tile: = grass_tile_scene.instantiate()
			tile.name = "%d_%d" % [col, row]
			tile.position.x = tile_width * col + tile_width * ((row + 1) % 2)  * 0.5
			tile.position.y = row * tile_height * 0.75
			tiles.add_child(tile)

func add_mercenaries() -> void:
	var merc0 = ordinary_merc_scene.instantiate()
	units.add_child(merc0)
	merc0.global_position = get_node("Tiles/0_0").global_position
	merc0.position.y -= 20
