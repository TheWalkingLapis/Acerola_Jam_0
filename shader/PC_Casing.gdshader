shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.
}

void light() {
	DIFFUSE_LIGHT = .7 * vec3(.4,.4,1);
}
