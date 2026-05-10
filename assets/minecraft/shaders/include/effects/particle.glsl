#define PARTICLE_SHADER(a) if(isTextureAlpha(255 - a))

///////////////////////
// GENERAL FUNCTIONS //
///////////////////////

bool isTextureAlpha(float valueToExpect) {
	bool alphaConfiemd = false;

	float epsilon = 0.001;
    float colorValue = texture(Sampler0, texCoord0*0.9999999 + vec2(0.00000005)).a * 255.;
	if(distance(colorValue,valueToExpect) < epsilon) {
		alphaConfiemd = true;
	}

	return alphaConfiemd;
}

//credit: dragoncraft: https://github.com/Dragoncraft000/SkyboxTemplate/blob/master/assets/minecraft/shaders/include/skyboxes/animation.glsl
vec4 simpleNoise(vec3 worldDirection, vec3 color1, vec3 color2, float scaling, float speed) {
    vec4 fragColor = vec4(0.);
    float time = GameTime * speed;
    vec3 pos = worldDirection += vec3(time) * 99999999999.;

    fragColor.a = 1;

    // Get a smooth noise value from the direction
    vec3 offset = vec3(1.);
    offset *= time;


    // more advanced example, uncomment to try
    float noiseValue = noise(pos * scaling + noise(pos * scaling * 2 - noise(pos * scaling * -0.5 + time * -1000) * 5 + time * -500) * 0.5 + time * 500);

    //Interpolate between the two colors based on the noise output and save the result as the output
    fragColor.rgb = mix(color1, color2, noiseValue);

    // Reapply fog to no mess up underwater visuals
    // Modify Vertex Distance to account for very large model sizes (it should no fade out outside of water)
    fragColor = applyFog(fragColor, 0.25);

    return fragColor;
}
