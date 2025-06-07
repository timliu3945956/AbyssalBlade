shader_type canvas_item;
render_mode unshaded, blend_mix;

// ──────────  Base texture ──────────
group_uniforms base_texture;
uniform sampler2D albedo_texture : source_color;
uniform float     albedo_alpha : hint_range(0.0,1.0) = 1.0;

// ──────────  Tint & edge ───────────
group_uniforms tint_edge;
uniform vec4  tint_color  : source_color = vec4(1.0,0.5,0.0,0.5);   // #FF8000
uniform vec4  edge_color  : source_color = vec4(1.0,0.0,0.0,1.0);   // #FF0000
uniform float edge_power  : hint_range(0.0,1.0) = 0.5;              // controls fresnel fall-off
uniform float edge_size   : hint_range(0.1,5.0) = 1.0;              // outline thickness
uniform float edge_intensity : hint_range(0.0,2.0) = 0.8;

// ──────────  Scan-lines ────────────
group_uniforms scanlines;
uniform sampler2D scanline_texture;                 // optional (unused – kept for compatibility)
uniform vec4  scanline_tint : source_color = vec4(1.0,0.5,0.0,1.0);
uniform float scanline_intensity : hint_range(0.0,2.0) = 1.0;
uniform float scanline_density   : hint_range(0.0,10.0)= 5.0;
uniform float scanline_thickness : hint_range(0.1,3.0) = 1.0;
uniform float scanline_spacing   : hint_range(0.5,4.0) = 1.0;
uniform float scanline_angle     : hint_range(0.0,6.283) = 0.0;
uniform float scanline_speed = 0.2;

// ──────────  Glitch  ───────────────
group_uniforms glitch;
uniform bool  enable_glitch = false;
uniform float glitch_intensity : hint_range(0.0,1.0) = 0.5;
uniform float shake_power   : hint_range(0.0,1.0) = 0.5;
uniform float shake_rate    : hint_range(0.0,1.0) = 0.5;
uniform float shake_speed   : hint_range(0.0,10.0)= 5.0;
uniform float shake_block_size : hint_range(1.0,100.0)=30.5;
uniform float shake_color_rate : hint_range(0.0,1.0)=0.5;

float rand(float x){ return fract(sin(x*12345.678)*43758.5453); }

varying float enable_shift;

void vertex(){
    //if(!enable_glitch){ enable_shift = 0.0; return; }

    float t = mod(TIME,5.0);
    enable_shift = float(rand(floor(t*shake_speed)) < shake_rate);

    // shift whole scan-line block horizontally (pixel units)
    float slice    = floor(VERTEX.y/ shake_block_size);
    float offset_x = (rand(slice + t) - 0.5) * shake_power * enable_shift;
    VERTEX.x      += offset_x;
}

void fragment(){
    float t = mod(TIME,5.0);
    vec2  uv = UV;

    // same block-wise X distortion in fragment stage (keeps texture & mesh aligned)
    if(enable_glitch && glitch_intensity>0.0){
        float slice = floor(uv.y*shake_block_size);
        uv.x += (rand(slice + t) - 0.5) * shake_power * enable_shift;
    }

    // ── RGB split ───────────────────
    vec4 col;
    if(enable_glitch && shake_color_rate>0.0){
        float offs = shake_color_rate * enable_shift * 0.0075; // tiny UV shift
        vec2  r_uv = uv + vec2( offs,0.0);
        vec2  g_uv = uv;
        vec2  b_uv = uv + vec2(-offs,0.0);
        col = vec4(
            texture(albedo_texture,r_uv).r,
            texture(albedo_texture,g_uv).g,
            texture(albedo_texture,b_uv).b,
            1.0
        );
    }else{
        col = texture(albedo_texture,uv);
    }

    col.a *= albedo_alpha;

    // ── Fresnel-like edge in 2-D  ───
    // Use screen-space distance from sprite centre instead of dot(NORMAL,VIEW)
    vec2  centre_uv = uv - 0.5;
    float edge      = 1.0 - clamp(length(centre_uv)*2.0, 0.0,1.0);
    edge            = pow(edge, mix(8.0,2.0,edge_power));
    edge            = smoothstep(0.5-edge_size*0.1, 0.5+edge_size*0.1, edge);
    vec4 edge_fx    = edge_color * edge * edge_intensity;

    // ── Scan-lines  ─────────────────
    vec4 scan = vec4(0.0);
    if(scanline_density>0.001){
        // convert to viewport UV (0-1 across the screen)
        vec2 screen_uv   = SCREEN_UV;
        vec2 dir         = vec2(cos(scanline_angle), sin(scanline_angle));
        float scan_pos   = dot(screen_uv, dir);
        float spacing    = mix(50.0,10.0, scanline_density/10.0) * scanline_spacing;
        float line       = fract(scan_pos*spacing + TIME*scanline_speed);
        line             = smoothstep(
                              0.5-0.1*scanline_thickness,
                              0.5+0.1*scanline_thickness,
                              abs(line-0.5));
        scan = vec4(scanline_tint.rgb * line * scanline_intensity,
                    line * scanline_tint.a);
    }

    // ── Tint  ───────────────────────
    vec4 tinted = mix(col, col*tint_color, tint_color.a);

    COLOR = vec4(
        tinted.rgb + edge_fx.rgb + scan.rgb,
        max(tinted.a, max(edge_fx.a, scan.a))
    );
}