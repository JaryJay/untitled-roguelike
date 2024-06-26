class_name MoveAbility extends Ability

var range: = 1

func _init(_cost: int, _name: StringName, _range: int) -> void:
	super(_cost)
	name = _name
	range = _range

func use(unit: Unit, _map: Map, pos: Vector2i) -> Array[Event]:
	var ev: = MoveEvent.new()
	ev.source = unit
	ev.from = unit.pos
	ev.to = pos
	return [ev]

func is_valid_target(unit: Unit, map: Map, pos: Vector2i) -> bool:
	return map.distance_between(unit.pos, pos) <= range && !map.has_unit(pos)
