class_name Items

const all: Array[Item] = [
	preload("res://items/test_item.tres"),
	preload("res://items/test_item2.tres"),
]

static func random(rarity: Item.Rarity) -> Item:
	if rarity == Item.Rarity.UNDEFINED:
		return all.pick_random()
	return all.filter(func(i: Item): return i.rarity == rarity).pick_random()
