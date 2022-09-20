#version 300 es

precision highp float;

uniform vec4 u_Color;
uniform float u_Warmth;

in vec4 fs_Nor;
in vec4 fs_LightVec;
in vec4 fs_Col;
in float fs_Noise;
in float fs_Time;

out vec4 out_Col;

float noise3D( vec3 p ) {
    return fract(sin((dot(p, vec3(127.1, 311.7, 191.999)))) * 43758.5453);
}

// Generic 3d noise
float interpNoise3D(vec3 p){
    int intX = int(floor(p.x));
    float fractX = fract(p.x);
    int intY = int(floor(p.y));
    float fractY = fract(p.y);
    int intZ = int(floor(p.z));
    float fractZ = fract(p.z);

    float v1 = noise3D(vec3(intX, intY, intZ));
    float v2 = noise3D(vec3(intX + 1, intY, intZ));
    float v3 = noise3D(vec3(intX, intY + 1, intZ));
    float v4 = noise3D(vec3(intX + 1, intY + 1, intZ));
    float v5 = noise3D(vec3(intX, intY, intZ + 1));
    float v6 = noise3D(vec3(intX + 1, intY, intZ + 1));
    float v7 = noise3D(vec3(intX, intY + 1, intZ + 1));
    float v8 = noise3D(vec3(intX + 1, intY + 1, intZ + 1));

    float i1 = mix(v1, v2, fractX);
    float i2 = mix(v3, v4, fractX);
    float i3 = mix(v5, v6, fractX);
    float i4 = mix(v7, v8, fractX);

    float j1 = mix(i1, i2, fractY);
    float j2 = mix(i3, i4, fractY);

    return mix(j1, j2, fractZ);
}

// FBM noise
#define NUM_OCTAVES 8
float fbm(vec3 x) {
	float v = 0.0;
	float a = 0.5;
	for (int i = 0; i < NUM_OCTAVES; ++i) {
		v += a * interpNoise3D(x);
		x = x * 2.0;
		a *= 0.5;
	}
	return v;
}

float cubicPulse(float c, float w, float x) {
    x = abs(x - c);
    if (x > w) {
        return 0.0;
    }
    x /= w;
    return 1.0 - x * x * (3.0 - 2.0 * x);
}

#define White vec4(1.0, 1.0, 1.0, 1.0)
#define Yellow vec4(1.0, 0.8, 0.2, 1.0)
#define Red vec4(1.0, 0.03, 0.0, 1.0)
#define Black vec4(0.05, 0.02, 0.02, 1.0)
#define LightBlue vec4(0.5, 0.9, 1.0, 1.0)
#define DarkBlue vec4(0.0, 0.2, 0.7, 1.0)

vec4 colorize (float n) {
    vec4 color1 = mix(LightBlue, White, u_Warmth);
    vec4 color2 = mix(White, Yellow, u_Warmth);
    vec4 color3 = mix(DarkBlue, Red, u_Warmth);

    float c1 = clamp(n * 4.0 + 0.5, 0.0, 1.0);
    float c2 = clamp(n * 4.0, 0.0, 1.0);
    float c3 = clamp(n * 2.4 - 0.5, 0.0, 1.0);

    vec4 a = mix(color1, color2, c1);
    vec4 b = mix(a, color3, c2);
    return mix(b, Black, c3);
}

void main()
{
    vec4 fireColor = (colorize(fs_Noise));
    float pulse = clamp((1.0, 0.2, mod(fs_Time * 0.01, 2.0)), 0.9, 1.5);
    out_Col = fireColor * pulse;
}