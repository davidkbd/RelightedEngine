shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_burley,specular_schlick_ggx,world_vertex_coords;

uniform float speed_angle = .0;
uniform float speed_length = .1;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;
uniform sampler2D texture_normal : hint_albedo;
uniform float specular;
uniform float metallic;
uniform float roughness : hint_range(0,1);
uniform float point_size : hint_range(0,128);
varying vec3 uv1_triplanar_pos;
uniform float uv1_blend_sharpness;
varying vec3 uv1_power_normal;
uniform vec3 uv1_scale;
uniform vec3 uv1_offset;
uniform vec3 uv2_scale;
uniform vec3 uv2_offset;

void vertex() {
	vec3 uv1_scroll = vec3(.0) + uv1_offset;
	uv1_scroll.x -= TIME * cos(speed_angle) * speed_length;
	uv1_scroll.z -= TIME * sin(speed_angle) * speed_length;
	TANGENT = vec3(0.0,0.0,-1.0) * abs(NORMAL.x);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(NORMAL.y);
	TANGENT+= vec3(1.0,0.0,0.0) * abs(NORMAL.z);
	TANGENT = normalize(TANGENT);
	BINORMAL = vec3(0.0,-1.0,0.0) * abs(NORMAL.x);
	BINORMAL+= vec3(0.0,0.0,1.0) * abs(NORMAL.y);
	BINORMAL+= vec3(0.0,-1.0,0.0) * abs(NORMAL.z);
	BINORMAL = normalize(BINORMAL);
	uv1_power_normal=pow(abs(NORMAL),vec3(uv1_blend_sharpness));
	uv1_power_normal/=dot(uv1_power_normal,vec3(1.0));
	uv1_triplanar_pos = VERTEX * uv1_scale + uv1_scroll;
	uv1_triplanar_pos *= vec3(1.0,-1.0, 1.0);
}

vec3 rotateUV(vec3 uv, float rotation) {
	/*
	vec2 pivot = vec2(.5);
	float sine = sin(rotation);
	float cosine = cos(rotation);
	uv.xz -= pivot;
	uv.x = uv.x * cosine - uv.z * sine;
	uv.z = uv.x * sine + uv.z * cosine;
	uv.xz += pivot;*/
	return uv;
}

vec4 triplanar_texture(sampler2D p_sampler,vec3 p_weights,vec3 p_triplanar_pos) {
	vec4 samp=vec4(0.0);
	vec3 rotated_triplanar_pos = rotateUV(p_triplanar_pos, speed_angle);
	samp+= texture(p_sampler,rotated_triplanar_pos.xy) * p_weights.z;
	samp+= texture(p_sampler,rotated_triplanar_pos.xz) * p_weights.y;
	samp+= texture(p_sampler,rotated_triplanar_pos.zy * vec2(-1.0,1.0)) * p_weights.x;
	return samp;
}

void fragment() {
	vec4 albedo_tex = triplanar_texture(texture_albedo,uv1_power_normal,uv1_triplanar_pos);
	vec4 normal_tex = triplanar_texture(texture_normal,uv1_power_normal,uv1_triplanar_pos);
	ALBEDO = albedo.rgb * albedo_tex.rgb;
	NORMALMAP = normal_tex.rgb;
	NORMALMAP_DEPTH = .9;
	METALLIC = metallic;
	ROUGHNESS = roughness;
	SPECULAR = specular;
}
