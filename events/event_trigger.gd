## An intermediate object used when items affect an event
class_name EventTrigger

var pre_event_list: Array[Event]
var event: Event
var post_event_list: Array[Event]

func _init(e: Event) -> void:
	event = e

func add_pre_event(e: Event) -> void:
	pre_event_list.append(e)

func add_post_event(e: Event) -> void:
	post_event_list.insert(0, e)

## Do not continue using this object after calling finalize_into_event_list().
func finalize_into_event_list() -> Array[Event]:
	event.processed = true
	
	var res: Array[Event] = []
	res.append_array(pre_event_list)
	res.append(event)
	res.append_array(post_event_list)
	
	return res

func source() -> Unit:
	return event.source
