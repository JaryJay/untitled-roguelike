class_name Location extends Node2D

signal pressed

var disabled: = true : set = _set_disabled

var will_unlock: Array[Location] = []

func _ready() -> void:
	_set_disabled(disabled)

func _on_button_pressed() -> void:
	pressed.emit()

func _set_disabled(val: bool) -> void:
	disabled = val
	if not is_node_ready(): return
	
	$Button.disabled = val
	if disabled:
		$Circle.self_modulate.a = 116.0 / 255
	else:
		$Circle.self_modulate.a = 1.0
