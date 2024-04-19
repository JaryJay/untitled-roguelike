class_name Battle extends Node2D

const tile_width: = 114
const tile_height: = 97

const grass_tile_scene: = preload("res://world/grass_tile.tscn")
const ordinary_unit_scene: = preload("res://actors/mercs/ordinary_mercenary.tscn")
const ordinary_enemy_scene: = preload("res://actors/enemies/ordinary_enemy.tscn")

enum BattleState { PLAYER_TURN, WAITING_FOR_TARGET, ENEMY_TURN }

@onready var tiles: = $Tiles
@onready var units: = $Units

var map: Map = Map.new()

var selected_unit: Unit = null
var selected_ability: Ability = null
var selected_tile: Tile = null
var battle_state: BattleState = BattleState.PLAYER_TURN

func _ready() -> void:
	_generate_tiles()
	add_ally_to(1, 0)
	add_ally_to(2, 3)
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
			tile.get_node("Label").text = tile.name
			map.set_tile(Vector2i(col, row), tile)

func add_ally_to(x: int, y: int) -> void:
	var pos: = Vector2i(x, y)
	var tile: = get_tile(pos)
	
	var unit: Ally = ordinary_unit_scene.instantiate()
	units.add_child(unit)
	unit.global_position = tile.global_position
	unit.pos = pos
	map.add_unit(pos, unit)
	
	unit.ability_chosen.connect(handle_ability_selection)

func add_enemy_to(x: int, y: int) -> void:
	var pos: = Vector2i(x, y)
	var tile: = get_tile(pos)
	
	var enemy = ordinary_enemy_scene.instantiate()
	units.add_child(enemy)
	enemy.global_position = tile.global_position
	enemy.pos = pos
	map.add_unit(pos, enemy)

func _on_tile_click(pos: Vector2i) -> void:
	if battle_state == BattleState.ENEMY_TURN: return
	elif battle_state == BattleState.PLAYER_TURN:
		handle_unit_selection(pos)
	elif battle_state == BattleState.WAITING_FOR_TARGET:
		if not selected_ability:
			return
		if not selected_ability.is_valid_target(selected_unit, map, pos):
			print("Invalid target")
			return
		
		var events: = selected_ability.use(selected_unit, map, pos)
		
		for event: Event in events:
			for item: Item in selected_unit.items:
				item.modify_event(event)
		
		for event: Event in events:
			event.perform(map)
		
		selected_ability = null
		
		for unit: Unit in get_tree().get_nodes_in_group("units"):
			if unit.health <= 0:
				print("Unit died: %s" % unit.name)
				map.remove_unit(unit.pos)
				unit.queue_free()

func handle_unit_selection(pos: Vector2i) -> void:
	if selected_unit:
		selected_unit.is_selected = false
		selected_unit = null
	if selected_tile:
		selected_tile.is_selected = false
		selected_tile = null
	
	if not map.get_unit(pos) or not map.get_unit(pos) is Ally:
		return
	else:
		selected_unit = map.get_unit(pos)
		selected_unit.is_selected = true
		selected_tile = get_tile(pos)
		selected_tile.is_selected = true

func handle_ability_selection(ability: Ability) -> void:
	selected_ability = ability
	battle_state = BattleState.WAITING_FOR_TARGET

func get_tile(pos: Vector2i) -> Node2D:
	return get_node("Tiles/%d_%d" % [pos.x, pos.y])
