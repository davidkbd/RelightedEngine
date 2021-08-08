// Port of Unity Ice Shader to Godot
// by NekotoArts
// OG Shader here - https://www.youtube.com/watch?v=Gym5JWHgjkk
//
//
// my bruddahs dont dab we just Vossi Bop

shader_type spatial;
render_mode depth_draw_alpha_prepass, specular_schlick_ggx, unshaded;

uniform float FresnelPower = 2.5;
uniform vec4 FresnelColor : hint_color;
uniform vec4 Color : hint_color;
uniform vec3 Tiling = vec3(1.0, 1.0, 0.0);
uniform vec3 Offset = vec3(0.0, 0.0, 0.0);
uniform sampler2D Ice_Texture : hint_albedo;
uniform float RefractionAmount = 1.0;
uniform float Metallic = 0.134;
uniform float Smoothness = 0.627;
uniform float Normals = 0.77;


// TilingAndOffsetUV

vec2 ti1ingN0ffsetFunc(vec2 _uv_tN0, vec2 _offset_tN0){
	return vec2(mod(_uv_tN0.x + _offset_tN0.x, 1.0), mod(_uv_tN0.y + _offset_tN0.y, 1.0));
}

// ReadNormalMap

// Pulled straight from Godot's scene.glsl file
vec3 read_normalmap(in vec3 normalmap, in vec3 normal, in vec3 tangent, in vec3 binormal, in float normaldepth) {
	normalmap.xy = normalmap.xy * 2.0 - 1.0;
	normalmap.z = sqrt(max(0.0, 1.0 - dot(normalmap.xy, normalmap.xy))); //always ignore Z, as it can be RG packed, Z may be pos/neg, etc.
	
	return normalize(mix(normal, tangent * normalmap.x + binormal * normalmap.y + normal * normalmap.z, normaldepth));
}

void vertex() {
// Output:0

}

void fragment() {
// Fresnel:22
	float n_out22p0 = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), FresnelPower);

// VectorOp:25
	vec3 n_out25p0 = vec3(n_out22p0) * vec3(FresnelColor.rgb);

// ColorUniform:5
	vec3 color_rgb = Color.rgb;
	float color_alpha = Color.a;

// Input:29
	vec3 n_out29p0 = vec3(UV, 0.0);

// VectorUniform:31
	vec3 n_out31p0 = Tiling;

// VectorOp:30
	vec3 n_out30p0 = n_out29p0 * n_out31p0;

// VectorUniform:28
	vec3 n_out28p0 = Offset;

// TilingAndOffsetUV:27
	vec3 n_out27p0;
	{
		n_out27p0 = vec3(ti1ingN0ffsetFunc(n_out30p0.xy, n_out28p0.xy), 0);
	}

// Texture:11
	vec3 texture_rgb;
	float texture_alpha;
	{
		vec4 Ice_Texture_tex_read = texture(Ice_Texture, n_out27p0.xy);
		texture_rgb = Ice_Texture_tex_read.rgb;
		texture_alpha = Ice_Texture_tex_read.a;
	}

// Input:9
	vec3 n_out9p0 = vec3(SCREEN_UV, 0.0);

// VectorDecompose:12
	float n_out12p0 = texture_rgb.x;
	float n_out12p1 = texture_rgb.y;
	float n_out12p2 = texture_rgb.z;

// ScalarOp:10
	float n_out10p0 = dot(n_out9p0, vec3(0.333333, 0.333333, 0.333333)) * n_out12p0;

// ScalarOp:17
	float n_out17p0 = dot(n_out9p0, vec3(0.333333, 0.333333, 0.333333)) + n_out10p0;

// VectorOp:13
	vec3 n_out13p0 = n_out9p0 - vec3(n_out17p0);

// ScalarUniform:16
	float n_out16p0 = RefractionAmount;

// VectorOp:14
	vec3 n_out14p0 = n_out13p0 * vec3(n_out16p0);

// VectorOp:15
	vec3 n_out15p0 = n_out14p0 + n_out9p0;

// Input:7

// Texture:8
	vec3 n_out8p0;
	float n_out8p1;
	{
		vec4 SCREEN_TEXTURE_tex_read = texture(SCREEN_TEXTURE, n_out15p0.xy);
		n_out8p0 = SCREEN_TEXTURE_tex_read.rgb;
		n_out8p1 = SCREEN_TEXTURE_tex_read.a;
	}

// VectorOp:20
	vec3 n_out20p0 = texture_rgb + n_out8p0;

// VectorOp:21
	vec3 n_out21p0 = color_rgb * n_out20p0;

// VectorOp:26
	vec3 albedo = n_out25p0 + n_out21p0;

// ScalarUniform:2
	float metallic = Metallic;

// ScalarUniform:3
	float specular = Smoothness;

// ScalarUniform:4
	float n_out4p0 = Normals;

// ReadNormalMap:18
	vec3 normal;
	{
		normal = read_normalmap(texture_rgb, vec3(n_out4p0), TANGENT, BINORMAL, NORMALMAP_DEPTH);
	}

// Output:0

	ALBEDO = albedo;
	ALPHA = color_alpha;
	METALLIC = metallic;
	SPECULAR = specular;
	NORMAL = normal;

}

void light() {
// Output:0

}