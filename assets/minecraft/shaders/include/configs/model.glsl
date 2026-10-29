/*
MODEL_SHADER(1) {
    fragColor = vec4(1., 0., 0., 1.);
    return;
}
*/
MODEL_SHADER(1) {
    fragColor = gradientRedSimpleShaderImage(worldDirection);
    return;
}

MODEL_SHADER(2) {
    fragColor = gradientSimpleShaderImage(worldDirection);
    return;
}

MODEL_SHADER(3) {
    fragColor = trippyShaderImage(worldDirection, GameTime, ScreenSize / 1000.);
    return;
}