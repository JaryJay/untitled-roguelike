class_name ChooseHeroDialog extends CanvasLayer

signal hero_chosen(hero: Hero)

const hero_element_scene: = preload("res://ui/hero_element.tscn")

@onready var container: = $Control/Container/HBoxContainer

func init(roster: Roster) -> void:
	for hero: Hero in roster.heroes():
		var hero_element: HeroElement = hero_element_scene.instantiate()
		hero_element.pressed.connect(hero_clicked.bind(hero))
		container.add_child(hero_element)
		hero_element.init(hero)

func hero_clicked(hero: Hero) -> void:
	hero_chosen.emit(hero)
