TEXT_EFFECT(255, 1, 0) {
    if (!text.isShadow) {
        vec3 color1 = rgb(176, 9, 9);
        vec3 color2 = rgb(95, 25, 25);
        text.color = vec4(mix(color1, color2, sin(GameTime * 2500.)), 1.0);
    }
}