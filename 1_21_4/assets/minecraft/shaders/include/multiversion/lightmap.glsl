vec4 sampleLightmap(sampler2D lightMap, ivec2 uv) {
    return texelFetch(lightMap, uv / 16, 0);
}
