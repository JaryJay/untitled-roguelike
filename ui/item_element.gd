class_name ItemElement extends AspectRatioContainer

signal pressed

@onready var texture_rect: = $Button/NinePatchRect/TextureRect
@onready var nine_patch_rect: = $Button/NinePatchRect

@export var backgrounds: Array[Texture2D]

var item: Item

func init(_item: Item) -> void:
	item = _item
	nine_patch_rect.texture = backgrounds[item.rarity]
	texture_rect.texture = item.texture

func _on_button_pressed() -> void:
	pressed.emit()
