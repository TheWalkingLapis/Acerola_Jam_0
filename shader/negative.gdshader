shader_type canvas_item;

uniform sampler2D viewport : hint_screen_texture;
uniform sampler2D noise;
uniform float time;

const float stages = 50.;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float stage = time/4.0;
	if (texture(noise, UV).r > stage) {
		COLOR = vec4(vec3(1.0) - texture(viewport, UV).rgb, 1.0); //1.0-0.25*time); fade
	} else {
		COLOR = vec4(0., 0., 0., 1.);
	}
}

void light() {
	// Called for every pixel for every light affecting the CanvasItem.
}
