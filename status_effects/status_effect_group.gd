class_name StatusEffectGroup extends Resource

var status_effects: Array[StatusEffect] = []

func update() -> void:
	for status_effect: StatusEffect in status_effects:
		pass

func add_status_effect(status_type: StatusEffect.Type, stack_count: = 1) -> void:
	for status_effect: StatusEffect in status_effects:
		if not status_effect.type == status_type: continue
		
		var type: = status_effect.type
		if StatusEffect.is_stacking[type]:
			status_effect.stack_count += stack_count
		status_effect.duration_remaining = status_effect.duration
		return
	
	# If code reaches here, the status effect doesn't exist yet.
	status_effects.append(StatusEffect.new(status_type, stack_count))
