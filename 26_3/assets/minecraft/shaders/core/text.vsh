#version 330
#extension GL_ARB_separate_shader_objects : require

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
#include <minecraft:fog.glsl>
#include <minecraft:sample_lightmap.glsl>
#endif

#include <minecraft:globals.glsl>
#include <minecraft:dynamictransforms.glsl>
#include <minecraft:projection.glsl>

layout(location = 0) in vec3 Position;
layout(location = 1) in vec4 Color;
layout(location = 2) in vec2 UV0;
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
layout(location = 3) in ivec2 UV2;
#endif

uniform sampler2D Sampler0;

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
uniform sampler2D Sampler2;
layout(location = 0) out float sphericalVertexDistance;
layout(location = 1) out float cylindricalVertexDistance;
#endif

layout(location = 2) out vec4 vertexColor;
layout(location = 3) out vec2 texCoord0;

layout(location = 4) out vec3 glCornerTex1;
layout(location = 5) out vec3 glCornerTex2;
layout(location = 6) out vec3 glCornerTex3;
layout(location = 7) out vec3 glCornerTex4;

layout(location = 8) out vec3 uvCornerTex1;
layout(location = 9) out vec3 uvCornerTex2;
layout(location = 10) out vec3 uvCornerTex3;
layout(location = 11) out vec3 uvCornerTex4;

layout(location = 12) out vec4 sPos;
layout(location = 13) out float is3D;
layout(location = 14) out float fontID;
layout(location = 15) out float floatIsShadow;
layout(location = 16) out vec4 baseColor;
layout(location = 17) out float isMap;

struct Text {
	float id;
	vec4 glPos;
    int glVertex;

    float alphaRead;
	vec4 color;
	bool isShadow;

	vec2 uv;
	vec2 uvMin;
	vec2 uvMax;
	vec2 uvCenter;

	vec2 size;
	vec2 pos;
	vec2 localPos;
	vec2 charPos;
	ivec2 pixelPos;
};
Text text;

#include <utils.glsl>
#include <effects/text.glsl>
#include <effects/font.glsl>
#include <new-imports/text.glsl>
#include <new-imports/font.glsl>

void isTextShadow() {
	is3D = 0.0;
	float comparatorIsShadow = 0.02;
	if(Position.z > 2400 && Position.z < 2400.05) comparatorIsShadow = 0.05;

    floatIsShadow = fract(Position.z) < comparatorIsShadow ? 0.0 : 1.0;

    if(Position.z == 0.0 && (floatIsShadow > 0.5)) floatIsShadow = 0.0;
	if(ProjMat[3][3] == 0.0) floatIsShadow = 0.0; is3D = 1.0;
}

void main() {
    isTextShadow();

    vec4 pos = vec4(Position, 1.0);
    baseColor = Color;

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    vertexColor = Color * sample_lightmap(Sampler2, UV2);
#else
    vertexColor = vec4(1.0);
#endif


    text.id = floor((pos.y + 1000.0) / 5000.0);
	pos.y = mod(pos.y + 1000.0, 5000.0) - 1000.0;

    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    text.alphaRead = baseColor.a;
	text.glPos = gl_Position;
    text.glVertex = gl_VertexIndex;

    // if(Position.z == 2400.0 && gl_Position.y >= 0.0) text.id *= 0.25; // Title Shadow
	// if(Position.z == 2400.0 && gl_Position.y < 0.0) text.id *= 0.5; // Subtitle Shadow

    if(Position.z == 2400.12) text.id *= 0.25; // Title
	if(Position.z == 2400.06) text.id *= 0.5; // Subtitle
    
	isMap = 0.0;
    if(textureSize(Sampler0, 0) != ivec2(256, 256)) isMap = 1.0;

	if(isMap < 0.5) {
		glCornerTex1 = glCornerTex2 = glCornerTex3 = glCornerTex4 = uvCornerTex1 = uvCornerTex2 = uvCornerTex3 = uvCornerTex4 = vec3(0.0);
		switch (gl_VertexIndex % 4) {
			case 0: glCornerTex1 = vec3(Position.xy, 1.0); uvCornerTex1 = vec3(UV0.xy, 1.0);
			case 1: glCornerTex2 = vec3(Position.xy, 1.0); uvCornerTex2 = vec3(UV0.xy, 1.0);
			case 2: glCornerTex3 = vec3(Position.xy, 1.0); uvCornerTex3 = vec3(UV0.xy, 1.0);
			case 3: glCornerTex4 = vec3(Position.xy, 1.0); uvCornerTex4 = vec3(UV0.xy, 1.0);
		}
	}

	#include <configs/text.glsl>
	#include <configs/font.glsl>
    gl_Position = text.glPos;

	fontID = text.id;
	sPos = gl_Position;
    texCoord0 = UV0;
}
