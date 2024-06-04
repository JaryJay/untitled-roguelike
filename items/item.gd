class_name Item extends Resource

enum Rarity { COMMON, RARE, MYTHIC }

@export var texture: Texture2D
@export var name: StringName
@export_multiline var text: String
@export var rarity: Rarity

var stack_count: int = 1

func modify_event_trigger(event_trigger: EventTrigger) -> void:
	assert(false, "modify_event_trigger not implemented")
