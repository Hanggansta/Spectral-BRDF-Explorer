#version 300 es

layout(location = 0) in vec3 inputPosition;
layout(location = 1) in vec3 inputNormal;
layout(location = 2) in vec2 inputTextureCoordinate;

uniform mat4 mvMatrix;
uniform mat4 mvpMatrix;
uniform mat4 mvpLightMatrix;
uniform mat4 normalMatrix;

out vec3 normalInterp;
out vec3 vertPos;
out vec2 textureCoordinate;
out vec4 shadowCoord;

void main() { 

    gl_Position = mvpMatrix * vec4(inputPosition, 1.0);

    vec4 vertPosWorldCoordinate = mvMatrix * vec4(inputPosition, 1.0);
    vertPos = vec3(vertPosWorldCoordinate);
    
    normalInterp = vec3(normalMatrix * vec4(inputNormal, 0.0));

    shadowCoord = mvpLightMatrix * vec4(inputPosition, 1.0) + 0.001;
    shadowCoord = shadowCoord * 0.5 + 0.5;
    
    textureCoordinate = inputTextureCoordinate;
}