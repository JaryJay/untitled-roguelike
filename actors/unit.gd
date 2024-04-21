class_name Unit extends Node2D

signal health_changed(new, old, source)
signal health_depleted(source)

var items: Array[Item] = []
var abilities: Array[Ability] = []
var pos: Vector2i
@export_range(0, 200) var health: int = 5
@export_range(-200, 200) var shield: int = 0

func _ready() -> void:
	add_to_group("units")
	$HealthLabel/Label.text = str(health)

func change_health(new_health: int, source: Variant) -> void:
	if health == new_health: return
	
	var old_health: = health
	health = new_health
	health_changed.emit(new_health, old_health, source)
	
	if health <= 0: health_depleted.emit(source)

