extends Node2D

const battle_location_scene: = preload("res://world/battle_location.tscn")
const battle_scene: = preload("res://battle/battle.tscn")

@export var width: float = 500
@export var vert_separation: float = 50

@export_range(1, 20) var number_of_layers: int

enum { UNINITIALIZED, INITIALIZED, SPECTATE }
var state: = UNINITIALIZED

func _ready() -> void:
	if state == UNINITIALIZED:
		initialize()
	
	# Connect locations' on press signals
	for node: Node in $Locations.get_children():
		if not node is Location: continue
		
		var loc: Location = node
		loc.pressed.connect(_on_loc_pressed.bind(loc))

func initialize() -> void:
	# Procedurally generate locations
	for i: int in range(number_of_layers):
		var num_locs: = randi_range(1, mini(i+1, 4))
		for j: int in range(num_locs):
			var location: = battle_location_scene.instantiate()
			location.position.x = 1. * width / (num_locs + 1) + randf_range(-500, 500) # TODO
			location.position.y = -i * vert_separation
			$Locations.add_child(location)
	$Locations.get_child(0).disabled = false
	state = INITIALIZED

func _on_loc_pressed(loc: Location) -> void:
	print("You selected location %s " % loc.name)
	#if loc is BattleLocation:
	var battle: = battle_scene.instantiate()
	hide()
	get_tree().root.add_child(battle)
