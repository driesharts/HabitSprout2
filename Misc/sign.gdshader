shader_type canvas_item;

uniform sampler2D gradient;
uniform float alpha_threshold : hint_range(0.0, 1.0) = 0.1;
uniform float transparency_factor : hint_range(0.0, 0.5) = 0.5;

void fragment() {
	vec4 pixelColor = texture(TEXTURE, UV);
	vec4 gradientColor = texture(gradient, UV);
	if (COLOR.a < alpha_threshold) 
		discard;
	gradientColor.a *= transparency_factor;
	COLOR.rgb = mix(pixelColor.rgb, gradientColor.rgb, gradientColor.a);
    COLOR.a = pixelColor.a;
}