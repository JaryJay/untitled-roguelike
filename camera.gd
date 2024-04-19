class_name GameCamera extends Camera2D

@export_range(0, 10) var decay_rate: float
@export var noise: FastNoiseLite
@export_range(0, 2000) var noise_shake_speed: float
var shake_strength: float = 0

var noise_i: float = 0

func _process(delta: float) -> void:
	shake_strength = lerpf(shake_strength, 0, decay_rate * delta)
	if is_zero_approx(shake_strength): shake_strength = 0
	offset = get_noise_offset(delta)

func get_noise_offset(delta: float) -> Vector2:
	noise_i += delta * noise_shake_speed
	return shake_strength * Vector2(noise.get_noise_2d(0, noise_i), noise.get_noise_2d(100, noise_i))

func shake(strength: float) -> void:
	shake_strength = strength
