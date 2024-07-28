class_name AiV1 extends Ai

func init(_unit: Unit) -> void:
	super.init(_unit)

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
			return map.has_unit(p) and Team.hostile_to_each_other(map.get_unit(p).team, unit.team)) \
			.map(func(p: Vector2i) -> Unit: return map.get_unit(p))
		if possible_targets.size():
			return ability.use(unit, map, possible_targets[0].pos)
		else:
			print("Warning: %s did not find target for ability '%s'" % [unit.name, ability.name])
	elif ability is HealAbility:
		return ability.use(unit, map, pos)
	else:
		assert(false, "Ability not yet supported: %s" % ability)
	return []
