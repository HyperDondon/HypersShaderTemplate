////////////////
// MATH UTILS //
////////////////

#define PI 3.14159265359
#define TAU 6.28318530718
#define PHI 1.61803398875
#define E 2.71828182846
#define SQRT_2 1.41421356237
#define SQRT_3 1.73205080757
#define RAD_DEG = 57.2957795
#define DEG_RAD = 0.01745329

/////////////////
// COLOR UTILS //
/////////////////

vec4 HeatMapColor(float value, float minValue, float maxValue)
{
    vec4[] colors = vec4[](
        vec4(0.32, 0.00, 0.32, 1.00),
        vec4(0.00, 0.00, 1.00, 1.00),
        vec4(0.00, 1.00, 0.00, 1.00),
        vec4(1.00, 1.00, 0.00, 1.00),
        vec4(1.00, 0.60, 0.00, 1.00),
        vec4(1.00, 0.00, 0.00, 1.00)
    );
    float diff = (maxValue - minValue);
    value = mod(value,diff);
    float ratio= max(5. * (value / (maxValue - minValue)),0);
    int indexMin = int(max(floor(ratio),0));
    int indexMax= int(min(indexMin + 1,5));
    return mix(colors[indexMin], colors[indexMax], ratio - indexMin);
}

vec3 hsvToRgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec3 rgbToHsv(vec3 c)
{
    vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
    vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
    vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));

    float d = q.x - min(q.w, q.y);
    float e = 1.0e-10;
    return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec4 rgba(int r, int g, int b, int a) {
    return vec4(r / 255.0, g / 255.0, b / 255.0, a / 255.0);
}

vec3 rgb(int r, int g, int b) {
    return vec3(r / 255.0, g / 255.0, b / 255.0);
}

vec3 hsv(int h, int s, int v) {
    vec3 c = vec3(h / 360.0, s / 100.0, v / 100.0);
    return hsvToRgb(c);
}

//////////////////////////
// RANDOM / NOISE UTILS //
//////////////////////////

float random(vec3 seed) {
    return fract(sin(dot(seed, vec3(12.9898,78.233,85.1472))) * 43758.5453);
}

float random(vec2 seed) {
    return fract(sin(dot(seed, vec2(12.9898,78.233))) * 43758.5453);
}

float random(float seed) {
    return fract(sin(seed) * 43758.5453);
}

float noise(float n) {
    float i = floor(n);
    float f = fract(n);
    return mix(random(i), random(i + 1.0), smoothstep(0.0, 1.0, f));
}

float noise(vec2 p){
	vec2 ip = floor(p);
	vec2 u = fract(p);
	u = u*u*(3.0-2.0*u);
	
	float res = mix(
		mix(random(ip),random(ip+vec2(1.0,0.0)),u.x),
		mix(random(ip+vec2(0.0,1.0)),random(ip+vec2(1.0,1.0)),u.x),u.y);
	return res*res;
}

float noise(vec3 p){
    vec3 ip = floor(p);
	vec3 u = fract(p);
	u = u*u*(3.0-2.0*u);
	
	float res = mix(mix(
		mix(random(ip+vec3(0.0,0.0,0.0)),random(ip+vec3(1.0,0.0,0.0)),u.x),
		mix(random(ip+vec3(0.0,1.0,0.0)),random(ip+vec3(1.0,1.0,0.0)),u.x),u.y),
        mix(
		mix(random(ip+vec3(0.0,0.0,1.0)),random(ip+vec3(1.0,0.0,1.0)),u.x),
		mix(random(ip+vec3(0.0,1.0,1.0)),random(ip+vec3(1.0,1.0,1.0)),u.x),u.y),u.z);
	return res*res;
}

vec2 voronoiNoise(vec2 point){
    vec2 baseCell = floor(point);

    float minDistToCell = 10;
    vec2 closestCell;
    for(int x=-1; x<=1; x++){
        for(int y=-1; y<=1; y++){
            vec2 cell = baseCell + vec2(x, y);
            vec2 cellPosition = cell + vec2(noise(cell.x),noise(cell.y));
            vec2 toCell = cellPosition - point;
            float distToCell = length(toCell);
            if(distToCell < minDistToCell){
                minDistToCell = distToCell;
                closestCell = cell;
            }
        }
    }
    float random = noise(closestCell);
    return vec2(minDistToCell, random);
}

vec2 voronoiNoise(vec3 point){
    vec3 baseCell = floor(point);

    //first pass to find the closest cell
    float minDistToCell = 10;
    vec3 toClosestCell;
    vec3 closestCell;
    for(int x1=-1; x1<=1; x1++){
        for(int y1=-1; y1<=1; y1++){
            for(int z1=-1; z1<=1; z1++){
                vec3 cell = baseCell + vec3(x1, y1, z1);
                vec3 cellPosition = cell + noise(cell);
                vec3 toCell = cellPosition - point;
                float distToCell = length(toCell);
                if(distToCell < minDistToCell){
                    minDistToCell = distToCell;
                    closestCell = cell;
                    toClosestCell = toCell;
                }
            }
        }
    }
    float random = noise(closestCell);
    return vec2(minDistToCell, random);
}
vec2 voronoiNoise(vec3 point,float randommult){
    vec3 baseCell = floor(point);

    //first pass to find the closest cell
    float minDistToCell = 10;
    vec3 toClosestCell;
    vec3 closestCell;
    for(int x1=-1; x1<=1; x1++){
        for(int y1=-1; y1<=1; y1++){
            for(int z1=-1; z1<=1; z1++){
                vec3 cell = baseCell + vec3(x1, y1, z1);
                vec3 cellPosition = cell + noise(cell * randommult) * randommult;
                vec3 toCell = cellPosition - point;
                float distToCell = length(toCell);
                if(distToCell < minDistToCell){
                    minDistToCell = distToCell;
                    closestCell = cell;
                    toClosestCell = toCell;
                }
            }
        }
    }
    float random = noise(closestCell);
    return vec2(minDistToCell, random);
}


float map(float value, float inMin, float inMax, float outMin, float outMax) {
  return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

vec2 map(vec2 value, vec2 inMin, vec2 inMax, vec2 outMin, vec2 outMax) {
  return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

vec3 map(vec3 value, vec3 inMin, vec3 inMax, vec3 outMin, vec3 outMax) {
  return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

vec4 map(vec4 value, vec4 inMin, vec4 inMax, vec4 outMin, vec4 outMax) {
  return outMin + (outMax - outMin) * (value - inMin) / (inMax - inMin);
}

float blend(float bg,float fg) {
    return bg < 0.5 ? (2.0 * bg * fg) : (1.0 - 2.0 * (1.0 - bg) * (1.0 - fg));
}
vec2 blend(vec2 bg,vec2 fg) {
    return vec2(blend(bg.r,fg.r),blend(bg.g,fg.g));
}
vec3 blend(vec3 bg,vec3 fg) {
    return vec3(blend(bg.r,fg.r),blend(bg.g,fg.g),blend(bg.b,fg.b));
}
vec4 blend(vec4 bg,vec4 fg) {
    return vec4(blend(bg.r,fg.r),blend(bg.g,fg.g),blend(bg.b,fg.b),blend(bg.a,fg.a));
}

vec4 gradient(vec4[2] colors, float time)
{
    return mix(colors[0],colors[1],time);
}
vec4 gradient(vec4[3] colors, float time)
{
    int amount = 3;
    int identifier = int(floor(time * amount));
    vec4 baseColor = colors[identifier];
    vec4 nextColor = colors[clamp(identifier + 1,0,amount -1)];
    float identifierFract = fract(time * amount);
    return mix(nextColor,baseColor,1- identifierFract);
}

vec4 gradient(vec4[4] colors, float time)
{
    int amount = 4;
    int identifier = int(floor(time * amount));
    vec4 baseColor = colors[identifier];
    vec4 nextColor = colors[clamp(identifier + 1,0,amount -1)];
    float identifierFract = fract(time * amount);
    return mix(nextColor,baseColor,1- identifierFract);
}

vec4 gradient(vec4[5] colors, float time)
{
    int amount = 5;
    int identifier = int(floor(time * amount));
    vec4 baseColor = colors[identifier];
    vec4 nextColor = colors[clamp(identifier + 1,0,amount -1)];
    float identifierFract = fract(time * amount);
    return mix(nextColor,baseColor,1- identifierFract);
}

vec4 gradient(vec4[6] colors, float time)
{
    int amount = 6;
    int identifier = int(floor(time * amount));
    vec4 baseColor = colors[identifier];
    vec4 nextColor = colors[clamp(identifier + 1,0,amount -1)];
    float identifierFract = fract(time * amount);
    return mix(nextColor,baseColor,1- identifierFract);
}



vec3 gradient(vec3[2] colors, float time)
{
    return mix(colors[0],colors[1],time);
}
vec3 gradient(vec3[3] colors, float time)
{
    int amount = 3;
    int identifier = int(floor(time * amount));
    vec3 baseColor = colors[identifier];
    vec3 nextColor = colors[clamp(identifier + 1,0,amount -1)];
    float identifierFract = fract(time * amount);
    return mix(nextColor,baseColor,1- identifierFract);
}
vec3 gradient(vec3[4] colors, float time)
{
    int amount = 4;
    int identifier = int(floor(time * amount));
    vec3 baseColor = colors[identifier];
    vec3 nextColor = colors[clamp(identifier + 1,0,amount -1)];
    float identifierFract = fract(time * amount);
    return mix(nextColor,baseColor,1- identifierFract);
}
vec3 gradient(vec3[5] colors, float time)
{
    int amount = 5;
    int identifier = int(floor(time * amount));
    vec3 baseColor = colors[identifier];
    vec3 nextColor = colors[clamp(identifier + 1,0,amount -1)];
    float identifierFract = fract(time * amount);
    return mix(nextColor,baseColor,1- identifierFract);
}
vec3 gradient(vec3[6] colors, float time)
{
    int amount = 6;
    int identifier = int(floor(time * amount));
    vec3 baseColor = colors[identifier];
    vec3 nextColor = colors[clamp(identifier + 1,0,amount -1)];
    float identifierFract = fract(time * amount);
    return mix(nextColor,baseColor,1- identifierFract);
}