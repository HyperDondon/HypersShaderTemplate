#version 330

uniform sampler2D Sampler0;

#moj_import <multi/fog.glsl>
in vec4 vertexColor;
in vec4 lightMapColor;
in vec4 overlayColor;
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
    setupDepth();

    #moj_import <configs/model.glsl>

    vec4 color = texture(Sampler0, texCoord0);
    if (color.a < 0.1) {
        discard;
    }

    color *= vertexColor * ColorModulator;
    color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
    color *= lightMapColor;

    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}