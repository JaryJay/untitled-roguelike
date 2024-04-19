class_name Ally extends Unit

signal ability_chosen(ability)

@onready var ability_selection_ui: AbilitySelectionUI = $AbilitySelectionUI

var is_selected: bool = false : set = _set_is_selected

func _ready():
	super()
	var move_a: = MoveAbility.new()
	move_a.name = "Move"
	var stab_a: = DamageAbility.new()
	stab_a.name = "Stab"
	stab_a.damage = 2
	
	abilities = [move_a, stab_a]
	
	for a: Ability in abilities:
		ability_selection_ui.add_ability(a)
	ability_selection_ui.ability_chosen.connect(_on_ability_chosen)

func _set_is_selected(val: bool) -> void:
	is_selected = val
	ability_selection_ui.visible = is_selected

func _on_ability_chosen(ability: Ability) -> void:
	ability_chosen.emit(ability)
