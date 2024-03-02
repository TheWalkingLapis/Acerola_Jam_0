shader_type spatial;

uniform sampler2D noise_l1;
uniform sampler2D noise_l2;

varying float alignment;
varying vec3 n;

void vertex() {
	n = NORMAL;
}

void fragment() {
	vec3 orange = vec3(0.9,.55,.05);
	vec3 red = vec3(1.0, 0,0);
	alignment = clamp(dot(VIEW, NORMAL),0,1);
	float noise_val = 0.5 * (texture(noise_l1, UV).r + texture(noise_l2, UV).r);
	ALBEDO = mix(orange, red, noise_val);
}

void light() {
	DIFFUSE_LIGHT = ALBEDO;
}
