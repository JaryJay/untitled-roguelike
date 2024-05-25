class_name Enemy extends Unit

var next_abilities: Array[Ability] = []

@onready var actions_label = $ActionsLabel

func _ready() -> void:
	var move_a: = MoveAbility.new("Move", 1)
	var shank_a: = DamageAbility.new("Shank", 1, 2)
	var heal_a: = HealAbility.new("Heal", 1, 2)
	
	abilities = [move_a, shank_a, heal_a]
	
	#for a: Ability in abilities:
		#ability_selection_ui.add_ability(a)
	#ability_selection_ui.ability_chosen.connect(_on_ability_chosen)
	
	_set_actions_left(actions_left)
	super()

func do_ability(ability: Ability, map: Map) -> Array[Event]:
	if ability is MoveAbility:
		var possible_targets: = map.get_positions_within_distance(pos, ability.range)
		possible_targets = possible_targets.filter(func(p):
			return not map.has_unit(p)) # Only empty positions
		if possible_targets.size():
			return ability.use(self, map, possible_targets[0])
	elif ability is DamageAbility:
		var possible_pos: = map.get_positions_within_distance(pos, ability.range)
		var possible_targets: = possible_pos.filter(func(p):
			return map.has_unit(p) and map.get_unit(p) is Ally).map(func(p):
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
