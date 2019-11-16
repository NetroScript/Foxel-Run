// Hue Shift Shader adapted from https://gist.github.com/mairod/a75e7b44f68110e1576d77419d608786 for Godot

shader_type canvas_item;
render_mode unshaded;

uniform float hueAdjust;



const vec3  kRGBToYPrime = vec3 (0.299, 0.587, 0.114);
const vec3  kRGBToI      = vec3 (0.596, -0.275, -0.321);
const vec3  kRGBToQ      = vec3 (0.212, -0.523, 0.311);

const vec3  kYIQToR     = vec3 (1.0, 0.956, 0.621);
const vec3  kYIQToG     = vec3 (1.0, -0.272, -0.647);
const vec3  kYIQToB     = vec3 (1.0, -1.107, 1.704);


void fragment() {
	COLOR = texture(TEXTURE, UV);//setup the default image
	
	vec3 rgb_component = COLOR.xyz;
	
	float   YPrime  = dot (rgb_component, kRGBToYPrime);
    float   I       = dot (rgb_component, kRGBToI);
    float   Q       = dot (rgb_component, kRGBToQ);
    float   hue     = atan (Q, I);
    float   chroma  = sqrt (I * I + Q * Q);
	
	if (hueAdjust != 0.0){
		hue += hueAdjust;
	} else {
		hue += TIME*2.0;
	}
	
	
	
	Q = chroma * sin (hue);
    I = chroma * cos (hue);
	
	vec3    yIQ   = vec3 (YPrime, I, Q);
	
	
	
	COLOR.xyz = vec3(dot (yIQ, kYIQToR), dot (yIQ, kYIQToG), dot (yIQ, kYIQToB));//set the average to get grayscale
}