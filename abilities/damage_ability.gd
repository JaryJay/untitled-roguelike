class_name DamageAbility extends Ability

var range: = 1
var damage: = 1

func use(unit: Unit, map: Map, pos: Vector2i) -> Array[Event]:
	var ev: = DamageEvent.new()
	ev.source = unit
	ev.target = map.get_unit(pos)
	ev.damage = damage
	return [ev]

func is_valid_target(unit: Unit, map: Map, pos: Vector2i) -> bool:
	return map.has_unit(pos) && map.distance_between(unit.pos, pos) <= range
