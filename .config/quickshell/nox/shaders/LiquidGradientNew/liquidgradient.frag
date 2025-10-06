#version 440

layout(location = 0) in vec2 texCoord;
layout(location = 1) in vec2 fragCoord;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    float iTime;
    vec3 iResolution;
    vec4 color1;
    vec4 color2;
    vec4 color3;
    vec4 color4;
    float seed;
};

layout(binding = 1) uniform sampler2D iSource;

precision highp float;

mat2 Rot(float a) {
    float s = sin(a);
    float c = cos(a);
    return mat2(c, -s, s, c);
}

// Created by inigo quilez - iq/2014
// License Creative Commons Attribution-NonCommercial-ShareAlike 3.0 Unported License.
vec2 hash( vec2 p)
{
    // Incorporate seed into the hash constants
    float s1 = 2127.1 + seed * 73.0;
    float s2 = 81.17 + seed * 37.0;
    float s3 = 1269.5 + seed * 91.0;
    float s4 = 283.37 + seed * 53.0;
    
    p = vec2( dot(p,vec2(s1,s2)), dot(p,vec2(s3,s4)) );
    return fract(sin(p)*43758.5453);
}

float noise( in vec2 p )
{
    vec2 i = floor( p );
    vec2 f = fract( p );
	
	vec2 u = f*f*(3.0-2.0*f);

    float n = mix( mix( dot( -1.0+2.0*hash( i + vec2(0.0,0.0) ), f - vec2(0.0,0.0) ), 
                        dot( -1.0+2.0*hash( i + vec2(1.0,0.0) ), f - vec2(1.0,0.0) ), u.x),
                   mix( dot( -1.0+2.0*hash( i + vec2(0.0,1.0) ), f - vec2(0.0,1.0) ), 
                        dot( -1.0+2.0*hash( i + vec2(1.0,1.0) ), f - vec2(1.0,1.0) ), u.x), u.y);
	return 0.5 + 0.5*n;
}



void main() {
    fragColor = texture(iSource, texCoord);
    {
        fragColor = texture(iSource, texCoord);
        {
            vec2 uv = texCoord;
            float ratio = iResolution.x / iResolution.y;
        
            vec2 tuv = uv;
            tuv -= .5;
        
            // rotate with Noise
            float degree = noise(vec2(iTime*.1, tuv.x*tuv.y));
        
            tuv.y *= 1./ratio;
            tuv *= Rot(radians((degree-.5)*720.+180.));
        	tuv.y *= ratio;
        
            
            // Wave warp with sin
            float frequency = 5.;
            float amplitude = 30.;
            float speed = iTime * 2.;
            tuv.x += sin(tuv.y*frequency+speed)/amplitude;
           	tuv.y += sin(tuv.x*frequency*1.5+speed)/(amplitude*.5);
            
            
            // draw the image
            vec4 layer1 = mix(color1, color2, smoothstep(-.3, .2, (tuv*Rot(radians(-5.))).x));
            vec4 layer2 = mix(color3, color4, smoothstep(-.3, .2, (tuv*Rot(radians(-5.))).x));
            
            vec4 finalComp = mix(layer1, layer2, smoothstep(.5, -.3, tuv.y));
            
            vec4 col = finalComp;
            
            // get mask
            vec4 sourceColor = texture(iSource, uv);
            float mask = sourceColor.a;
            
            fragColor = vec4(col) * mask;
        }
        fragColor = fragColor * qt_Opacity;
    }
    
    fragColor = fragColor * qt_Opacity;
}
