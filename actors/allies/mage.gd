class_name Mage extends Ally

func _enter_tree():
	add_ability(MoveAbility.new("Move", 1))
	add_ability(DamageAbility.new("Fireball", 3, 1))

