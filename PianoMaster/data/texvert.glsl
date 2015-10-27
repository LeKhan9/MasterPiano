#define PROCESSING_TEXTURE_SHADER

uniform mat4 transform;
uniform mat4 texMatrix;

uniform float angle;

attribute vec4 vertex;
attribute vec4 color;
attribute vec2 texCoord;

varying vec4 vertColor;
varying vec4 vertTexCoord;

void main() {
  gl_Position = transform * vertex;
    
  vertColor = color;
  vec2 newUV = vec2(texCoord.s,texCoord.t );
  vertTexCoord = texMatrix * vec4(newUV, 1.0, 1.0);
} 