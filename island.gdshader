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
	if (d < threshold) {
		float d2 = -log(max(d, 0.01)/threshold) * height;
		VERTEX.y = n * d2;
		norm = make_normal(texture(heightmap, UV+offset));
		NORMAL = norm;
	} else {
		VERTEX.y -= 1000.0;
	}
	//COLOR = vec4(d, d, d, 1.0);
}

void fragment() {
	ALBEDO = texture(color, UV+offset).xyz;
	if (d < threshold) {
		NORMAL = (VIEW_MATRIX * vec4(norm, 0.0)).xyz;
	}
}
