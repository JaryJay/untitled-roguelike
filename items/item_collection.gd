class_name ItemCollection

var _items: Array[Item]

func add_item(item: Item) -> void:
	_items.append(item)

func set_owner(owner: Unit) -> void:
	for item: Item in items():
		item.set_owner(owner)	

func modify_event_trigger(event_trigger: EventTrigger) -> EventTrigger:
	for item: Item in items():
		event_trigger = item.modify_event_trigger(event_trigger)
	return event_trigger

func items() -> Array[Item]:
	return _items
