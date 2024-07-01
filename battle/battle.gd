class_name Battle extends Node2D

signal victory
signal defeat

const tile_width: = 114
const tile_height: = 97

const grass_tile_scene: = preload("res://world/grass_tile.tscn")
const ally_scene: = preload("res://actors/allies/mage.tscn")
const enemy_scene: = preload("res://actors/enemies/enemy.tscn")

enum BattleState {
	PLAYER_TURN,
	WAITING_FOR_TARGET,
	ENEMY_TURN,
	BEFORE_VICTORY,
	TRANSITION_TO_WORLD,
}

@onready var tiles: = $Tiles
@onready var units: = $Units

var map: Map = Map.new()

var selected_ally: Ally = null
var selected_ability: Ability = null
var selected_tile: Tile = null
var battle_state: BattleState = BattleState.PLAYER_TURN

# For resolving enemy abilities
var current_enemy: Enemy = null
var enemies: Array[Enemy] = []
var abilities_to_resolve: Array[Ability] = []
var events_to_resolve: Array[Event] = []
var waiting_for_resolve: = false

func _ready() -> void:
	_generate_tiles()
	add_ally_to(1, 2)
	add_ally_to(2, 2)
	add_enemy_to(4, 2)
	_on_turn_start()

func _process(_delta: float) -> void:
	if battle_state == BattleState.BEFORE_VICTORY \
		or battle_state == BattleState.TRANSITION_TO_WORLD:
		return
	if battle_state == BattleState.ENEMY_TURN:
		process_enemies()
	
	if not events_to_resolve.is_empty():
		process_events()
	elif not abilities_to_resolve.is_empty():
		process_abilities()
	remove_dead_units()

func process_abilities() -> void:
	if abilities_to_resolve.is_empty(): return
	
	var ability: = abilities_to_resolve[0]
	abilities_to_resolve.remove_at(0)
	events_to_resolve.append_array(current_enemy.do_ability(ability, map))

func process_events() -> void:
	if waiting_for_resolve: return
	if events_to_resolve.is_empty(): return
	
	var event: Event = events_to_resolve[0]
	events_to_resolve.remove_at(0)
	
	if (event.processed):
		waiting_for_resolve = true
		event.perform(map)
		event.visual_effects(get_tree())
		
		var tw: = create_tween()
		tw.tween_interval(0.1)
		tw.tween_property(self, "waiting_for_resolve", false, 0)
	else:
		var event_trigger: = EventTrigger.new(event)
		
		for unit: Unit in get_tree().get_nodes_in_group("units"):
			event_trigger = unit.item_collection.modify_event_trigger(event_trigger)
		
		event_trigger.event.processed = true
		var new_events_to_resolve: = event_trigger.finalize_into_event_list()
		new_events_to_resolve.append_array(events_to_resolve)
		events_to_resolve = new_events_to_resolve

func remove_dead_units() -> void:
	for unit: Unit in get_tree().get_nodes_in_group("units"):
		if unit.health <= 0:
			print("Unit died: %s" % unit.name)
			map.remove_unit(unit.pos)
			unit.queue_free()

func process_enemies() -> void:
	if enemies.size():
		current_enemy = enemies[0]
		enemies.remove_at(0)
		abilities_to_resolve = current_enemy.next_abilities.duplicate()
	else:
		_on_enemy_turns_end()

func _on_enemy_turns_end() -> void:
	if not get_tree().get_nodes_in_group("units").any(func(u: Unit) -> bool: return u is Enemy):
		# If no enemies left...
		#victory.emit()
		battle_state = BattleState.BEFORE_VICTORY
		var choose_item_dialog: ChooseItemDialog = load("res://ui/dialogs/choose_item_dialog.tscn").instantiate()
		get_tree().root.add_child(choose_item_dialog)
		choose_item_dialog.init_random()
		choose_item_dialog.item_chosen.connect(func(item: Item) -> void:
			battle_state = BattleState.TRANSITION_TO_WORLD
			victory.emit()
			print("YAY")
			print("You selected item %s" % item.name)
			choose_item_dialog.queue_free()
		)
		return
	elif not get_tree().get_nodes_in_group("units").any(func(u: Unit) -> bool: return u is Ally):
		# If no allies left...
		defeat.emit()
		return
	
	if waiting_for_resolve: return
	
	waiting_for_resolve = true
	var tw: = create_tween()
	tw.tween_interval(0.5)
	tw.tween_property(self, "waiting_for_resolve", false, 0)
	tw.tween_callback(_on_turn_start)

func _generate_tiles() -> void:
	for row: int in range(4):
		for col: int in range(8):
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
	
	var unit: Ally = ally_scene.instantiate()
	units.add_child(unit)
	unit.global_position = tile.global_position
	unit.pos = pos
	map.add_unit(pos, unit)
	
	unit.ability_chosen.connect(handle_ability_selection)

func add_enemy_to(x: int, y: int) -> void:
	var pos: = Vector2i(x, y)
	var tile: = get_tile(pos)
	
	var unit: = enemy_scene.instantiate()
	units.add_child(unit)
	unit.global_position = tile.global_position
	unit.pos = pos
	map.add_unit(pos, unit)

func _on_tile_click(pos: Vector2i) -> void:
	if battle_state == BattleState.ENEMY_TURN: return
	elif battle_state == BattleState.PLAYER_TURN:
		handle_unit_selection(pos)
	elif battle_state == BattleState.WAITING_FOR_TARGET:
		if not selected_ability:
			return
		if not selected_ability.is_valid_target(selected_ally, map, pos):
			print("Invalid target")
			return
		
		var events: = selected_ability.use(selected_ally, map, pos)
		
		for event: Event in events:
			events_to_resolve.append(event)
		
		selected_ally.actions_left -= selected_ability.cost
		selected_ability = null
		
		battle_state = BattleState.PLAYER_TURN
		
		if selected_ally.has_actions_left():
			selected_tile.is_selected = false
			selected_tile = map.get_tile(selected_ally.pos)
			selected_tile.is_selected = true
		else:
			selected_ally.is_selected = false
			selected_ally = null
			selected_tile.is_selected = false
			selected_tile = null

func handle_unit_selection(pos: Vector2i) -> void:
	var prev_selected: = selected_ally
	
	# Deselect everything
	if selected_ally:
		selected_ally.is_selected = false
		selected_ally = null
	if selected_tile:
		selected_tile.is_selected = false
		selected_tile = null
	
	# If user clicks the selected unit, we don't reselect it
	if prev_selected and prev_selected.pos == pos:
		return
	
	var unit: = map.get_unit(pos)
	if not unit or not Team.is_player(unit.team) or not unit.has_actions_left():
		return
	else:
		selected_ally = unit
		selected_ally.is_selected = true
		selected_tile = get_tile(pos)
		selected_tile.is_selected = true

func handle_ability_selection(ability: Ability) -> void:
	if selected_ally.actions_left < ability.cost:
		return
	selected_ability = ability
	battle_state = BattleState.WAITING_FOR_TARGET

func get_tile(pos: Vector2i) -> Node2D:
	return get_node("Tiles/%d_%d" % [pos.x, pos.y])

func _on_turn_start() -> void:
	print("It is your turn")
	battle_state = BattleState.PLAYER_TURN
	for unit: Unit in get_tree().get_nodes_in_group("units"):
		unit.actions_left = unit.max_actions
	
	for unit: Unit in get_tree().get_nodes_in_group("units"):
		if Team.is_ai(unit.team):
			generate_ai_turn(unit)

func _on_turn_end() -> void:
	battle_state = BattleState.ENEMY_TURN
	if selected_ally:
		selected_ally.is_selected = false
		selected_ally = null
	selected_ability = null
	print("You ended your turn")
	do_ai_turns()

func _on_end_turn_button_pressed() -> void:
	if not battle_state == BattleState.ENEMY_TURN:
		_on_turn_end()

func generate_ai_turn(unit: Unit) -> void:
	print("Generating turn for %s" % unit.name)
	unit.next_abilities.clear()
	for i: int in range(unit.actions_left):
		var rand_ability: Ability = unit.abilities[0]
		
		unit.next_abilities.append(rand_ability)
	unit.update_ability_ui()

func do_ai_turns() -> void:
	for unit: Unit in get_tree().get_nodes_in_group("units"):
		if Team.is_ai(unit.team):
			enemies.append(unit)
