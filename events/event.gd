class_name Event extends RefCounted

var source: Unit

func perform_with_tween(map: Map, tw: Tween) -> void:
	tw.tween_interval(0.2)
	tw.tween_callback(perform.bind(map))

func perform(_map: Map) -> void:
	assert(false, "perform() not implemented for %s" % get_class())

func visual_effects(scene_tree: SceneTree) -> void:
	pass
