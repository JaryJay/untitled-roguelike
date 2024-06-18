shader_type canvas_item;

uniform vec4 color: source_color;
uniform float multiplier = .035;
uniform float softness = .905;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float value = distance(UV, vec2(0.5, 0.5));
	COLOR = vec4(color.rgb, smoothstep(multiplier, softness, value));
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
