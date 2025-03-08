shader_type canvas_item;

// Gradients
uniform sampler2D vertical_gradient;
uniform sampler2D color_gradient;

// Effect parameters
uniform float size_effect : hint_range(-5.0, 5.0, 0.05) = 0.1;
uniform float highlight_strength : hint_range(-4.0, 4.0, 0.05) = 0.5;

// Toggle behavior
uniform bool color_mode_toggle = false;
uniform bool is_horizontal = false;

// PROGRESS UNIFORM
// A value from 0.0 (effect is off-screen/start) to 1.0 (effect fully passed)
// Key this with your AnimationPlayer to move highlight as desired
uniform float progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
    // Original color
    vec4 old_color = COLOR;

    // Instead of TIME, use progress directly.
    // We interpolate progress (0..1) into a value that goes a bit beyond
    // 0..1 to accommodate size_effect.
    float current_time = mix(-size_effect, 1.0 + size_effect, progress);

    // Calculate bounds of the highlight region
    float effect_lower_bound = current_time - size_effect;
    float effect_upper_bound = current_time + size_effect;

    // Pick which UV axis is used (vertical vs horizontal)
    float position_value = is_horizontal ? UV.x : UV.y;

    // Smoothstep to find how close we are to the center of the effect
    float effect_distance = smoothstep(effect_lower_bound, current_time, position_value)
                          - smoothstep(current_time, effect_upper_bound, position_value);

    // For color_mode_toggle == true, we only color the actual highlight zone
    // So we measure how far in the highlight the pixel is
    float inner_effect_position = smoothstep(effect_lower_bound, effect_upper_bound, position_value);

    // Use different coordinates for color gradient
    // If color_mode_toggle is off, the entire image uses color based on current_time
    // Otherwise, it uses (UV.x, inner_effect_position)
    vec2 color_position = color_mode_toggle
        ? vec2(UV.x, inner_effect_position)
        : vec2(current_time, 0.0);

    // Sample new color from the gradient
    vec4 new_color = texture(color_gradient, color_position);

    // Use the vertical_gradient to blend alpha / fade effect
    // We again sample using current_time for the vertical_gradient
    float alpha_factor = texture(vertical_gradient, vec2(current_time, 0.0)).r;
    new_color = mix(old_color, new_color, alpha_factor);

    // Finally, apply the highlight to the final color
    COLOR.rgb = mix(old_color.rgb, new_color.rgb, effect_distance * highlight_strength);
}
