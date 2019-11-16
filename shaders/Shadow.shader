shader_type canvas_item;
render_mode blend_mix;

// example shader from: https://github.com/godotengine/godot-demo-projects

uniform float radius = 5.0;
uniform vec4  modulate : hint_color;

void fragment() {
	vec2 ps = TEXTURE_PIXEL_SIZE;

	vec4 shadow = texture(TEXTURE, UV + vec2(-radius, -radius) * ps);

	shadow += texture(TEXTURE, UV + vec2(-radius, 0.0) * ps);
	shadow += texture(TEXTURE, UV + vec2(-radius, radius) * ps);
	shadow += texture(TEXTURE, UV + vec2(0.0, -radius) * ps);
	shadow += texture(TEXTURE, UV + vec2(0.0, radius) * ps);
	shadow += texture(TEXTURE, UV + vec2(radius, -radius) * ps);
	shadow += texture(TEXTURE, UV + vec2(radius, 0.0) * ps);
	shadow += texture(TEXTURE, UV + vec2(radius, radius) * ps);
	shadow /= 8.0;
	shadow *= modulate;

	vec4 col = texture(TEXTURE, UV);
	COLOR = mix(shadow, col, col.a);
}