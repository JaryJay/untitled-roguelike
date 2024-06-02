class_name Unit extends Node2D

signal health_changed(new, old, source)
signal health_depleted(source)

var items: Array[Item] = []
var abilities: Array[Ability] = []
var pos: Vector2i
@export_range(0, 200) var health: int = 5
@export_range(-200, 200) var shield: int = 0
@export_range(0, 20) var max_actions: int = 2
var actions_left: int = 2 : set = _set_actions_left

func _ready() -> void:
	add_to_group("units")
	$HealthLabel/Label.text = str(health)

func add_ability(ability: Ability) -> void:
	abilities.append(ability)

func change_health(new_health: int, source: Variant) -> void:
	if health == new_health: return
	
	var old_health: = health
	health = new_health
	health_changed.emit(new_health, old_health, source)
	
	if health <= 0: health_depleted.emit(source)

func _set_actions_left(val: int) -> void:
	actions_left = val

func move_smoothly_to(pos: Vector2) -> void:
	var tw: = create_tween()
	tw.tween_property(self, "global_position", pos, .2) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_QUAD)
