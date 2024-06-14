class_name ItemElement extends Button

@onready var texture_rect: = $NinePatchRect/TextureRect
@onready var nine_patch_rect: = $NinePatchRect

@export var backgrounds: Array[Texture2D]

var item: Item

func init(_item: Item) -> void:
	item = _item
	nine_patch_rect.texture = backgrounds[item.rarity]
	texture_rect.texture = item.texture
