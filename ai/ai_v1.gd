class_name AiV1 extends Ai

func _init(_unit: Unit) -> void:
	super(_unit)

func do_ability(ability: Ability, map: Map) -> Array[Event]:
	var pos: = unit.pos
	
	if ability is MoveAbility:
		var possible_targets: = map.get_positions_within_distance(pos, ability.range)
		possible_targets = possible_targets.filter(func(p: Vector2i) -> bool:
			return not map.has_unit(p)) # Only empty positions
		if possible_targets.size():
			return ability.use(unit, map, possible_targets[0])
	elif ability is DamageAbility:
		var possible_pos: = map.get_positions_within_distance(pos, ability.range)
		var possible_targets: = possible_pos.filter(func(p: Vector2i) -> bool:
			return map.has_unit(p) and map.get_unit(p) is Ally).map(func(p: Vector2i) -> Unit:
			return map.get_unit(p))
		if possible_targets.size():
			return ability.use(unit, map, possible_targets[0].pos)
	elif ability is HealAbility:
		return ability.use(unit, map, pos)
	else:
		assert(false, "Ability not yet supported: %s" % ability)
	return []
