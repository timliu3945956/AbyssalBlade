shader_type canvas_item;

// This shader adds on top of the existing texture a wave interference
// animation originating at equidistant points from the centre. The points
// collide in the centre of the texture to create a hot point of high energy.

// Created by David Eccles (gringer) <bioinformatics@gringene.org>

/**
 * Number of originating points
 */
uniform int point_count = 6;

/**
 * Wavelength (as a proportion of the texture)
 */
uniform float wave_length = 0.15;

/**
 * Radius of the circule including the focal points
 */
uniform float focal_radius = 0.31;

/**
 * Standard Deviation for global pulse falloff
 */
uniform float falloff_sd = 0.2;

/**
 * Standard Deviation for point pulse falloff
 */
uniform float point_sd = 0.5;

/**
 * Standard Deviation for point pulse falloff
 */
uniform float cycle_period = 10.0;

/**
 * Number of waves to offset start point
 */
uniform float starting_offset = -0.75;

/**
 * Should the background texture be scaled based on the focused energy
 */
uniform bool scale_texture = true;

uniform float animation_time = 0.0;

uniform float fade_alpha = 1.0;

vec2 map_scale(vec2 uv, float x, float y){
	mat2 scale = mat2(vec2(x, 0.0), vec2(0.0, y));
	uv -= 0.5; // centre on origin
	uv = uv * scale; // apply scaling
	uv += 0.5; // re-centre to 0.5,0.5
	return uv;
}

void fragment() {
	float ampSum = 0.0;
	float timeFrac = mod(animation_time, cycle_period);
	// Initial inteference pattern
	for(int i = 0; i < point_count; i++){
		vec2 pt = vec2(sin(float(i) * 2.0 * PI / float(point_count)) * focal_radius + 0.5,
		               cos(float(i) * 2.0 * PI / float(point_count)) * focal_radius + 0.5);
		float dist = distance(pt, UV) / (wave_length);
		float point_smoothing = 2.0 / (point_sd * sqrt(2.0 * PI)) *
	                           exp(-1.0 * pow((dist - starting_offset - timeFrac / (wave_length * cycle_period)), 2.0) / pow(point_sd, 2.0));
		ampSum += sin(fract(dist + starting_offset - timeFrac / (wave_length * cycle_period)) * 2.0 * PI) * point_smoothing;
	}
	// how many waves is it into the centre
	float wave_centre_count = focal_radius / wave_length;
	// how long does it take to get there?
	float seconds_per_wave = wave_length * cycle_period;
	// [added fudge of 'sqrt(cycle_period / 10.0)'; I don't know why this is needed]
	float wave_centre_time = seconds_per_wave * wave_centre_count * sqrt(cycle_period / 10.0);
	float mag_scale = 0.0;
	if(scale_texture){
		if((timeFrac + starting_offset) > wave_centre_time){
			mag_scale = (clamp(((timeFrac + starting_offset) - wave_centre_time) / (wave_centre_time), 0.0, 1.0));
		}
	} else {
		mag_scale = 1.0;
	}
	// global filtering curve
	float centreDist = distance(vec2(0.5, 0.5), UV);
	float outer_smoothing = 1.0 / (falloff_sd * sqrt(2.0 * PI)) *
	                        exp(-1.0 * pow(centreDist, 2.0) / pow(falloff_sd, 2.0));
	ampSum *= outer_smoothing;

	vec4 baseTexture = vec4(0.0, 0.0, 0.0, 0.0);
	//texture(TEXTURE, map_scale(UV, 1.0 / mag_scale, 1.0 / mag_scale));

	// Called for every pixel the material is visible on.
	vec4 colour = vec4(0.0, 0.0, 0.0, abs(ampSum / 4.0) * fade_alpha);
	COLOR = baseTexture + colour;
}