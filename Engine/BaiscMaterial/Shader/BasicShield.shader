shader_type spatial;
render_mode depth_draw_alpha_prepass, specular_schlick_ggx, unshaded;

uniform float alpha = .5;
uniform vec4 tint : hint_color = vec4(1.);
uniform float pivot_angle = 1.5708;
uniform vec2 uv_scale = vec2(100.);
uniform float timescale = 1.0;
uniform float numRings = 20.;
uniform vec2 center = vec2(0.5);
uniform float slow = 30.;
uniform float cycleDur = 1.;
uniform float tunnelElongation = .25;

float variation(vec2 v1, vec2 v2, float strength, float speed, float iTime) {
	return sin(
        dot(normalize(v1), normalize(v2)) * strength + iTime
    ) / 100.;
}

vec3 paintCircle (vec2 uv, float rad, float width, float index, float iTime) {
    vec2 diff = center-uv;
    float len = length(diff);
    float scale = rad;
	float mult = mod(index, 2.) == 0. ? 1. : -1.; 
    len += variation(diff, vec2(rad*mult, 1.0), 7.0*scale, 2.0, iTime);
    len -= variation(diff, vec2(1.0, rad*mult), 7.0*scale, 2.0, iTime);
    float circle = smoothstep((rad-width)*scale, (rad)*scale, len) - smoothstep((rad)*scale, (rad+width)*scale, len);
    return vec3(circle);
}

vec3 paintRing(vec2 uv, float radius, float index, float iTime){
     //paint color circle
    vec3 color = paintCircle(uv, radius, 0.075, index, iTime);
    //this is where the blue color is applied - change for different mood
    color *= vec3(0.3,0.85,1.0);
    //paint white circle
    color += paintCircle(uv, radius, 0.015, index, iTime);
    return color;
}


void fragment() {
	vec3 fragColor = ALBEDO;
	vec2 fragCoord = UV * uv_scale;
	vec2 iResolution = VIEWPORT_SIZE;
	float iTime = TIME * timescale;
	
	float spacing = 1. / numRings;
	
    //define our primary 'variables'
	vec2 uv = fragCoord.xy / 400.0;
    float radius = mod(iTime / slow, cycleDur);
    vec3 color;

    //this provides the smooth fade black border, which we will mix in later
    float border = 0.25;
    vec2 bl = smoothstep(0., border, uv); // bottom left
    vec2 tr = smoothstep(0., border, 1.-uv); // top right
    float edges = bl.x * bl.y * tr.x * tr.y;

    //push in the left and right sides to make the warp square
    uv.x *= 1.5;
    uv.x -= 0.25; 
    
    //do the work
    for(float i=0.; i<numRings; i++){
   		color += paintRing(uv, tunnelElongation*log(mod(radius + i * spacing, cycleDur)), i, iTime); //these are the fast circles
        color += paintRing(uv, log(mod(radius + i * spacing, cycleDur)), i, iTime); //these are essentially the same but move at a slower pace
    }

    //combined, these create a black fade around the edges of our screen
    color = mix(color, vec3(0.), 1.-edges); 
    color = mix(color, vec3(0.), distance(uv, center));
    //boom!
	ALBEDO = color * tint.rgb;
	ALPHA = color.r * alpha;
}

void vertex() {
	mat2 rotation_matrix = mat2(vec2(cos(pivot_angle), -sin(pivot_angle)), vec2(sin(pivot_angle), cos(pivot_angle)));
	VERTEX.xz = rotation_matrix * VERTEX.xz;

	NORMAL = VERTEX.xyz;

	MODELVIEW_MATRIX = INV_CAMERA_MATRIX * mat4(CAMERA_MATRIX[0],CAMERA_MATRIX[1],CAMERA_MATRIX[2],WORLD_MATRIX[3]);
}