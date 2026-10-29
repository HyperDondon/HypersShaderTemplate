#version 330
#extension GL_ARB_separate_shader_objects : require

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
#include <minecraft:fog.glsl>
#endif

#include <minecraft:globals.glsl>
#include <minecraft:dynamictransforms.glsl>
#include <minecraft:oit.glsl>

uniform sampler2D Sampler0;

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
layout(location = 0) in float sphericalVertexDistance;
layout(location = 1) in float cylindricalVertexDistance;
#endif

layout(location = 2) in vec4 vertexColor;
layout(location = 3) in vec2 texCoord0;

layout(location = 4) in vec3 glCornerTex1;
layout(location = 5) in vec3 glCornerTex2;
layout(location = 6) in vec3 glCornerTex3;
layout(location = 7) in vec3 glCornerTex4;

layout(location = 8) in vec3 uvCornerTex1;
layout(location = 9) in vec3 uvCornerTex2;
layout(location = 10) in vec3 uvCornerTex3;
layout(location = 11) in vec3 uvCornerTex4;

layout(location = 12) in vec4 sPos;
layout(location = 13) in float is3D;
layout(location = 14) in float fontID;
layout(location = 15) in float floatIsShadow;
layout(location = 16) in vec4 baseColor;
layout(location = 17) in float isMap;

#ifndef OIT_ALPHA_ONLY
layout(location = 0) out vec4 fragColor;
#endif

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

vec4 calculateFinalColor(vec4 color) {
    #ifdef OIT_ACCUMULATE
    color = sampleColorForAccumulation(color);
    #endif

    #if !defined(IS_SEE_THROUGH) && !defined(IS_GUI)

    #ifdef OIT_ACCUMULATE
    vec4 fogColor = vec4(FogColor.rgb * color.a, FogColor.a);
    #else
    vec4 fogColor = FogColor;
    #endif

    color = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, fogColor);
    #endif

    return color;
}

void main() {
	text.isShadow = floatIsShadow > 0.5;
	text.id = fontID;

	text.color = baseColor;
    text.alphaRead = baseColor.a;

	vec2 glCornerUV1 = glCornerTex1.xy / glCornerTex1.z;
	vec2 glCornerUV2 = glCornerTex2.xy / glCornerTex2.z;
	vec2 glCornerUV3 = glCornerTex3.xy / glCornerTex3.z;
	vec2 glCornerUV4 = glCornerTex4.xy / glCornerTex4.z;

	vec2 uvCornerUV1 = uvCornerTex1.xy / uvCornerTex1.z;
	vec2 uvCornerUV2 = uvCornerTex2.xy / uvCornerTex2.z;
	vec2 uvCornerUV3 = uvCornerTex3.xy / uvCornerTex3.z;
	vec2 uvCornerUV4 = uvCornerTex4.xy / uvCornerTex4.z;

    vec2 glMin = min(glCornerUV1,min(glCornerUV2,min(glCornerUV3,glCornerUV4)));
	vec2 glMax = max(glCornerUV1,max(glCornerUV2,max(glCornerUV3,glCornerUV4)));
	vec2 glSize = glMax - glMin;

	vec2 uvMin = min(uvCornerUV1,min(uvCornerUV2,min(uvCornerUV3,uvCornerUV4)));
	vec2 uvMax = max(uvCornerUV1,max(uvCornerUV2,max(uvCornerUV3,uvCornerUV4)));
	vec2 uvSize = uvMax - uvMin;

	text.uvMin = uvMin;
	text.uvMax = uvMax;
	text.uvCenter = uvMin + 0.25 * uvSize;

    text.localPos = ((sPos.xy - glMin) / glSize);
	text.localPos.y = 1.0 - text.localPos.y;

	text.pos = sPos.xy * 256.0;
	text.uv = texCoord0;

	text.charPos = 0.5 * (glMin + glMax) * uvSize * 256.0 / glSize;

	text.pixelPos = ivec2(int(floor((text.uv.yx + 0.00004 - text.uvMin.yx) * 256.0)));

#include <configs/text.glsl>
#include <configs/font.glsl>

    #ifdef IS_GRAYSCALE
    vec4 textureSample = texture(Sampler0, text.uv).rrrr;
    #else
    vec4 textureSample = texture(Sampler0, text.uv);
    #endif

    vec4 color = textureSample * text.color * ColorModulator * vertexColor;

    if(isMap > 0.5) color = texture(Sampler0, texCoord0) * baseColor * vertexColor * ColorModulator;
    if(color.a < 1 / 255.) discard;

    #ifdef OIT_ALPHA_ONLY
    executeAlphaOnlyPhase(gl_FragCoord.z, color.a);
    #else
    fragColor = calculateFinalColor(color);
    #endif
}
