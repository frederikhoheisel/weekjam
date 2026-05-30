shader_type canvas_item;

uniform sampler2D screen_tex: hint_screen_texture;

uniform float roll_size = 15.0;
uniform float roll_speed = 8.0;
uniform float roll_variation = 1.8;
uniform float brightness = 1.4;
uniform float aberation = 0.03;
uniform float scanlines_width = 0.1;
uniform float scanlines_opacity = 0.1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec2 delta = uv - 0.5;
	float delta2 = dot(delta, delta);
	float delta4 = delta2 * delta2;
	uv += delta * delta4 * 1.0;
	
	float roll_line = 0.0;
	vec2 roll_uv = vec2(0.0);
	
	roll_line = smoothstep(0.3, 0.9, sin(uv.y * roll_size - (TIME * roll_speed)));
	roll_line *= roll_line * smoothstep(0.3, 0.9, sin(uv.y * roll_size * roll_variation - (TIME * roll_speed * roll_variation)));
	roll_uv = vec2(( roll_line * 0.002 * (1.0 - UV.x)), 0.0);
	
	vec4 tex;
	
	tex.r = texture(screen_tex, uv + roll_uv * 0.8 + vec2(aberation, 0.0) * 0.1).r;
	tex.g = texture(screen_tex, uv + roll_uv * 1.2 - vec2(aberation, 0.0) * 0.1).g;
	tex.b = texture(screen_tex, uv + roll_uv).b;
	tex.a = 1.0;
	
	float r = tex.r;
	float g = tex.g;
	float b = tex.b;
	
	float g_r = smoothstep(0.85, 0.95, abs(sin(uv.x * (384.0 * 3.14159265))));
	r = mix(r, r * g_r, 0.05);
	
	float g_g = smoothstep(0.85, 0.95, abs(sin(1.05 + uv.x * (384.0 * 3.14159265))));
	g = mix(g, g * g_g, 0.05);
	
	float b_b = smoothstep(0.85, 0.95, abs(sin(2.1 + uv.x * (384.0 * 3.14159265))));
	b = mix(b, b * b_b, 0.05);
	
	tex.r = clamp(r * brightness, 0.0, 1.0);
	tex.g = clamp(g * brightness, 0.0, 1.0);
	tex.b = clamp(b * brightness, 0.0, 1.0);
	
	float scanlines = 0.5;
	scanlines = smoothstep(scanlines_width, scanlines_width + 0.5, abs(sin(uv.y * (256.0 * 3.14159265))));
	tex.rgb = mix(tex.rgb, tex.rgb * vec3(scanlines), scanlines_opacity);
	
	float radius = 0.08;
	radius = max(min(min(abs(radius * 2.0), abs(1.0)), abs(1.0)), 1e-5);
	vec2 abs_uv = abs(uv * 2.0 - 1.0) - vec2(1.0, 1.0) + radius;
	float dist = length(max(vec2(0.0), abs_uv)) / radius;
	float square = smoothstep(0.96, 1.0, dist);
	tex.rgb *= clamp(1.0 - square, 0.0, 1.0);
	
	vec2 v_uv = 1.0 - uv;
	float vignette = v_uv.x * v_uv.y * 15.0;
	tex.rgb *= pow(vignette, 0.2);
	
	COLOR = tex;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
