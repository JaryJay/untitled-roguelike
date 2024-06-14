class_name Items

const all: Array[Item] = [
	preload("res://items/test_item.tres"),
	preload("res://items/test_item2.tres"),
]

static func random() -> Item:
	return all.pick_random()
