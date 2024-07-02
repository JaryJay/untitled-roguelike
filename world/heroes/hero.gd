class_name Hero extends Resource

@export var name: StringName

var item_collection: = ItemCollection.new()
var base_abilities: Array[Ability] = []

@export_range(0, 200) var max_health: int = 5
var health: int = max_health
@export_range(0, 20) var max_actions: int = 3

func _init(_name: StringName, _max_health: int) -> void:
	name = _name
	max_health = _max_health
	health = _max_health

func add_ability(ability: Ability) -> void:
	base_abilities.append(ability)
