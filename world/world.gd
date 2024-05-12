extends Node2D

const battle_scene: = preload("res://battle/battle.tscn")

@export_range(1, 20) var min_num_layers: int
@export_range(1, 20) var max_num_layers: int

enum { UNINITIALIZED, INITIALIZED, SPECTATE }
var state: = UNINITIALIZED

var current_location: Location

func _ready() -> void:
	if state == UNINITIALIZED:
		initialize()
	
	# Connect locations' on press signals
	for node: Node in $Locations.get_children():
		if not node is Location: continue
		
		var loc: Location = node
		loc.pressed.connect(_on_loc_pressed.bind(loc))

func initialize() -> void:
	var num_layers: = randi_range(min_num_layers, max_num_layers)
	print(min_num_layers, " ", max_num_layers, " ", num_layers)
	
	var locations: = WorldGenerator.new().generate_locations(num_layers)
	
	for loc: Location in locations:
		$Locations.add_child(loc)
	
	state = INITIALIZED

func _on_loc_pressed(loc: Location) -> void:
	print("You selected location %s " % loc.name)
	current_location = loc
	#if loc is BattleLocation:
	var battle: = battle_scene.instantiate()
	hide()
	get_tree().root.add_child(battle)
	battle.victory.connect(_on_battle_victory.bind(battle))

func _on_battle_victory(battle: Battle) -> void:
	battle.queue_free()
	show()
	current_location.disabled = true
	for loc: Location in current_location.will_unlock:
		loc.disabled = false                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        
