vec4 applyFog(vec4 inColor,float modifier) {
    return apply_fog(inColor, sphericalVertexDistance * modifier, cylindricalVertexDistance * modifier, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}