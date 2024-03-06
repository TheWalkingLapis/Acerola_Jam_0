shader_type spatial;

uniform sampler2D chaos_tex;
uniform sampler2D noise;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float noise_val_1 = texture(noise, UV + 0.03*vec2(sin(TIME), cos(TIME))).r;
	float noise_val_2 = texture(noise, UV*0.5 + 0.02*vec2(cos(TIME), -sin(TIME))).r;
	vec3 chaos_col = texture(chaos_tex, SCREEN_UV).rgb;
	ALBEDO = chaos_col * (noise_val_1 + noise_val_2)/1.5;
}

void light() {
	DIFFUSE_LIGHT = ALBEDO;
}
