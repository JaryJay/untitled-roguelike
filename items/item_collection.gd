class_name ItemCollection

var items: Array[Item]

func add_item(item: Item) -> void:
	items.append(item)

func modify_event_trigger(event_trigger: EventTrigger) -> EventTrigger:
	for item: Item in items:
		event_trigger = item.modify_event_trigger(event_trigger)
	return event_trigger
