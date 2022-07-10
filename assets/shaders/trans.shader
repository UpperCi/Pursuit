shader_type canvas_item;

uniform vec2 res = vec2(256, 144);
uniform vec3 trans_fill = vec3(0.27, 0.1568, 0.2352);
uniform vec3 trans_outline = vec3(1.0);
uniform sampler2D noise;
uniform float trans_time = 0.0;

void fragment() {
	vec2 uv = SCREEN_UV;
	uv = floor(uv * res) / res;
	float prog = textureLod(noise, uv, 0.0).r - trans_time + uv.y;
	if (abs(prog) < 0.75) {
		COLOR.rgb = trans_fill;
	} else if (abs(prog) < 0.76) {
		COLOR.rgb = trans_outline;
	} else {
		COLOR.rgb = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgb;
	}
}
