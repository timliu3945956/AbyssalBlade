shader_type canvas_item;

void fragment() {
    // Get the fragment position relative to the sprite's local coordinates
    vec2 pos = (SCREEN_UV) * TEXTURE_PIXEL_SIZE * textureSize(TEXTURE, 0);

    // Calculate the center and radius in pixels
    vec2 center = vec2(textureSize(TEXTURE, 0)) * 0.5; // Center of the sprite
    float radius = min(textureSize(TEXTURE, 0).x, textureSize(TEXTURE, 0).y) * 0.5; // Half of the smallest dimension

    // Calculate the distance from the center
    float dist = distance(pos, center);

    if (dist > radius) {
        discard;
    } else {
        COLOR = texture(TEXTURE, UV);
    }
}