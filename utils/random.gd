class_name Random extends Node

static func weighted(weights: Array[int]) -> int:
	var sum_of_weight: = 0
	for i: int in weights.size():
		sum_of_weight += weights[i]
	var rnd: = randf_range(0, sum_of_weight)
	for i: int in weights.size():
		if rnd < weights[i]:
			return i
		rnd -= weights[i]
		
	assert(false, "should never get here")
	return -1
