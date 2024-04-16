class_name AbilitySelectionUI extends Node2D

func add_ability(name: String) -> void:
	var button: = Button.new()
	button.text = name
	$VBoxContainer.add_child(button)
