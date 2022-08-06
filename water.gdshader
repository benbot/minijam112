shader_type spatial;

uniform vec2 wave_strengh = vec2(0.5, 0.25);
uniform vec2 wave_frequency = vec2(12.0, 12.0);
uniform vec2 time_factor = vec2(1.0, 2.0);

uniform sampler2D n1;
uniform sampler2D n2;

float waves(vec2 pos, float time){
	return (wave_strengh.y * sin(pos.y * wave_frequency.y + time * time_factor.y)) + (wave_strengh.x * sin(pos.x * wave_frequency.x + time * time_factor.x));
}

void vertex(){
	VERTEX.y += waves(VERTEX.xy, TIME);
}

void fragment() {
	float time = TIME * 0.02;
	vec3 noi1 = texture(n1, UV + time).rgb;
	vec3 noi2 = texture(n2, UV - time * 0.2).rgb;
	
	vec3 sum = noi1 + noi2 - vec3(1.0);
	
	ALPHA = 0.8;
	
	float depth = (texture(DEPTH_TEXTURE, SCREEN_UV)).z * 2.0 - 1.0;
	vec3 o = mix(sum, vec3(0.0, 0.06, 1.0), 0.9);
	
	ALBEDO = o;
}