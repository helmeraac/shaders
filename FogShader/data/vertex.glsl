#version 410

uniform mat4 transformMatrix;
uniform sampler2D heightMap;
uniform mat4 texMatrix;
uniform mat4 modelviewMatrix;
uniform mat3 normalMatrix;

in vec4 position;
in vec4 color;
in vec3 normal;
in vec2 texCoord;
uniform vec4 lightPosition;
uniform vec3 lightDiffuse;
uniform int fogMode;
uniform float height_scale;

out VertexData {
  vec3 position;
  vec4 color;
  vec3 normal;
  vec2 texCoord;
	vec3 lightDir;
  vec3 cameraDir;
} vData;


void main() {
  vec2 st = (texMatrix * vec4(texCoord, 1.0, 1.0)).st;
  float h = height_scale * texture(heightMap, st).r;
	vec4 dispPos = vec4(position.xy, h, 1);
  vData.position = vec3(modelviewMatrix * dispPos);
  vData.color = color;
  vData.normal = normal;  
  vData.texCoord = texCoord;
	vData.normal = normalize(normalMatrix * normal);

	vData.lightDir = normalize(lightPosition.xyz - vData.position);
  vData.cameraDir = normalize(0 - vData.position);

	gl_Position = transformMatrix * dispPos; 
}