class_name BottleOfLava extends Item

func modify_event_trigger(event_trigger: EventTrigger):
	if not event_trigger.event is DamageEvent: return
	
	if event_trigger.source.rand() < 0.15:
		# TODO: Maybe instead of modifying the DamageEvent, create an
		# ApplyDebuffEvent instead
		event_trigger.event.burn = true
	

