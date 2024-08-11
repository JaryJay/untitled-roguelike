class_name BottleOfLava extends Item

func modify_event_trigger(event_trigger: EventTrigger) -> EventTrigger:
	assert(owner() != null, "owner not yet defined")
	if not event_trigger.source() == owner(): return
	if not event_trigger.event is DamageEvent: return
	
	if owner().rand() < 0.15:
		event_trigger.add_post_event(AddStatusEffectEvent.new(StatusEffect.Type.BURN))
	return event_trigger

