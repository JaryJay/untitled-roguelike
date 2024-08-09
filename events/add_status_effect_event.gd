class_name AddStatusEffectEvent extends Event

var target: Unit
var status_effect_type: StatusEffect.Type
var stack: int = 1

func _init(_type: StatusEffect.Type, _stack: = 1) -> void:
	status_effect_type = _type
	stack = _stack

func perform(_map: Map) -> void:
	target.status_effect_group.add_status_effect(status_effect_type, stack)

func visual_effects(scene_tree: SceneTree) -> void:
	scene_tree.get_first_node_in_group("cameras").shake(10)
