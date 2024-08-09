extends Node2D

const battle_scene: = preload("res://battle/battle.tscn")
const choice_scene: = preload("res://choice/choice.tscn")
const choose_item_dialog_scene: = preload("res://ui/dialogs/choose_item_dialog.tscn")
const choose_hero_dialog_scene: = preload("res://ui/dialogs/choose_hero_dialog.tscn")

@export_range(1, 20) var min_num_layers: int
@export_range(1, 20) var max_num_layers: int

enum { UNINITIALIZED, INITIALIZED, SPECTATE }
var state: = UNINITIALIZED

var roster: Roster = Roster.new()
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
	init_roster()
	
	var num_layers: = randi_range(min_num_layers, max_num_layers)
	var locations: = WorldGenerator.new().generate_locations(num_layers)
	
	for loc: Location in locations:
		$Locations.add_child(loc)
	
	state = INITIALIZED

func init_roster() -> void:
	var mage1: = Hero.new("Mage1", 10)
	mage1.add_ability(MoveAbility.create(1, "Move", 1))
	mage1.add_ability(DamageAbility.create(1, "Fireball", 3, 1))
	mage1.add_ability(DamageAbility.create(3, "Icicle", 3, 5))
	roster.heroes().append(mage1)
	
	var mage2: = Hero.new("Mage2", 10)
	mage2.starting_pos = Vector2i(1, 1)
	mage2.add_ability(MoveAbility.create(1, "Move", 1))
	mage2.add_ability(DamageAbility.create(1, "Fireball", 3, 1))
	mage2.add_ability(DamageAbility.create(3, "Icicle", 3, 5))
	roster.heroes().append(mage2)
	

func _on_loc_pressed(loc: Location) -> void:
	print("You selected location %s " % loc.name)
	current_location = loc
	if loc is BattleLocation:
		var battle: Battle = battle_scene.instantiate()
		hide()
		get_tree().root.add_child(battle)
		battle.init(roster)
		battle.victory.connect(_on_battle_victory.bind(battle))
	elif loc is ChoiceLocation:
		var choice: = choice_scene.instantiate()
		hide()
		get_tree().root.add_child(choice)
		# TODO: Do something when user makes a choice

func _on_battle_victory(battle: Battle) -> void:
	battle.queue_free()
	var choose_item_dialog: ChooseItemDialog = choose_item_dialog_scene.instantiate()
	add_child(choose_item_dialog)
	choose_item_dialog.init_random()
	choose_item_dialog.item_chosen.connect(func(item: Item) -> void:
		print("You selected item %s" % item.name)
		choose_item_dialog.queue_free()
		_on_item_chosen(item)
	)

func _on_item_chosen(item: Item) -> void:
	var choose_hero_dialog: ChooseHeroDialog = choose_hero_dialog_scene.instantiate()
	add_child(choose_hero_dialog)
	choose_hero_dialog.init(roster)
	choose_hero_dialog.hero_chosen.connect(func(hero: Hero) -> void:
		print("You selected hero %s" % hero.name)
		choose_hero_dialog.queue_free()
		hero.item_collection.add_item(item)
		_after_completing_location()
	)

func _after_completing_location() -> void:
	show()
	current_location.disabled = true
	for loc: Location in current_location.will_unlock:
		loc.disabled = false


