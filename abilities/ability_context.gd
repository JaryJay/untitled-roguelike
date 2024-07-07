class_name AbilityContext extends RefCounted

var unit: Unit
var ability0: Ability
var ability1: Ability
var ability2: Ability

func _init(_unit: Unit, a0: Ability, a1: Ability, a2: Ability = null) -> void:
	unit = _unit
	ability0 = a0
	ability1 = a1
	ability2 = a2
