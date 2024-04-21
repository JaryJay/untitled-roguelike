extends Label

func _on_health_changed(new: int, _old: int, _source: Node2D):
	text = str(new)
