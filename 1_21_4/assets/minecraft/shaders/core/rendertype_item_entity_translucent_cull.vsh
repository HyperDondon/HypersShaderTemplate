#version 150

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in vec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;

#moj_import <multi/vertex.glsl>
#moj_import <multi/light.glsl>
#moj_import <multi/lightmap.glsl>

out vec4 vertexColor;
out vec2 texCoord0;
out vec2 texCoord1;
out vec2 texCoord2;
out vec3 vertexPosition;
out vec4 baseColor;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    writeFogDistance();
    vertexPosition = Position;
    baseColor = Color;
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color) * sampleLightmap(Sampler2, UV2);
    texCoord0 = UV0;
    texCoord1 = UV1;
    texCoord2 = UV2;
}
