class_name MoveEvent extends Event

var from: Vector2i
var to: Vector2i

func perform(map: Map) -> void:
	map.remove_unit(from)
	map.add_unit(to, source)
