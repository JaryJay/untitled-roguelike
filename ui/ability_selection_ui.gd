class_name AbilitySelectionUI extends Node2D

signal ability_chosen(ability: Ability)

@export var _disabled: = true

func init(ability_set: AbilitySet) -> void:
	if ability_set.get_all_abilities().is_empty():
		push_warning("Initializing ability selection UI with empty ability set.")
	for ability: Ability in ability_set.get_all_abilities():
		_add_ability(ability)

func _add_ability(ability: Ability) -> void:
	var button: = Button.new()
	button.text = ability.name
	button.pressed.connect(_on_ability_pressed.bind(ability))
	$VBoxContainer.add_child(button)

func _on_ability_pressed(ability: Ability) -> void:
	ability_chosen.emit(ability)

func is_disabled() -> bool:
	return _disabled

func enable() -> void:
	_disabled = false
