class_name Unit extends Node2D

signal health_changed(new: int, old: int, source: Node2D)
signal health_depleted(source: Node2D)
signal ability_chosen(ability: Ability)

var item_collection: = ItemCollection.new()

@export var team: Team.s = Team.s.ALLY_PLAYER

var pos: Vector2i
@export var _ability_set: AbilitySet = AbilitySet.new()
# Only used by AI-controlled units
var _next_ability_context: AbilityContext = AbilityContext.new(self)

var status_effect_group: = StatusEffectGroup.new()
@export_range(0, 200) var max_health: int = 5
var health: int = max_health
@export_range(-200, 200) var shield: int = 0
@export_range(0, 20) var max_actions: int = 3
var actions_left: int = 3 : set = _set_actions_left

@export var ai: Ai
@onready var actions_left_label: = $ActionsLeftLabel
@onready var ability_selection_ui: = $AbilitySelectionUI

@onready var _selected: bool = false

func _ready() -> void:
	add_to_group("units")
	$HealthLabel/Label.text = str(health)
	actions_left_label.text = str(actions_left)
	_set_actions_left(actions_left)
	if (ai):
		ai.init(self)
	# Init AbilitySelectionUI
	ability_selection_ui.init(_ability_set)
	ability_selection_ui.ability_chosen.connect(_on_ability_chosen) 

func change_health(new_health: int, source: Variant) -> void:
	if health == new_health: return
	
	var old_health: = health
	health = new_health
	health_changed.emit(new_health, old_health, source)
	
	if health <= 0: health_depleted.emit(source)

func _set_actions_left(val: int) -> void:
	actions_left = val
	if is_node_ready():
		actions_left_label.text = str(val)

func move_smoothly_to(p: Vector2) -> void:
	var tw: = create_tween()
	tw.tween_property(self, "global_position", p, .2) \
		.set_ease(Tween.EASE_IN_OUT) \
		.set_trans(Tween.TRANS_QUAD)

func _on_ability_chosen(ability: Ability) -> void:
	ability_chosen.emit(ability)

func rand() -> float:
	return randf()

func ability_set() -> AbilitySet:
	return _ability_set

func next_ability_context() -> AbilityContext:
	return _next_ability_context

func is_selected() -> bool:
	return _selected

func set_selected(val: bool) -> void:
	_selected = val
