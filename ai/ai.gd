class_name Ai extends Resource

var unit: Unit

func init(_unit: Unit) -> void:
	assert(Team.is_ai(_unit.team), "Unit must be AI-controlled")
	unit = _unit

func do_ability(_ability: Ability, _map: Map) -> Array[Event]:
	assert(false, "do_ability() not implemented for unit %s" % unit.name)
	return []
