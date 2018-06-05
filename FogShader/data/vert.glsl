uniform mat4 transformMatrix;

uniform mat4 modelview;
uniform mat4 transform;
uniform mat3 normalMatrix;

attribute vec4 position;
attribute vec4 color;
attribute vec3 normal;

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 lightDir;
varying float fogDistance;
varying float rangeDist;
varying vec3 ecPosition;
varying vec3 cameraDirection;

void main() {  
  fogDistance = length(gl_Position.xyz);

	ecPosition = vec3(modelview * position);
  ecNormal = normalize(normalMatrix * normal);

	vec4 lightPosition = vec4( 0, 30, -55,0);

	lightDir = normalize(lightPosition.xyz - ecPosition);

  vec4 VP =  vec4(ecPosition,1);
  rangeDist = abs(VP.z);  	

  vertColor = color;
  cameraDirection = normalize(0 - ecPosition);
  gl_Position = transformMatrix*position;
}