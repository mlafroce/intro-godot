shader_type canvas_item;

uniform float DAMAGED = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 pixel_color = texture(TEXTURE, UV);
	pixel_color.rgb += vec3(DAMAGED, -DAMAGED / 2.0, -DAMAGED / 2.0);
	COLOR = pixel_color;
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
