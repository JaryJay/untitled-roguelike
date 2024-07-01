class_name StatusEffectGroup extends Resource

signal status_effect_added(type: StatusEffect.Type, count: int)
signal status_effect_increased(type: StatusEffect.Type, count: int)
signal status_effect_expired(type: StatusEffect.Type, count: int)

var status_effects: Array[StatusEffect] = []

func update() -> void:
	for status_effect: StatusEffect in status_effects:
		# TODO
		pass

func add_status_effect(status_type: StatusEffect.Type, stack_count: = 1) -> void:
	for status_effect: StatusEffect in status_effects:
		if not status_effect.type == status_type: continue
		
		# Status effect exists; we'll increase it
		var type: = status_effect.type
		if StatusEffect.is_stacking[type]:
			status_effect.stack_count += stack_count
		status_effect.duration_remaining = status_effect.duration
		status_effect_increased.emit(status_type, stack_count)
		return
	
	# If code reaches here, the status effect doesn't exist yet.
	status_effects.append(StatusEffect.new(status_type, stack_count))
	status_effect_added.emit(status_type, stack_count)

func get_status(status_type: StatusEffect.Type) -> StatusEffect:
	for status_effect: StatusEffect in status_effects:
		if status_effect.type == status_type:
			return status_effect
	return null
