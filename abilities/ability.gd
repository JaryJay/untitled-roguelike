class_name Ability extends Resource

var name: StringName = "NO NAME"
var cost: int
@export var needs_target: bool : get = _needs_target

func _init(_cost: int) -> void:
	cost = _cost

func use(_unit: Unit, _map: Map, _pos: Vector2i) -> Array[Event]:
	assert(false, "perform(...) not implemented for ability %s" % get_class())
	return []

func is_valid_target(_unit: Unit, _map: Map, _pos: Vector2i) -> bool:
	assert(false, "is_valid_target(...) not implemented for ability %s" % get_class())
	return false

func _needs_target() -> bool:
	return true
