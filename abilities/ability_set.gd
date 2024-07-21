class_name AbilitySet extends Resource

@export var abilities0: Array[Ability]
@export var abilities1: Array[Ability]
@export var abilities2: Array[Ability]

func get_all_abilities() -> Array[Ability]:
	const res: Array[Ability] = []
	res.append_array(abilities0)
	res.append_array(abilities1)
	res.append_array(abilities2)
	return res
