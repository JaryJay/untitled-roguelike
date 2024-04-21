class_name HealAbility extends Ability

var range: = 1
var health: = 1

func _init(_name: StringName, _range: int, _health: int) -> void:
	name = _name
	range = _range
	health = _health

func use(unit: Unit, map: Map, pos: Vector2i) -> Array[Event]:
	var ev: = HealEvent.new()
	ev.source = unit
	ev.target = map.get_unit(pos)
	ev.health = health
	return [ev]

func is_valid_target(unit: Unit, map: Map, pos: Vector2i) -> bool:
	return map.has_unit(pos) && map.distance_between(unit.pos, pos) <= range
