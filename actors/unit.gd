class_name Unit extends Node2D

signal health_changed(new: int, old: int, source: Node2D)
signal health_depleted(source: Node2D)

var item_collection: = ItemCollection.new()

@export var team: Team.s = Team.s.ALLY_PLAYER

var abilities: Array[Ability] = []
var pos: Vector2i

var status_effect_group: = StatusEffectGroup.new()
@export_range(0, 200) var max_health: int = 5
var health: int = max_health
@export_range(-200, 200) var shield: int = 0
@export_range(0, 20) var max_actions: int = 3
var actions_left: int = 3 : set = _set_actions_left

@onready var actions_left_label: = $ActionsLeftLabel

func _ready() -> void:
	add_to_group("units")
	$HealthLabel/Label.text = str(health)
	_set_actions_left(actions_left)

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
	actions_left_label.text = str(val)

func move_smoothly_to(p: Vector2) -> void:
	var tw: = create_tween()
	tw.tween_property(self, "global_position", p, .2) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_QUAD)

func rand() -> float:
	return randf()
