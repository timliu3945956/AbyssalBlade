shader_type canvas_item;
uniform sampler2D noise: repeat_enable, filter_nearest;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform float speed : hint_range(0.05, 0.5) = 0.1;
uniform float strength : hint_range(0.00, 0.5) = 0.1;
uniform float alpha : hint_range(0.0, 1.0) = 1.0;

vec3 srgb_to_linear(vec3 c) {
	return mix(c / 12.92, pow((c + 0.055) / 1.055, vec3(2.4)), step(0.04045, c));
}

vec3 linear_to_srgb(vec3 c) {
	return mix(c * 12.92, 1.055 * pow(c, vec3(1.0 / 2.4)) - 0.055, step(0.0031308, c));
}

void fragment() {
	float noise_value = texture(noise, UV + TIME * speed).r - 0.5;
	vec2 distortion = vec2(noise_value) * strength;
	vec4 distorted_color = texture(SCREEN_TEXTURE, SCREEN_UV + distortion);

	vec4 original_color = texture(SCREEN_TEXTURE, SCREEN_UV);
	distorted_color.rgb = srgb_to_linear(distorted_color.rgb);
	original_color.rgb = srgb_to_linear(original_color.rgb);

	vec4 final_color = mix(original_color, distorted_color, alpha);
	final_color.rgb = linear_to_srgb(final_color.rgb);


	COLOR = final_color;
}