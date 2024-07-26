class_name AbilityContext extends RefCounted

var unit: Unit
var abilities: Array[Ability]

func _init(_unit: Unit) -> void:
	unit = _unit

func generate() -> void:
	abilities.clear()
	var ability_set: = unit.get_ability_set()
	if not ability_set.abilities0.is_empty():
		abilities.append(ability_set.abilities0.pick_random())
	if not ability_set.abilities1.is_empty():
		abilities.append(ability_set.abilities1.pick_random())
	if not ability_set.abilities2.is_empty():
		abilities.append(ability_set.abilities2.pick_random())

func get_all_abilities() -> Array[Ability]:
	return abilities
