shader_type canvas_item;

uniform sampler2D gradient;
uniform float gradient_transparency : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 pixelColor = texture(TEXTURE, UV);
    vec4 gradientColor = texture(gradient, UV);

    // Calculate the final alpha channel
    float final_alpha = pixelColor.a * (1.0 - gradient_transparency);

    // Adjust the alpha of the gradientColor while preserving the color
    gradientColor.a *= gradient_transparency;

    // Mix pixelColor and gradientColor without modifying pixelColor's alpha
    COLOR.rgb = mix(pixelColor.rgb, gradientColor.rgb, gradient_transparency);
    COLOR.a = final_alpha;
}