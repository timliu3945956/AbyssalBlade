shader_type canvas_item;

/* Outer ring & fill colour + transparency */
uniform vec4 aoe_color : source_color = vec4(1.0, 0.0, 0.0, 0.3);

/* Ring thickness expressed as UV units (0–1) */
uniform float ring_width : hint_range(0.001, 0.1, 0.001) = 0.01;

/* How much of the inner radius is filled (0-1, where 1 = solid to centre) */
uniform float fill_value : hint_range(0.0, 1.0, 0.01) = 0.5;

void fragment() {
    vec2  uv     = UV;                   // 0-1 space on the sprite/quad
    float dist   = distance(uv, vec2(0.5));  // distance from centre (0.5,0.5)

    float alpha = 0.0;

    /* ----- outer ring ----- */
    if (dist >= 0.5 - 2.0 * ring_width && dist <= 0.5)
        alpha = aoe_color.a;

    /* ----- inner filled area ----- */
    if (dist < fill_value * 0.5)
        alpha = aoe_color.a;

    COLOR = vec4(aoe_color.rgb, alpha);
}