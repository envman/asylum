shader_type spatial;
uniform float strength;
uniform bool target;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	if (target) {
		ALBEDO = vec3(1.0, 0.0, 0.0);
	} else {
		ALBEDO = vec3(1.0, 1.0, 1.0);	
	}
	
	ALPHA = strength;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
