shader_type canvas_item;

// For optional extra brightness or color tint
uniform float intensity : hint_range(0.0, 5.0) = 1.0;
uniform vec4 tint : source_color = vec4(1.0, 0.0, 0.0, 1.0);

void fragment() {
    vec4 c = texture(TEXTURE, UV);
    // Multiply color by your tint and intensity
    c.rgb *= tint.rgb * intensity;
    COLOR = c;
}