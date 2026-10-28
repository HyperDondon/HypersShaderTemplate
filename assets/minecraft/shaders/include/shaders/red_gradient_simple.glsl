//credit: dragoncraft: https://github.com/Dragoncraft000/SkyboxTemplate/blob/master/assets/minecraft/shaders/include/skyboxes/animation.glsl
vec4 gradientRedSimpleShaderImage(vec3 worldDirection) {
    vec4 fragColor = vec4(0.);

    fragColor.a = 1;

    // Define two colors to use
    
    vec3 color1 = rgb(50, 6, 5);
    vec3 color2 = rgb(183, 0, 0);

    // Get a smooth noise value from the direction
    float scaling = 35;
    vec3 offset = GameTime * vec3(0,0,0);
    //offset *= 120.;
    float noiseValue = noise(worldDirection * scaling + offset);


    // more advanced example, uncomment to try
    noiseValue = noise(worldDirection * scaling + noise(worldDirection * scaling * 2 - noise(worldDirection * scaling * -0.5 + GameTime * -1000) * 5 + GameTime * -500) * 0.5 + GameTime * 500);


    //Interpolate between the two colors based on the noise output and save the result as the output
    fragColor.rgb = mix(color1,color2,noiseValue);

    // Reapply fog to no mess up underwater visuals
    // Modify Vertex Distance to account for very large model sizes (it should no fade out outside of water)
    fragColor = applyFog(fragColor,0.25);

    return fragColor;
}

