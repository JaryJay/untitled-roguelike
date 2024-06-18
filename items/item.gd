class_name Item extends Resource

enum Rarity { UNDEFINED = -1, COMMON, RARE, MYTHIC }

var owner: Unit

@export var texture: Texture2D
@export var name: StringName
@export_multiline var text: String
@export var rarity: Rarity

var stack_count: int = 1

func modify_event_trigger(event_trigger: EventTrigger) -> EventTrigger:
	assert(false, "modify_event_trigger not implemented")
	return null

func set_owner(unit: Unit) -> void:
	owner = unit
