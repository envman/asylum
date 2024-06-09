shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

uniform vec4 color_1 = vec4(.0, .0, .0, 1.0);
uniform vec4 color_2 = vec4(0.5, 0.5, 0.5, 1.0);
uniform vec4 color_3 = vec4(0.71, 0.757 ,0.557 , 1.0);
uniform vec4 color_4 = vec4(0.969,0.863,0.725, 1.0);
uniform vec4 color_5 = vec4(0.871,0.675,0.502, 1.0);
uniform vec4 color_6 = vec4(0.725,0.58,0.439, 1.0);
uniform vec4 color_7 = vec4(0.004,0.125,0.306, 1.0);
uniform vec4 color_8 = vec4(0.008,0.514,0.569, 1.0);
uniform vec4 color_9 = vec4(0.965,0.863,0.675, 1.0);
uniform vec4 color_10 = vec4(0.996,0.682,0.435, 1.0);
uniform vec4 color_11 = vec4(0.945,0.945,0.945, 1.0);
uniform vec4 color_12 = vec4(1.,0.957,0.333, 1.0);
uniform vec4 color_13 = vec4(0.706,0.706,0.722, 1.0);
uniform vec4 color_14 = vec4(0.78,0.784,0.8, 1.0);
uniform vec4 color_15 = vec4(0.89,0.882,0.851, 1.0);
uniform vec4 color_16 = vec4(0.949,0.937,0.898, 1.0);

void fragment() {

	vec4 colors[16] = {
		color_1,
		color_2,
		color_3,
		color_4,
		color_5,
		color_6,
		color_7,
		color_8,
		color_9,
		color_10,
		color_11,
		color_12,
		color_13,
		color_14,
		color_15,
		color_16
	};
	float min_diff = -1.0;
	vec4 min_color = vec4(0.0, 0.0, 0.0, 1.0);

	vec2 uv = SCREEN_UV;

	vec4 temp = textureLod(SCREEN_TEXTURE, uv, 0.0);

	min_diff = 1000.0;
	for (int i = 0; i < colors.length(); i++) {

		float curr_dist = distance(colors[i], temp);
		if (curr_dist < min_diff) {
			min_diff = curr_dist;
			min_color = colors[i];
		}
	}

	COLOR.rgb = min_color.rgb;
}