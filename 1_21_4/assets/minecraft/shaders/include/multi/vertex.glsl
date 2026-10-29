#moj_import <minecraft:fog.glsl>

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;

out float vertexDistance;

void writeFogDistance() {
    vertexDistance = fog_distance(Position, FogShape);
}
