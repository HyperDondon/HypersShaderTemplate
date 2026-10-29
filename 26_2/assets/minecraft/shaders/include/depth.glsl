void writeDepth(float depth) {
    gl_FragDepth = 1 - depth;
}

void setupDepth() {
    writeDepth(1 - gl_FragCoord.z);
}