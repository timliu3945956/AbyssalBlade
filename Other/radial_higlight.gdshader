shader_type canvas_item;

/*  ── USER TWEAKABLE UNIFORMS ─────────────────────────────────────────────── */
uniform sampler2D vertical_gradient;   // 1-pixel-high greyscale strip (x-axis)
uniform sampler2D color_gradient;      // 1-pixel-high colour strip (x-axis)

uniform float  size_effect        : hint_range(0.0,  5.0, 0.05) = 0.10; // ring half-width
uniform float  highlight_strength : hint_range(0.0,  4.0, 0.05) = 0.50;

uniform bool   color_mode_toggle = false;  // same purpose as before

/* progress = 0 (centre) … 1 (edge).  Animate this in AnimationPlayer.       */
uniform float  progress : hint_range(0.0, 1.0) = 0.0;
/* ────────────────────────────────────────────────────────────────────────── */

void fragment()
{
    vec4 base_col = COLOR;

    /* ---------- radial position (0 centre → ~0.707 corner) ---------------- */
    float dist = distance(UV, vec2(0.5));

    /* Radius of bright “ring” at this frame */
    const float MAX_RADIUS = 0.707106;  // √½ – reaches furthest corner of quad
    float r_curr   = mix(-size_effect, MAX_RADIUS + size_effect, progress);

    /* Bounds of the ring */
    float r_lo = r_curr - size_effect;
    float r_hi = r_curr + size_effect;

    /* How inside the ring are we?  (0 outside, 1 at centre of ring) */
    float ring_mask = smoothstep(r_lo, r_curr, dist) -
                      smoothstep(r_curr, r_hi, dist);

    /* Optional inner-fill colouring (only where ring_mask > 0) */
    float inner_pos = smoothstep(r_lo, r_hi, dist);

    /* Gradient sampling logic kept intact ------------------------------- */
    vec2 col_uv = color_mode_toggle
                    ? vec2(UV.x, inner_pos)     // per-pixel hue change
                    : vec2(r_curr / MAX_RADIUS, 0.0);

    vec4 grad_col = texture(color_gradient, col_uv);

    /* Alpha / fade from vertical gradient (still driven by radius) */
    float alpha_fac = texture(vertical_gradient,
                              vec2(r_curr / MAX_RADIUS, 0.0)).r;
    grad_col = mix(base_col, grad_col, alpha_fac);

    /* Blend the result into the sprite */
    COLOR.rgb = mix(base_col.rgb, grad_col.rgb, ring_mask * highlight_strength);
}
