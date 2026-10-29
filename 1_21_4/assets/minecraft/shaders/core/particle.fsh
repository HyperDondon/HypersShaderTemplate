#version 150

uniform sampler2D Sampler0;

#moj_import <multi/fog.glsl>
in vec2 texCoord0;
in vec4 vertexColor;
in vec3 vertexPosition;

out vec4 fragColor;

#moj_import <utils.glsl>
#moj_import <effects/particle.glsl>
#moj_import <legacy-imports/particle.glsl>

void main() {
    vec2 screenPosNormalized = gl_FragCoord.xy / ScreenSize;
    vec3 worldDirection = normalize(vertexPosition);

    #moj_import <configs/particle.glsl>

    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
    if (color.a < 0.1) {
        discard;
    }
    fragColor = applyFog(color, 1);
}
