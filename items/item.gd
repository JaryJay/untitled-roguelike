class_name Item extends Resource

enum Rarity { UNDEFINED = 0, COMMON, RARE, MYTHIC }

var _owner: Unit

@export var texture: Texture2D
@export var name: StringName
@export_multiline var text: String
@export var rarity: Rarity

var stack_count: int = 1

func modify_event_trigger(_event_trigger: EventTrigger) -> EventTrigger:
	assert(false, "modify_event_trigger not implemented")
	return null

func owner() -> Unit:
	return _owner

func set_owner(owner: Unit) -> void:
	_owner = owner
