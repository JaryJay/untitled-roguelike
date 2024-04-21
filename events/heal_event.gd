class_name HealEvent extends Event

var target: Unit
var health: int
# might not use
var health_multiplier: int = 1

func perform(map: Map) -> void:
	target.health += health * health_multiplier
	#print("Target %s has %d health left" % [target.name, target.health])

func visual_effects(scene_tree: SceneTree) -> void:
	# TODO: Display some heal particles
	pass
