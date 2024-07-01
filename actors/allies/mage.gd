class_name Mage extends Ally

func _enter_tree() -> void:
	add_ability(MoveAbility.new(1, "Move", 1))
	add_ability(DamageAbility.new(1, "Fireball", 3, 1))
	add_ability(DamageAbility.new(3, "Icicle", 4, 5))

