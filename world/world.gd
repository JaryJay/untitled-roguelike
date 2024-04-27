extends Node2D

func _ready() -> void:
	for node: Node in $Locations.get_children():
		if not node is Location: continue
		
		var loc: Location = node
		loc.pressed.connect(_on_loc_pressed.bind(loc))

func _on_loc_pressed(loc: Location) -> void:
	print("You selected location %s " % loc.name)
