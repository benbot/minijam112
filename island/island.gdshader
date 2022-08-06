shader_type spatial;

uniform sampler2D noise;
uniform sampler2D heightmap;
uniform sampler2D color;
uniform float threshold = 0.2;
uniform float height = 20.0;
varying float d;
varying vec3 norm;

uniform vec2 offset = vec2(0.0);

vec3 make_normal(vec4 normal) {
	vec3 h = normal.xzy * 2.0 - vec3(1.0);
	h.z *= -1.0;
	return h;
}

void vertex() {
	d = distance(UV, vec2(0.5, 0.5)+offset);
	float n = texture(noise, UV+offset).r;
	//if (d < threshold) {
		float d2 = -log(max(d, 0.01)/threshold) * height;
		VERTEX.y = n * d2 + 20.0;
		norm = make_normal(texture(heightmap, UV+offset));
		NORMAL = norm;
		VERTEX.y -= mix(0, 100.0, d);
	//}
}

void fragment() {
	ALBEDO = texture(color, UV+offset).xyz;
	//ALPHA = COLOR.a;
	NORMAL_MAP = texture(heightmap, UV+offset).xyz;
}
