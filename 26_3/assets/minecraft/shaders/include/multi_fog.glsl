vec4 applyFog(vec4 inColor,float modifier) {
    #ifdef OIT_ALPHA_ONLY
    // vertex distances aren't passed in the alpha-only pass, and only alpha is used there
    return inColor;
    #else
    return apply_fog(inColor, sphericalVertexDistance * modifier, cylindricalVertexDistance * modifier, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
    #endif
}