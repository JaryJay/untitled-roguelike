class_name Unit extends Node2D

var items: Array[Item] = []
var abilities: Array[Ability] = []
var pos: Vector2i
@export_range(0, 200) var health: int = 5
@export_range(-200, 200) var shield: int = 0

func _ready() -> void:
	add_to_group("units")
