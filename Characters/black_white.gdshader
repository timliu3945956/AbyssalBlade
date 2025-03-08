shader_type canvas_item;

uniform float fade_alpha : hint_range(0.0, 1.0) = 1.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);

    // Convert the color to grayscale
    float gray = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 grayscale = vec3(gray);

    // Apply the grayscale color and fade alpha
    COLOR = vec4(grayscale, tex_color.a * fade_alpha);
}
