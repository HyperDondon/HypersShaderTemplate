void writeDepth(float depth) {
    gl_FragDepth = depth;
}

void setupDepth() {
    writeDepth(gl_FragCoord.z);
}