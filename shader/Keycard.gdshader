shader_type spatial;

uniform sampler2D tex;
varying vec2 tc;

void vertex() {
	tc = UV;
}

void fragment() {
	//ALBEDO = vec3(tc.x, tc.y, 0);
	ALBEDO = texture(tex, tc).rgb;
}

void light() {
	DIFFUSE_LIGHT = ALBEDO;
}
