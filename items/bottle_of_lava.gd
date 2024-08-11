class_name BottleOfLava extends Item

func modify_event_trigger(event_trigger: EventTrigger) -> EventTrigger:
	assert(owner() != null, "owner not yet defined")
	if not event_trigger.source() == owner(): return event_trigger
	if not event_trigger.event is DamageEvent: return event_trigger
	
	var damage_event: DamageEvent = event_trigger.event
	
	if owner().rand() < 0.85:
		var status_effect_event: = AddStatusEffectEvent.new(StatusEffect.Type.BURN)
		status_effect_event.source = owner()
		status_effect_event.target = damage_event.target
		event_trigger.add_post_event(status_effect_event)
	return event_trigger

