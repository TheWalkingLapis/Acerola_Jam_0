shader_type spatial;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = vec3(UV.x, 1.-UV.y, 0.5);
	
}

void light() {
	DIFFUSE_LIGHT = ALBEDO;
}
