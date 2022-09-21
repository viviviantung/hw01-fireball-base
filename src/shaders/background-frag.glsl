#version 300 es

#ifdef GL_ES
precision mediump float;
#endif

uniform int u_Time;

in vec2 fs_UV;

out vec4 out_Col;

// worley noise
vec2 random(vec2 uv) {
	return vec2(fract(sin(dot(uv.xy,
		vec2(12.9898,78.233))) * 43758.5453123));
}

float worley(vec2 uv, float columns, float rows) {
	
	vec2 index_uv = floor(vec2(uv.x * columns, uv.y * rows));
	vec2 fract_uv = fract(vec2(uv.x * columns, uv.y * rows));
	
	float minimum_dist = 1.0;  
	
	for (int y= -1; y <= 1; y++) {
		for (int x= -1; x <= 1; x++) {
			vec2 neighbor = vec2(float(x),float(y));
			vec2 point = random(index_uv + neighbor);
            float speed = 0.1;
            point = vec2( cos(float(u_Time) * point.x * speed), sin(float(u_Time) * point.y * speed) ) * 0.5 + 0.5;
			
			vec2 diff = neighbor + point - fract_uv;
			float dist = length(diff);
			minimum_dist = min(minimum_dist, dist);
		}
	}
	
	return minimum_dist;
}

void main() {
    vec4 blue = vec4(0.1, 0.8, 1.0, 1.0);
    float blueBubbles = worley(fs_UV, 10.0, 10.0);
    float whiteRips = worley(fs_UV, 13.0, 13.0);
    if (whiteRips > 0.8) {
        out_Col = vec4(1.0);
    } else {
        out_Col = vec4(vec3(1.0 - blueBubbles), 1.0) * 0.6 + (blue * 0.5);
    }
}