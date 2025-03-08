shader_type canvas_item;

uniform bool blink = false;
uniform float blink_speed = 5.0;

void fragment() {
    // Get the original color of the pixel
    vec4 tex_color = texture(TEXTURE, UV);

    // If blinking is active
    if (blink) {
        // Calculate the alpha based on time to create a blinking effect
        float alpha = abs(sin(TIME * blink_speed));

        // Blend the original color with red
        tex_color.rgb = mix(tex_color.rgb, vec3(1.0, 0.0, 0.0), alpha);
    }

    COLOR = tex_color;
}
