shader_type spatial;
render_mode unshaded;

void fragment() {
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r;
	vec3 ndc = vec3(SCREEN_UV, depth) * 2.0 - 1.0;
	vec4 w = inverse(PROJECTION_MATRIX) * vec4(ndc, 1.0);
	w.xyz /= w.w;
	vec3 dep = vec3(-w.z) / 10.0;
	
	ALBEDO = dep;
}
