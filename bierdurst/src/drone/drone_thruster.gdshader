shader_type spatial;
uniform sampler2D noise;
uniform sampler2D noise2;
uniform sampler2D color;

uniform float texture_speed = 0.0;
uniform float wiggle_amount = 0.1;

void vertex() {
	VERTEX.xyz += (vec3(0.5) - texture(noise2, UV + vec2(0.0, TIME * texture_speed)).rgb) * wiggle_amount * UV.y;
}

void fragment() {
	ALBEDO = max(texture(color, UV.yx).rgb, texture(noise, UV + vec2(0.0, TIME * texture_speed)).rgb);
	ALPHA = 1.0 - UV.y * 2.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
