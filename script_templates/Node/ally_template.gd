class_name AllyTemplate extends Ally

func _enter_tree() -> void:
	add_ability(MoveAbility.new("Move", 1))
