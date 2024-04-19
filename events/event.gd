class_name Event extends RefCounted

var source: Unit

func perform(_map: Map) -> void:
	assert(false, "perform() not implemented for %s" % get_class())

func visual_effects(scene_tree: SceneTree) -> void:
	pass
