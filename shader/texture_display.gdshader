shader_type spatial;

uniform sampler2D tex;
varying float alpha;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = texture(tex, UV).rgb;
	alpha = texture(tex, UV).a;
}

void light() {
	DIFFUSE_LIGHT = ALBEDO;
	ALPHA = alpha;
}
