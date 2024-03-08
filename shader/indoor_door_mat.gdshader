shader_type spatial;

uniform vec3 base_col : source_color;
uniform sampler2D aleph;

void vertex() {
}

void fragment() {
	ALBEDO = base_col;
	ALPHA = texture(aleph, vec2(UV.y, -UV.x)).a;
}

void light() {
}
