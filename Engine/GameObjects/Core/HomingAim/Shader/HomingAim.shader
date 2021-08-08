shader_type spatial;
render_mode unshaded;

uniform vec4 albedo : hint_color = vec4(.0, 1.2, .1, 1.0);
uniform float point_size : hint_range(0,128);
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

uniform float rotation_speed = 1.0;

void vertex() {
	UV=UV*uv1_scale.xy+uv1_offset.xy;

	float t = TIME * rotation_speed;
//	VERTEX.y = VERTEX.y + .5 * (sin(t)*.12 + .12);

	float pivot_angle = t * .5;
	mat2 rotation_matrix = mat2(vec2(cos(pivot_angle), -sin(pivot_angle)), vec2(sin(pivot_angle), cos(pivot_angle)));
	VERTEX.xz = rotation_matrix * VERTEX.xz;
	
	NORMAL = VERTEX.xyz;
}

void fragment() {
	vec2 base_uv = UV;
	ALBEDO = albedo.rgb;
//	ALPHA = albedo.a;
}
