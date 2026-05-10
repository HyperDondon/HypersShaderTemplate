#define TEXT_EFFECT(r, g, b) if(isTextColor(vec3(r, g, b)))

///////////////////////
// GENERAL FUNCTIONS //
///////////////////////

bool isTextColor(vec3 colorToExpect) {
	bool colorConfirmed = false;

	vec3 mainColorToExpect = colorToExpect;
	vec3 shadowColorToExpect = colorToExpect / 4;
	vec3 shadowColorToExpect3D = floor(colorToExpect / 4);

	bool isMainColor = (mainColorToExpect == text.color.rgb * int(1.0 * 255)) && !text.isShadow;
	bool isShadowColor = (shadowColorToExpect3D == text.color.rgb * int(1.0 * 255)) && text.isShadow;
	bool isShadowColor3D = (shadowColorToExpect3D == text.color.rgb * int(1.0 * 255)) && (is3D == 1.0);

	if(isShadowColor || isMainColor || isShadowColor3D) colorConfirmed = true;
	if(is3D == 1.0 && isShadowColor3D) text.isShadow = true;

	return colorConfirmed;
}

//////////////////
// TEXT EFFECTS //
//////////////////

void replace_color(vec3 color) {text.color.rgb = color;if(text.isShadow) text.color.rgb *= 0.25;}
void replaceColor(vec4 color) {text.color = vec4(color.rgb, color.a * text.color.a); if(text.isShadow) text.color.rgb *= 0.25;}

void replace_main_color(vec3 color) {if(!text.isShadow) text.color.rgb = color;}
void replace_main_color(vec4 color) {if(!text.isShadow) text.color = vec4(color.rgb, color.a * text.color.a);}

void replace_shadow_color(vec3 color) {if(text.isShadow) text.color.rgb = color;}
void replace_shadow_color(vec4 color) {if(text.isShadow) text.color = vec4(color.rgb, color.a * text.color.a);}

void rainbow(float speed,float frequency) {
	text.color.rgb = hsvToRgb(vec3(0.005 * frequency * (text.pos.x + text.pos.y) - GameTime * 300.0 * speed, 0.8, 1.0));
	
	if(text.isShadow) text.color.rgb *= 0.25;
}

void rainbow(float speed) {
    rainbow(speed,1);
}

vec4 animated_gradient(vec3 color1, vec3 color2, float speed, float frequency,float direction) {
    float rotationAngle = 0.08 * frequency * (text.pos.x * (direction * 2) + text.pos.y * (2 - direction * 2)) - GameTime * 600.0 * speed * PI;
    float t = (sin(rotationAngle) + 1.0) * 0.5;
    vec3 rainbowColor = mix(color1, color2, t);

    text.color.rgb = rainbowColor;
    if(text.isShadow) text.color.rgb *= 0.25;
    return text.color;
}

void animated_gradient(vec3 color1, vec3 color2, float speed,float frequency) {
    animated_gradient(color1,color2,speed,frequency,0.5);
}

void animated_gradient(vec3 color1, vec3 color2, float speed) {
    animated_gradient(color1,color2,speed,1,0.5);
}


void fade(vec3 color1, vec3 color2, float speed) {
    text.color.rgb = mix(color1, color2, sin(GameTime * 600.0 * speed * PI) * 0.5 + 0.5);

	if(text.isShadow) text.color.rgb *= 0.25;
}

void fade(vec4 color1, vec4 color2, float speed) {
    text.color = mix(vec4(color1.rgb, color1.a * text.color.a), vec4(color2.rgb, color2.a * text.color.a), sin(GameTime * 600.0 * speed * PI) * 0.5 + 0.5);

	if(text.isShadow) text.color.rgb *= 0.25;
}

void waving(float speed, float frequency) {
    text.uv.y += sin(text.charPos.x * 0.1 * frequency - GameTime * 7500.0 * speed) / 256.0;
}

void scrolling(float speed, float vertical,float horizontal, float phase) {
    text.uv.y += GameTime * vertical * 600 * speed + phase;
    text.uv.x += GameTime * horizontal * 600 * speed + phase;
}
void scrolling(float speed, float vertical,float horizontal) {
    scrolling(speed,vertical,horizontal,0);
}

void scrolling_masked(float speed, float vertical,float horizontal) {

    vec2 offsetUv = text.uv;
    offsetUv.y += GameTime * vertical * 600 * speed;
    offsetUv.x += GameTime * horizontal * 600 * speed;

    vec4 textureSample = texture(Sampler0, offsetUv);

    text.color = vec4(textureSample.r,textureSample.g,textureSample.b,textureSample.a * text.color.a);
}

void alpha_multiplier(float alpha) {
    text.color.a *= alpha;
}

void alpha_gradient(float alpha1,float alpha2,float speed, float frequency,float direction) {
    float rotationAngle = 0.08 * frequency * (text.pos.x * (direction * 2) + text.pos.y * (2 - direction * 2)) - GameTime * 600.0 * speed * PI;
    float t = (sin(rotationAngle) + 1.0) * 0.5;
    text.color.a = mix(alpha1 * text.color.a,alpha2 * text.color.a,t);
    if(text.isShadow) text.color.a *= 0.25;
}
float relative_center_distance() {
    vec2 screenPosNormalized = vec2(0,0);
    screenPosNormalized.x = text.pos.x / 256.;
    screenPosNormalized.y = text.pos.y / 256.;
    float dis = sqrt(pow(screenPosNormalized.x,2) + pow(screenPosNormalized.y,2));
    return dis;
}

float euclidian_center_distance(float ratio,vec2 offset) {
    vec2 screenPosNormalized = vec2(0,0);
    screenPosNormalized.x = (text.pos.x / 256.) * ScreenSize.x * ((ratio) * 2);
    screenPosNormalized.y = (text.pos.y / 256.) * ScreenSize.y * ((1 - ratio) * 2);

    if (offset.x > 0 || offset.y > 0) {
        screenPosNormalized.x += noise(screenPosNormalized.x) * offset.x;
        screenPosNormalized.y += noise(screenPosNormalized.y) * offset.y;
    }

    if (ScreenSize.y < ScreenSize.x) {
        screenPosNormalized /= ScreenSize.y;
    } else {
        screenPosNormalized /= ScreenSize.x;
    }
    float dis = sqrt(pow(screenPosNormalized.x,2) + pow(screenPosNormalized.y,2));
    return dis;
}

float euclidian_center_distance(float ratio) { 
    return euclidian_center_distance(ratio,vec2(0,0));
}

float euclidian_center_distance() {
    return euclidian_center_distance(0.5,vec2(0,0));
}

float linear_top_distance() {
    return (text.pos.y / 512.) +0.5;
}

float linear_bottom_distance() {
    return 0.5 - (text.pos.y / 512.);
}

float linear_right_distance() {
    return (text.pos.x / 512.) +0.5;
}
float linear_left_distance() {
    return 0.5 - (text.pos.x / 512.);
}

void sdf_mask(float t, float spread, float value) {
    spread = max(spread,0.0001);
    float start = t - spread / 2;
    float end = t + spread / 2;
    float transition = max(min(value,end),start);
    float alpha = map(transition,start,end,0.,1.);
    text.color.a = alpha;
}

float center_sdf(float t, float spread, float value) {
    spread = max(spread,0.0001);
    float start = t - spread / 2;
    float end = t + spread / 2;
    float transition = max(min(value,end),start);
    float alpha = map(transition,start,end,0.,1.);
    return alpha;
}


void iterating(float speed, float space) {
    float x = mod(text.charPos.x * 0.4 - GameTime * 18000.0 * speed, (5.0 * space) * TAU); if(x > TAU) x = TAU;

	text.uv.y += (-cos(x) * 0.5 + 0.5) / 256.0;
}

void metalic() {
    if(text.pixelPos.y > 3) text.color.rgb = text.color.rgb * 0.7;
    if(text.pixelPos.y == 3) text.color.rgb = text.color.rgb + 0.25;
    if(text.pixelPos.y < 3) text.color.rgb = text.color.rgb;

    if(text.isShadow) text.color.rgb *= 0.25;
}

void remove_shadow() {
	if(text.isShadow) text.color.a = 0.0;
}

vec4 noise_layer(vec3 color1, vec3 color2, float speed, float frequency,float direction,float multiplier) {
    text.color.a = 0.99 + noise(vec2((text.pos.x + frequency * 5000 +  speed * 500 * GameTime )/ 250,(text.pos.y + frequency * 5000 +  speed * 500 * GameTime )/ 250)) / 3;
    text.color.rgb = mix(color1,color2,multiplier * noise(vec2(text.pos.x * frequency / 10 + speed * (direction * 2) * GameTime * 600 ,text.pos.y * frequency / 10 + speed * (2 - direction * 2) * GameTime * 600)));
    float rotationAngle = 0.08 * frequency * (text.pos.x * (direction * 2) + text.pos.y * (2 - direction * 2)) - GameTime * 600.0 * speed * PI;
    float t = (sin(rotationAngle) + 1.0) * 0.5;
    vec3 rainbowColor = mix(color1, color2, t);
    return text.color.rgba;
}

vec2 pixelatePos(vec2 inPosition, float size) {
    return floor(inPosition / size) * size;
}

void matrix_overlay(float pixelation, float speed, float trailExponent, vec3 tint) {
    float alpha = text.color.a;
    vec2 pixelated = pixelatePos(text.pos, pixelation);
    pixelated.y = pixelated.y / 2.0 + 128.0;
    pixelated.y += random(pixelated.x) * 256.0;
    pixelated.y += GameTime * 24000.0 * speed;
    float trail = 1.0 - pow(mod(pixelated.y, 255.0), trailExponent) / 255.0;
    vec2 letterUvCoord = text.pos + 256.0;
    letterUvCoord = fract(letterUvCoord / (8.0 * pixelation));
    letterUvCoord.y = fract(letterUvCoord.y);
    vec4 letterColor = texture(Sampler0, letterUvCoord);
    float letterAlpha = trail * letterColor.a;
    vec3 coloredLetter = letterColor.rgb * tint;
    text.color = mix(vec4(0, 0, 0, 1), vec4(coloredLetter, 1), letterAlpha);
    text.color.a *= alpha;
}


void voronoiNoiseShader(vec3 col1, vec3 col2, vec3 col3, float timeMultiplier, float scaling, float maskValue) {
    float value = relative_center_distance();
    float alpha = text.color.a;
    sdf_mask(maskValue, 2, value);
    alpha *= text.color.a * 1.4;

    vec2 point = text.pos * scaling;
    float t = GameTime * timeMultiplier;

    float warp1 = noise(vec2(point.x * 0.008 + t * 0.3, point.y * 0.008 - t * 0.2));
    float warp2 = noise(vec2(point.y * 0.012 - t * 0.4, point.x * 0.012 + t * 0.1));
    float plasma1 = noise(vec2(point.x * 0.015 + warp1 * 3.0, point.y * 0.015 + warp2 * 3.0));

    float plasma2 = voronoiNoise(vec3(point.x / 60.0 + warp2 * 2.0, t * 0.5, point.y / 60.0 + warp1 * 2.0)).r;

    float intensity = pow(plasma1 * 0.6 + plasma2 * 0.7, 2.0);

    vec3 nebColor = mix(col2, col1, smoothstep(0.1, 0.5, intensity));
    nebColor = mix(nebColor, col3, smoothstep(0.4, 0.9, intensity));

    nebColor += vec3(0.4, 0.1, 0.5) * pow(intensity, 3.0);

    text.color = vec4(nebColor * intensity * 2.0, 1.0);
    text.color.a *= alpha;
}

void voronoiNoiseShader2(vec3 sculkBase, vec3 sculkTendril, vec3 sculkGlow, vec3 sensorFlash, float timeMultiplier, float scaling, float maskValue) {
    float value = relative_center_distance();
    float alpha = text.color.a;
    sdf_mask(maskValue, 2, value);
    alpha *= text.color.a * 1.4;

    vec2 point = text.pos * scaling;
    float t = GameTime * timeMultiplier;

    float warpSlow = noise(vec2(point.x * 0.006 + t * 0.15, point.y * 0.006 - t * 0.1));
    float warpFast = noise(vec2(point.y * 0.02 + t * 0.4, point.x * 0.02 - t * 0.3));
    vec2 sculkUV = vec2(point.x / 55.0 + warpSlow * 2.0, point.y / 55.0 + warpSlow * 2.0);

    float v1 = voronoiNoise(vec3(sculkUV.x, t * 0.2, sculkUV.y)).r;
    float v2 = voronoiNoise(vec3(point.x / 20.0 + warpFast * 1.5, t * 0.5 + 30.0, point.y / 20.0 + warpFast * 1.5)).r;

    float tendrils = 1.0 - smoothstep(0.0, 0.1, v1);
    float fineVeins = 1.0 - smoothstep(0.0, 0.07, v2);

    float sensorPulse = sin(v1 * 20.0 - t * 3.0) * 0.5 + 0.5;
    sensorPulse = pow(sensorPulse, 8.0) * (1.0 - smoothstep(0.0, 0.3, v1));

    float innerGlow = pow(1.0 - v1, 5.0) * 0.4;
    float innerDetail = pow(1.0 - v2, 3.0) * 0.2;

    float breathe = sin(t * 0.8) * 0.15 + 1.0;

    vec3 finalColor = sculkBase;
    finalColor += sculkTendril * (tendrils * 0.8 + fineVeins * 0.4);
    finalColor += sculkGlow * (innerGlow + innerDetail) * breathe;
    finalColor += sensorFlash * sensorPulse * 1.5;

    float grain = noise(vec2(point.x * 0.5 + t * 2.0, point.y * 0.5)) * 0.08;
    finalColor += vec3(0.0, grain * 0.5, grain);

    text.color = vec4(finalColor, 1.0);
    text.color.a *= alpha;
}