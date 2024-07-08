class_name DamageAbility extends Ability

@export_range(0, 20) var range: = 1
@export_range(0, 2000) var damage: = 1

func _init(_cost: int, _name: StringName, _range: int, _damage: int) -> void:
	super(_cost)
	name = _name
	range = _range
	damage = _damage

func use(unit: Unit, map: Map, pos: Vector2i) -> Array[Event]:
	var ev: = DamageEvent.new()
	ev.source = unit
	ev.target = map.get_unit(pos)
	ev.damage = damage
	return [ev]

func is_valid_target(unit: Unit, map: Map, pos: Vector2i) -> bool:
	return map.has_unit(pos) && map.distance_between(unit.pos, pos) <= range
