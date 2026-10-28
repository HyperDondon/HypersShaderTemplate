#version 330

#moj_import <multi_fog.glsl>

uniform sampler2D Sampler0;

in vec4 vertexColor;
in vec2 texCoord0;
in vec3 vertexPosition;
in vec4 baseColor;

out vec4 fragColor;

#moj_import <utils.glsl>
#moj_import <dithering.glsl>
#moj_import <effects/model.glsl>
#moj_import <legacy-imports/model.glsl>
#moj_import <depth.glsl>

void main() {
    vec2 screenPosNormalized = gl_FragCoord.xy / ScreenSize;
    vec3 worldDirection = normalize(vertexPosition);
    writeDepth();

    #moj_import <configs/model.glsl>

    vec4 color = texture(Sampler0, texCoord0);
    if (color.a < 0.1) {
        discard;
    }

    color *= vertexColor * ColorModulator;
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}