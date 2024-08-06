class_name ItemElement extends Control

signal pressed

@onready var texture_rect: = $Aspect/Button/NinePatchRect/TextureRect
@onready var nine_patch_rect: = $Aspect/Button/NinePatchRect
@onready var name_label: = $NameLabel
@export var name_label_unhovered_color: Color
@export var name_label_hovered_color: Color

@export var backgrounds: Array[Texture2D]

var item: Item

func _ready() -> void:
	assert(
		backgrounds.size() == Item.Rarity.size(),
		"Background textures length doesn't match Item Rarity length. Expected: %s, got %s" % [Item.Rarity.size(), backgrounds.size()]
	)
	name_label.add_theme_color_override("font_color", name_label_unhovered_color)

func init(_item: Item) -> void:
	item = _item
	nine_patch_rect.texture = backgrounds[item.rarity]
	texture_rect.texture = item.texture
	name_label.text = item.name

func _on_button_pressed() -> void:
	pressed.emit()

func _on_button_mouse_entered() -> void:
	var tween_duration: = .05
	var tw: = create_tween().set_parallel(true).set_trans(Tween.TRANS_CIRC)
	tw.tween_property(texture_rect, "anchor_left", 0.15, tween_duration)
	tw.tween_property(texture_rect, "anchor_top", 0.15, tween_duration)
	tw.tween_property(texture_rect, "anchor_right", 0.85, tween_duration)
	tw.tween_property(texture_rect, "anchor_bottom", 0.85, tween_duration)
	tw.tween_property(name_label, "theme_override_colors/font_color", name_label_hovered_color, tween_duration)
	
func _on_button_mouse_exited() -> void:
	var tween_duration: = .05
	var tw: = create_tween().set_parallel(true)
	tw.tween_property(texture_rect, "anchor_left", 0.2, tween_duration)
	tw.tween_property(texture_rect, "anchor_top", 0.2, tween_duration)
	tw.tween_property(texture_rect, "anchor_right", 0.8, tween_duration)
	tw.tween_property(texture_rect, "anchor_bottom", 0.8, tween_duration)
	tw.tween_property(name_label, "theme_override_colors/font_color", name_label_unhovered_color, tween_duration)

