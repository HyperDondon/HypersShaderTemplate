#version 150

in vec3 Position;
in vec2 UV0;
in vec4 Color;
in ivec2 UV2;

uniform sampler2D Sampler2;

#moj_import <multi/vertex.glsl>
#moj_import <multi/lightmap.glsl>

out vec2 texCoord0;
out vec4 vertexColor;
out vec3 vertexPosition;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    writeFogDistance();
    texCoord0 = UV0;
    vertexColor = Color * sampleLightmap(Sampler2, UV2);
    vertexPosition = Position;
}
