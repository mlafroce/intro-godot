shader_type canvas_item;

uniform float EXTRA_GLOW = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 pixel_color = texture(TEXTURE, UV);
	pixel_color.rgb += vec3(1.0, 1.0, 1.0) * EXTRA_GLOW;
	COLOR = pixel_color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
