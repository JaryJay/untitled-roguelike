class_name Tile extends Sprite2D

signal hovered
signal clicked

var is_hovered: bool = false : set = _set_is_hovered
var is_clicked: bool = false : set = _set_is_clicked
var is_selected: bool = false : set = _set_is_selected

func _input(event):
	if is_hovered and event.is_action_pressed("primary"):
		is_clicked = true
	elif is_hovered and is_clicked and event.is_action_released("primary"):
		is_clicked = false
		clicked.emit()
	elif event.is_action_released("primary"):
		is_clicked = false

func _on_mouse_entered():
	is_hovered = true
	hovered.emit()

func _on_mouse_exited():
	is_hovered = false

func _set_is_hovered(val: bool) -> void:
	is_hovered = val
	$GoldHexagonFaint.visible = is_hovered && (not is_selected) && (not is_clicked)

func _set_is_clicked(val: bool) -> void:
	is_clicked = val
	$GoldHexagonFaint.visible = is_hovered && (not is_selected) && (not is_clicked)
	$GoldHexagonFaint2.visible = is_clicked && (not is_selected)

func _set_is_selected(val: bool) -> void:
	is_selected = val
	$GoldHexagon.visible = is_selected
	$GoldHexagonFaint2.visible = is_clicked && (not is_selected)
	$GoldHexagonFaint.visible = is_hovered && (not is_selected) && (not is_clicked)
