shader_type spatial;
render_mode depth_draw_alpha_prepass, specular_schlick_ggx, unshaded;

uniform float alpha = .3;
uniform vec2 uv_scale = vec2(100.0);

vec3 MIX(vec3 x, vec3 y) {
	return abs(x-y);
}    

float CV(vec3 c, vec2 uv, vec2 iResolution) {
	float size = 640./iResolution.x*0.003;
	float l=clamp(size*(length(c.xy-uv)-c.z),0.,1.);
	return 1.-l;
}

void vertex() {
	float pivot_angle = 1.5708;
	mat2 rotation_matrix = mat2(vec2(cos(pivot_angle), -sin(pivot_angle)), vec2(sin(pivot_angle), cos(pivot_angle)));
	VERTEX.xz = rotation_matrix * VERTEX.xz;
	
	NORMAL = VERTEX.xyz;

	MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat4(CAMERA_MATRIX[0],CAMERA_MATRIX[1],CAMERA_MATRIX[2],WORLD_MATRIX[3]);
}

void fragment() {
	float iTime = TIME;
	vec2 iResolution = VIEWPORT_SIZE * .25;
	vec4 color = vec4(0,0,0,1);
	vec3 albedo = vec3(1.0,1.0,1.0);
	vec2 uv = UV * uv_scale;// + uv_offset;
	vec3 c = vec3(1.0);
	for(float i=0.;i<2600.;i+=13.)
    {
		
		float mix_param2 = CV(
				vec3(
						iResolution.x*(1.+sin(iTime*0.52+(i-1400.)*1.35))*.5,
						iResolution.y*(1.+sin(iTime*0.73+(i-1200.)*1.61))*.5,
						0.0),
				uv,
				iResolution);
		albedo.rgb = MIX(
				albedo.rgb,
				c * mix_param2
				);
    }
    albedo.rgb = (1. - albedo.rgb) * 1.01;
    albedo.rgb = pow(albedo.rgb,vec3(42.,32.,12.));
	ALBEDO = albedo.rgb;
	ALPHA = clamp(albedo.r, .5, 1.0) * alpha;
}