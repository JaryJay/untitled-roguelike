class_name Ally extends Unit

signal ability_chosen(ability)

@onready var ability_selection_ui: AbilitySelectionUI = $AbilitySelectionUI
@onready var actions_left_label: Label = $ActionsLeftLabel

var is_selected: bool = false : set = _set_is_selected

func _ready():
	super()
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

# override
func _set_actions_left(val: int) -> void:
	actions_left = val
	actions_left_label.text = str(val)
