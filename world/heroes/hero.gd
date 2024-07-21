class_name Hero extends Resource

@export var name: StringName
var starting_pos: Vector2i

var item_collection: = ItemCollection.new()
@export var base_abilities: AbilitySet = AbilitySet.new()

@export_range(0, 200) var max_health: int = 5
var health: int = max_health
@export_range(0, 20) var max_actions: int = 3

func _init(_name: StringName, _max_health: int) -> void:
	name = _name
	max_health = _max_health
	health = _max_health

func add_ability(ability: Ability) -> void:
	base_abilities.abilities0.append(ability)

func create_unit(scene: PackedScene) -> Unit:
	var unit: Unit = scene.instantiate()
	unit.pos = starting_pos
	# TODO: Maybe set a copy instead?
	unit.item_collection = item_collection
	#unit.abilities = base_abilities
	unit.max_health = max_health
	unit.health = health
	unit.max_actions = max_actions
	unit.actions_left = max_actions
	return unit
