class_name Ally extends Unit

signal ability_chosen(ability)

@onready var ability_selection_ui: AbilitySelectionUI = $AbilitySelectionUI
@onready var actions_left_label: Label = $ActionsLeftLabel

var actions_left: int = 2 : set = _set_actions_left

var is_selected: bool = false : set = _set_is_selected

func _ready():
	super()
	var move_a: = MoveAbility.new("Move", 1)
	var stab_a: = DamageAbility.new("Stab", 1, 2)
	
	abilities = [move_a, stab_a]
	
	for a: Ability in abilities:
		ability_selection_ui.add_ability(a)
	ability_selection_ui.ability_chosen.connect(_on_ability_chosen)
	
	_set_actions_left(actions_left)

func has_actions_left() -> bool:
	return actions_left >= 1

func _set_is_selected(val: bool) -> void:
	is_selected = val
	ability_selection_ui.visible = is_selected

func _on_ability_chosen(ability: Ability) -> void:
	ability_chosen.emit(ability)

func _set_actions_left(val: int) -> void:
	actions_left = val
	actions_left_label.text = str(val)