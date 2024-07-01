class_name AbilitySelectionUI extends Node2D

signal ability_chosen(ability: Ability)

@export var disabled: = true

func add_ability(ability: Ability) -> void:
	var button: = Button.new()
	button.text = ability.name
	button.pressed.connect(_on_ability_pressed.bind(ability))
	$VBoxContainer.add_child(button)

func _on_ability_pressed(ability: Ability) -> void:
	ability_chosen.emit(ability)

func is_disabled() -> bool:
	return disabled
