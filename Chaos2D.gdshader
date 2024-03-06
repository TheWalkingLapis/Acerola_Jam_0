shader_type spatial;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	// Called for every pixel the material is visible on.
}

void light() {
	DIFFUSE_LIGHT = vec3(1,1,1);
}
