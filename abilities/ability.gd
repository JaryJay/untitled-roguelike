class_name Ability extends Resource

@export var name: StringName = "NO NAME"
@export_range(0, 15) var cost: int = 1
var needs_target: bool : get = _needs_target

func use(_unit: Unit, _map: Map, _pos: Vector2i) -> Array[Event]:
	assert(false, "perform(...) not implemented for ability %s" % get_class())
	return []

func is_valid_target(_unit: Unit, _map: Map, _pos: Vector2i) -> bool:
	assert(false, "is_valid_target(...) not implemented for ability %s" % get_class())
	return false

func _needs_target() -> bool:
	return true
