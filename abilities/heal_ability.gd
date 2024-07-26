class_name HealAbility extends Ability

@export_range(0, 15) var range: = 1
@export_range(0, 2000) var health: = 1

static func create(_cost: int, _name: StringName, _range: int, _health: int) -> HealAbility:
	var a: = HealAbility.new()
	a.name = _name
	a.range = _range
	a.health = _health
	return a

func use(unit: Unit, map: Map, pos: Vector2i) -> Array[Event]:
	var ev: = HealEvent.new()
	ev.source = unit
	ev.target = map.get_unit(pos)
	ev.health = health
	return [ev]

func is_valid_target(unit: Unit, map: Map, pos: Vector2i) -> bool:
	return map.has_unit(pos) && map.distance_between(unit.pos, pos) <= range
