shader_type canvas_item;

uniform vec4 flash_color : source_color = vec4(1.0);
uniform float flash_modifier : hint_range(0.0, 1.0) = 1.0;

uniform float contrast : hint_range(0.0, 3.0) = 1.0;
uniform float fade_alpha: hint_range(0.0, 1.0) = 1.0; // New uniform for fading

//---------------------------------------------
// CONTRAST
//---------------------------------------------
mat4 contrastMatrix(float _contrast) {
    float t = (1.0 - _contrast) / 2.0;
    return mat4(
        vec4(_contrast, 0.0, 0.0, 0.0),
        vec4(0.0, _contrast, 0.0, 0.0),
        vec4(0.0, 0.0, _contrast, 0.0),
        vec4(t, t, t, 1.0)
    );
}

void fragment() {
    vec4 color = texture(TEXTURE, UV);

    // Apply the flash effect
    color.rgb = mix(color.rgb, flash_color.rgb, flash_modifier);

	color = contrastMatrix(contrast) * color;

	color.a *= fade_alpha;

    // Apply contrast adjustment
    COLOR = color;
}
