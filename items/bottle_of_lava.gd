class_name BottleOfLava extends Item

func modify_event_trigger(event_trigger: EventTrigger) -> EventTrigger:
	if not event_trigger.source() == owner: return
	if not event_trigger.event is DamageEvent: return
	
	if event_trigger.source().rand() < 0.15:
		event_trigger.add_post_event(AddStatusEffectEvent.new(StatusEffect.Type.BURN))
	return event_trigger

