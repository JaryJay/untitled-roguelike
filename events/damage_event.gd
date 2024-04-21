class_name DamageEvent extends Event

var target: Unit
var damage: int
# might not use
var damage_multiplier: int = 1

func perform(map: Map) -> void:
	var new_health: = target.health - maxi(0, damage * damage_multiplier - target.shield)
	target.change_health(new_health, source)
	#print("Target %s has %d health left" % [target.name, target.health])

func visual_effects(scene_tree: SceneTree) -> void:
	scene_tree.get_first_node_in_group("cameras").shake(10)
