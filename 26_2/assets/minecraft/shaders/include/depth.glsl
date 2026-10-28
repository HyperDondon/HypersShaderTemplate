void setDepth(float depth) {
    gl_FragDepth = 1 - depth;
}

void writeDepth() {
    setDepth(1 - gl_FragCoord.z);
}