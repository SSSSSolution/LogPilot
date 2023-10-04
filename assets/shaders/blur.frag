#version 440
layout(location = 0) in vec2 fragCoord;
layout(location = 0) out vec4 fragColor;

layout(std140, binding = 0) uniform buf {
    mat4 qt_Matrix;
    float qt_Opacity;
    vec2 textureSize;
};

layout(binding = 1) uniform sampler2D src;

float radius = 7;
float offset = 0.001;

vec4 getBlurColor(vec2 uv){
   vec4 color = vec4(0);
   float sum = 0.0;

    for (float r = -radius; r <= radius; r++) {
        float x = uv.x + r *offset;
        if (x < 0.0 || x > 1.0) continue;
        for (float c = -radius; c <= radius; c++) {
            float y = uv.y + c *offset;
            if (y < 0.0 || y > 1.0) continue;
            vec2 target = vec2(x, y);
            float weight = (radius - abs(r)) * (radius - abs(c));
            color += texture(src, target) * weight;
            sum += weight;
        }
    }
    color /= sum;
    return color;
}

void main() {
    vec4 color = getBlurColor(fragCoord);
    fragColor = color * qt_Opacity;
}
