uniform lowp float qt_Opacity;
uniform vec2 size;
uniform float radius;
uniform float thickness;
uniform vec4 borderColor;

varying highp vec2 qt_TexCoord0;

float roundedBoxSDF(vec2 p, vec2 b, float r) {
    vec2 halfSize = b * 0.5;
    vec2 d = abs(p - halfSize) - (halfSize - vec2(r + thickness));
    return length(max(d, 0.0)) - r;
}

void main() {
    vec2 p = qt_TexCoord0 * size;

    float sdf = roundedBoxSDF(p, size, radius);
    float alpha = smoothstep(thickness + 0.5, thickness - 0.5, sdf);

    gl_FragColor = vec4(borderColor.rgb, borderColor.a * alpha) * qt_Opacity;
}