uniform sampler2D Sampler1;

vec4 sampleOverlay() {
    return texelFetch(Sampler1, UV1, 0);
}
