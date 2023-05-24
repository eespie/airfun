shader_type spatial;

uniform sampler2D water_texture;
uniform sampler2D sand_texture;
uniform sampler2D grass_texture;
uniform sampler2D rock_texture;
uniform sampler2D snow_texture;

uniform float max_height;
uniform float min_grass_height;
uniform float min_rock_height;
uniform float min_snow_height;

uniform vec2 uvscale = vec2(1);
varying float vertex_y;

void fragment() {
	float vert_height = vertex_y;
	
	vec3 water = texture(water_texture, UV * uvscale).rgb;
	vec3 sand = texture(sand_texture, UV * uvscale).rgb;
	vec3 grass = texture(grass_texture, UV * uvscale).rgb;
	vec3 rock = texture(rock_texture, UV * uvscale).rgb;
	vec3 snow = texture(snow_texture, UV * uvscale).rgb;
	vec3 final_color;
	

	final_color = mix(water, mix(sand, mix(grass, mix(rock, snow, smoothstep(min_rock_height, min_snow_height, vert_height)), 
		smoothstep(min_grass_height, min_rock_height, vert_height)),
		smoothstep(0, min_grass_height, vert_height)),
		smoothstep(-1, min_grass_height, vert_height));

	ALBEDO = final_color.rgb;
}

void vertex() {
	vertex_y = VERTEX.y;
	if (vertex_y < 0.0) {
		VERTEX.y = 0.0;
	}
}