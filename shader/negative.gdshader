shader_type canvas_item;

uniform sampler2D viewport : hint_screen_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR = vec4(vec3(1.0) - texture(viewport, UV).rgb, 1.0);
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
