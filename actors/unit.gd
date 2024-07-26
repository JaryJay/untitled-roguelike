class_name Unit extends Node2D

signal health_changed(new: int, old: int, source: Node2D)
signal health_depleted(source: Node2D)
signal ability_chosen(ability: Ability)

@export var team: Team.s = Team.s.ALLY_PLAYER

var pos: Vector2i
var _item_collection: ItemCollection
@export var _ability_set: AbilitySet
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
@onready var actions_label: = $ActionsLabel
@onready var ability_selection_ui: = $AbilitySelectionUI

@onready var _selected: bool = false

func _ready() -> void:
	# Check that required fields are set
	assert(get_ability_set() != null, "No ability set.")
	assert(get_item_collection() != null, "No item collection.")
	if Team.is_ai(team):
		assert(ai != null, "No AI.")
	else:
		assert(ai == null, "AI exists but team is %s." % team)
	
	add_to_group("units")
	$HealthLabel/Label.text = str(health)
	actions_left_label.text = str(actions_left)
	_set_actions_left(actions_left)
	if ai:
		ai.init(self)
	# Init AbilitySelectionUI
	if (Team.is_player(team)):
		ability_selection_ui.enable()
		ability_selection_ui.init(_ability_set)
		ability_selection_ui.ability_chosen.connect(_on_ability_chosen) 

func change_health(new_health: int, source: Variant) -> void:
	if health == new_health: return
	
	var old_health: = health
	health = new_health
	health_changed.emit(new_health, old_health, source)
	
	if health <= 0: health_depleted.emit(source)

func has_actions_left() -> bool:
	return actions_left > 0

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

# For AI to show what abilities they're going to use
func update_ability_ui() -> void:
	actions_label.text = ""
	for ability: Ability in next_ability_context().get_all_abilities():
		actions_label.text += "%s " % ability.name

func rand() -> float:
	return randf()

func get_item_collection() -> ItemCollection:
	return _item_collection

func set_item_collection(item_collection: ItemCollection) -> void:
	assert(item_collection != null, "Item collection cannot be set to null.")
	_item_collection = item_collection

func get_ability_set() -> AbilitySet:
	return _ability_set

func set_ability_set(ability_set: AbilitySet) -> void:
	_ability_set = ability_set

func next_ability_context() -> AbilityContext:
	return _next_ability_context

func is_selected() -> bool:
	return _selected

func set_selected(val: bool) -> void:
	_selected = val
	if !ability_selection_ui.is_disabled():
		ability_selection_ui.visible = val
	else:
		ability_selection_ui.hide()
