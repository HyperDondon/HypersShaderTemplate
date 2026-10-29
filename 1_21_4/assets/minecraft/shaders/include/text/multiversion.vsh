out float vertexDistance;

void onMain() {
    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
}

void isTextShadow() {
	is3D = 0.0;
	float comparatorIsShadow = 0.02;
	if(Position.z > 2400 && Position.z < 2400.05) comparatorIsShadow = 0.05;

    floatIsShadow = fract(Position.z) < comparatorIsShadow ? 1.0 : 0.0;

    if(Position.z == 0.0 && (floatIsShadow > 0.5)) floatIsShadow = 0.0;
	if(ProjMat[3][3] == 0.0) floatIsShadow = 0.0; is3D = 1.0;
}
