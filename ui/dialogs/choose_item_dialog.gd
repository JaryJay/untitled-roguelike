class_name ChooseItemDialog extends CanvasLayer

signal item_chosen(item)

const item_element_scene: = preload("res://ui/item_element.tscn")

@onready var container: = $Control/Container/HBoxContainer

func init_random(num_options: int = 3, rarity: Item.Rarity = Item.Rarity.UNDEFINED) -> void:
	for i: int in num_options:
		var item: Item = Items.random(rarity)
		var item_element: ItemElement = item_element_scene.instantiate()
		item_element.pressed.connect(item_clicked.bind(item))
		container.add_child(item_element)
		item_element.init(item)

func item_clicked(item: Item) -> void:
	item_chosen.emit(item)
