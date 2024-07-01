class_name Enemy extends Unit

var next_abilities: Array[Ability] = []

@onready var actions_label: = $ActionsLabel

func _enter_tree() -> void:
	add_ability(MoveAbility.new(1, "Move", 1))
	add_ability(DamageAbility.new(1, "Shank", 1, 2))
	add_ability(HealAbility.new(1, "Heal", 1, 2))

func do_ability(ability: Ability, map: Map) -> Array[Event]:
	if ability is MoveAbility:
		var possible_targets: = map.get_positions_within_distance(pos, ability.range)
		possible_targets = possible_targets.filter(func(p: Vector2i) -> bool:
			return not map.has_unit(p)) # Only empty positions
		if possible_targets.size():
			return ability.use(self, map, possible_targets[0])
	elif ability is DamageAbility:
		var possible_pos: = map.get_positions_within_distance(pos, ability.range)
		var possible_targets: = possible_pos.filter(func(p: Vector2i) -> bool:
			return map.has_unit(p) and map.get_unit(p) is Ally).map(func(p: Vector2i) -> Unit:
			return map.get_unit(p))
		if possible_targets.size():
			return ability.use(self, map, possible_targets[0].pos)
	elif ability is HealAbility:
		return ability.use(self, map, self.pos)
	else:
		assert(false, "Ability not yet supported: %s" % ability)
	return []

func update_ability_ui() -> void:
	actions_label.text = ""
	for ability: Ability in next_abilities:
		actions_label.text += "%s " % ability.name
