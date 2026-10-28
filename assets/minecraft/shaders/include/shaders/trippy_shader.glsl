float trippyHash(vec2 p) {
    vec3 p3 = fract(vec3(p.xyx) * 0.13);
    p3 += dot(p3, p3.yzx + 3.333);
    return fract((p3.x + p3.y) * p3.z);
}

float trippyRandom(vec2 uv) {
    return fract(sin(dot(uv.xy, vec2(23.12743,34.212923)))*432781.0919); 
}

// By Morgan McGuire @morgan3d, http://graphicscodex.com
float trippyNoise(vec2 x) {
	vec2 i = floor(x);
	vec2 f = fract(x);

	// Four corners in 2D of a tile
	float a = trippyHash(i);
	float b = trippyHash(i + vec2(1.0, 0.0));
	float c = trippyHash(i + vec2(0.0, 1.0));
	float d = trippyHash(i + vec2(1.0, 1.0));

	// Simple 2D lerp using smoothstep envelope between the values.
	// return vec3(mix(mix(a, b, smoothstep(0.0, 1.0, f.x)),
	//			mix(c, d, smoothstep(0.0, 1.0, f.x)),
	//			smoothstep(0.0, 1.0, f.y)));

	// Same code, with the clamps in smoothstep and common subexpressions
	// optimized away.
	vec2 u = f * f * (3.0 - 2.0 * f);
	return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

float trippySdBox(vec2 p, vec2 b) {
    vec2 d = abs(p) - b;

    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}


float sinTime(float multiplier, float addition, float iTime) {
    return sin((iTime + addition) * multiplier);
}

float cosTime(float multiplier, float addition, float iTime) {
    return cos((iTime + addition) * multiplier);
}

float sinTime(float multiplier, float iTime) {
    return sinTime(multiplier, 0., iTime);
}

float cosTime(float multiplier, float iTime) {
    return cosTime(multiplier, 0., iTime);
}



vec4 trippyShaderImage(vec3 worldDirection, float gameTime, vec2 iResolution) {
    vec4 fragColor = vec4(0.);
    vec2 fragCoord = worldDirection.xy;
    float iTime = gameTime * 500;

    vec2 uv = (fragCoord-.5*iResolution.xy)/iResolution.y * 2;
    
    vec2 p = uv;

    float angle = atan(p.y, p.x);
    float radius = length(p);

    p = vec2(cos(angle), sin(angle)) * radius-vec2(.5);

    float distort = trippyNoise(p*5.0 + iTime);
    p += distort;

    float n = (trippyNoise(uv*10.+.4*iTime))*.1;
    
    vec2 tile = fract(p*2.);
    float rect = trippySdBox(tile, vec2(abs(.42),1.));
    float box = smoothstep(.2,0.,(rect+n) * 2.) * 10.;
    float glow = exp(-10.*rect);
    //glow = pow(0.01 / glow, glow);
    vec3 col = vec3(box);

    col += glow*
        vec3(
        (abs(sinTime(2., trippyHash(p / 2.) * trippyRandom(p / 2.), iTime)) * 7.) + 0.4,
        0.,
        0.
        );
    fragColor = vec4(col,1.0);

    // if the color is close to white, make it black
    float brightness = dot(col, vec3(0.299, 0.587, 0.114));
    if (brightness > 0.8) {
        col = vec3(0.);
        fragColor = vec4(col, 1.0);
    }

    return fragColor;
}

