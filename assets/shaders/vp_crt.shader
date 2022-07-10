shader_type canvas_item;

uniform vec2 res = vec2(256, 144);
//uniform vec2 res = vec2(32, 18);

// options
uniform bool stretch_screen = true;
uniform bool do_scanline = true;
uniform bool do_noise = true;
uniform bool do_subpixel = true;
uniform bool slot_mask = false;
uniform bool blur_slots = false;

uniform bool rotate_pixels = false;

// round monitor knobs
uniform float stretch = 0.3;
uniform float zoom = 0.975;

// scanline knobs
uniform float scan_min = 0.3;
uniform float scan_max = 0.8;

// rgb subpixel knobs
uniform float rgb_min = 0.3;
uniform float rgb_mult = 1.1;
uniform float rgb_treshold = 0.2;
uniform float backlight = 0.4;

// noise
uniform float noise_mult = 0.1;

uniform float PI = 3.141592;

vec2 stretch_uv(vec2 uv) {
	float x_off = (-0.5 + uv.x);
	float y_off = (-0.5 + uv.y);
	float off_mod = zoom + (x_off * x_off * stretch) + (y_off * y_off * stretch);
	return vec2(0.5 + x_off * off_mod, 0.5 + y_off * off_mod);
}

float get_pix_x(float uvx) {
	return sin(uvx * res.x * PI);
}

float get_pix_y(float uvy) {
	return sin(uvy * res.y * PI);
}

float get_rgb(vec2 uv, float offset) {
	float v = sin((uv.x * 2.0 + offset) * res.x * PI) / 2.0 + 0.5;
	v = max(v, rgb_min);
	float mult = 1.0 / (1.0 - rgb_treshold);
	v -= rgb_treshold;
	//return v;
	return v * rgb_mult * mult + backlight;
}

vec3 rgb_mod(vec2 uv) {
	if (rotate_pixels)
		uv = vec2(uv.y, uv.x);
	float r = get_rgb(uv, 0.0);
	float g = get_rgb(uv, 0.333);
	float b = get_rgb(uv, 0.667);
	
	return vec3(r, g, b);
}

float scanline(float pix_y) {
	float scan = max(abs(pix_y), scan_min);
	scan = min(scan, scan_max);
	scan /= scan_max;

	return scan;
}

float rand(vec2 co){
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	if (stretch_screen)
		uv = stretch_uv(uv);
	
	bool even = (sin((uv.x * res.x + -0.07) * PI) > 0.0);
	if (!even && slot_mask) uv.y -= 0.5 / res.y;
	
	vec2 pix_uv = floor(uv * res);
	
	vec3 tex;
	
	if (!even && slot_mask && blur_slots) {
		vec3 tex_up = tex = textureLod(SCREEN_TEXTURE, 
		vec2(uv.x, uv.y), 0.0).rgb;
		vec3 tex_down = tex = textureLod(SCREEN_TEXTURE, 
		vec2(uv.x, uv.y + 1.0 / res.y), 0.0).rgb;
		tex = mix(tex_up, tex_down, 0.5);
	} else {
		tex = textureLod(SCREEN_TEXTURE, uv, 0.0).rgb;
	}
	
	if (do_noise)
		tex += (rand(pix_uv * (TIME * 0.01)) - 0.5) * noise_mult;
	
	COLOR.rgb = tex;
	if (do_subpixel)
		COLOR.rgb *= rgb_mod(uv);
	if (do_scanline && !rotate_pixels)
		COLOR.rgb *= vec3(scanline(get_pix_y(uv.y)));
	else if (do_scanline)
		COLOR.rgb *= vec3(scanline(get_pix_x(uv.x)));
	
	if (abs(0.5 - uv.x) > 0.5 || abs(0.5 - uv.y) > 0.5) {
		COLOR.rgb = vec3(0.0);
	}
}
