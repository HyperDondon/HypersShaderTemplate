// sample_lightmap function copied
// see https://mcasset.cloud/26.1/assets/minecraft/shaders/include/sample_lightmap.glsl
vec4 sampleLightmap(sampler2D lightMap, ivec2 uv) {
    return texture(lightMap, clamp((uv / 256.0) + 0.5 / 16.0, vec2(0.5 / 16.0), vec2(15.5 / 16.0)));
}
