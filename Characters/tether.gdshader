shader_type canvas_item;

#define S smoothstep
#define IS(x, y, z) (1.0 - smoothstep(x, y, z))

uniform vec2 resolution = vec2(600.0, 400.0);
uniform vec3 line_color: source_color = vec3(0.2, 0.6, 0.2);
uniform float line_thickness: hint_range(0.01, 1.0, 0.01) = 0.05;
uniform float speed = 0.5;
uniform float amp_coef = 0.1;
uniform float freq_coef = 0.5;
uniform float iterations: hint_range(1.0, 20.0, 1.0) = 5.0;
uniform float brightness: hint_range(0.1, 20.0, 0.1) = 0.5;
uniform float line_alpha: hint_range(0.0, 1.0, 0.01) = 1.0;

vec4 draw_line(vec2 uv, vec3 color, float shift, float freq) {
	uv.y += IS(0.0, 1.0, abs(uv.x)) * sin(uv.x + shift * freq) * amp_coef * sin(uv.x + shift);
	float mask = IS(0.0, line_thickness * S(-0.2, 0.9, abs(uv.x)), abs(uv.y)) * line_alpha;
	vec3 line_col = color * mask;
	return vec4(line_col, mask);
}

void fragment() {
	vec2 uv = UV - 0.5;
	uv.x *= resolution.x / resolution.y;
	float shift = TIME * speed;
	vec3 color = vec3(0.0);
	float alpha = 0.0;
	for (float i = 0.0; i < iterations; i += 1.0) {
		vec4 line = draw_line(uv, line_color, shift + i * 0.4, 1.0 + freq_coef);
		color += line.rgb * line.a;
		alpha += line.a;
	}
	alpha = clamp(alpha, 0.0, 1.0);
	if (alpha > 0.0) {
		color /= alpha;
	}
	COLOR = vec4(color * brightness, alpha);
}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}
