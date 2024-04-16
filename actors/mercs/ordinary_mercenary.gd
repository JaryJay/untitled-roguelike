class_name Ally extends Node2D

@onready var ability_selection_ui: = $AbilitySelectionUI

var coords: Vector2i
var is_selected: bool = false : set = _set_is_selected

func _ready():
	ability_selection_ui.add_ability("Swing")

func _set_is_selected(val: bool) -> void:
	is_selected = val
	ability_selection_ui.visible = is_selected
