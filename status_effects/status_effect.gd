class_name StatusEffect extends Resource

enum Type {
	# Take damage at start of turn
	BLEED,
	# Take damage at start of turn
	BURN,
	# Take damage at start of turn
	POISONED,
	# Skip turn, dies when health < 30%
	FROZEN,
	# Attacks deal 50% damage, rounded down
	WEAKENED,
	# Skip turn
	STUNNED,
}

const duration_of: PackedInt32Array = [
	2,
	2,
	2,
	1,
	1,
	1,
]

const is_stacking: PackedByteArray = [
	1,
	1,
	0,
	0,
	0,
	0,
]

@export var type: Type
var duration: int
var duration_remaining: int
var stack_count: int

func _init(_type: Type, _stack_count: int) -> void:
	type = _type
	duration = duration_of[type]
	duration_remaining = duration
	stack_count = _stack_count
	
