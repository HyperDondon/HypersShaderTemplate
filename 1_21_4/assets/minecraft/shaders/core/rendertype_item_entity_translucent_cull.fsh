#version 150

uniform sampler2D Sampler0;

in float vertexDistance;
#moj_import <fog.glsl>
in vec4 vertexColor;
in vec2 texCoord0;
in vec2 texCoord1;
in vec3 vertexPosition;
in vec4 baseColor;

out vec4 fragColor;

#moj_import <utils.glsl>
#moj_import <dithering.glsl>
#moj_import <effects/model.glsl>
#moj_import <legacy-imports/model.glsl>

void main() {
    vec2 screenPosNormalized = gl_FragCoord.xy / ScreenSize;
    vec3 worldDirection = normalize(vertexPosition);
    gl_FragDepth = gl_FragCoord.z;

    #moj_import <configs/model.glsl>

    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    if (color.a < 0.1) {
        discard;
    }
    fragColor = applyFog(color, 1);
}