class_name Ai extends RefCounted

var unit: Unit

func _init(_unit: Unit) -> void:
	assert(Team.is_ai(_unit.team), "Unit must be AI-controlled")
	unit = _unit

func do_ability(ability: Ability, map: Map) -> Array[Event]:
	assert(false, "do_ability() not implemented for unit %s" % unit.name)
	return []
