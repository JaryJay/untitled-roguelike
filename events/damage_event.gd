class_name DamageEvent extends Event

var target: Unit
var damage: int
# might not use
var damageMultiplier: int = 1

func perform(map: Map) -> void:
	target.health -= maxi(0, damage * damageMultiplier - target.shield)
	#print("Target %s has %d health left" % [target.name, target.health])

func visual_effects(scene_tree: SceneTree) -> void:
	scene_tree.get_first_node_in_group("cameras").shake(10)
