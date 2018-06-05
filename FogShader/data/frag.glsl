#define FOG_DENSITY 0.001
#define FOG_START 100
#define FOG_END 1500

uniform vec3 lightDiffuse;
uniform int fogMode;
uniform int distanceMode;
uniform float fog_density;

varying vec4 vertColor;
varying vec3 ecNormal;
varying vec3 lightDir;
varying float fogDistance;
varying float rangeDist;
varying vec3 ecPosition;
varying vec3 cameraDirection;


vec4 fogColor;

float fogFactorExp(
  const float dist,
  const float density
) {
  return 1.0 - clamp(exp(-density * dist), 0.0, 1.0);
}

float fogFactorExp2(
  const float dist,
  const float density
) {
  const float LOG2 = -1.442695;
  float d = density * dist;
  return 1.0 - clamp(exp2(d * d * LOG2), 0.0, 1.0);
	
}
float fogFactorLinear(
  const float dist,
  const float start,
  const float end
) {
  return 1.0 - clamp((end - dist) / (end - start), 0.0, 1.0);
}

vec3 applyFog( in vec3  rgb,      // original color of the pixel
               in float rdistance, // camera to point distance
               in vec3  rayOri,   // camera position
               in vec3  rayDir )  // camera to point vector
{
    float c = -0.009;
    float b = -0.01;

    float fogAmount =  c*exp(-rayOri.y*b)*(1.0-exp(-rdistance*rayDir.y*b))/rayDir.y;
    vec3  fogColor  =  vec3(0.8,0.8,0.8);
    return mix( rgb, fogColor, 1.0-fogAmount );
}

void main() {
  //gl_FragColor = vertColor;
	float intensity;
  float light = 0;
  vec4 colorSum = vec4(0,0,0,0);

	vec3 normal = normalize(ecNormal);  
  vec3 direction = normalize(lightDir);

  intensity = max(0.0, dot(direction, normal));

  light += intensity;

  float magnitude = sqrt(pow(lightDir.x ,2) + pow(lightDir.y ,2) + pow(lightDir.z ,2));

  vec4 color1 = vec4(intensity/pow(magnitude,2), intensity/pow(magnitude,2) , 0, 1);

	vec4 actualcolor = vec4(lightDiffuse * intensity/pow(magnitude,2) ,1 ) ; 
  //gl_FragColor = color1 * vertColor;

	//float fogDistance2 = gl_FragCoord.z / gl_FragCoord.w;
  //float fogAmount = fogFactorExp(rangeDist, FOG_DENSITY);
  fogColor = vec4(0.8,0.8,0.8,1); // white
	

  //fogAmount = fogFactorLinear(fogDistance2, FOG_START, FOG_END);
  float dist3 = length(ecPosition);
  float be = (0-ecPosition.y) * -0.004;
  float bi = (0-ecPosition.y) * -0.001;

  float ext = exp(-rangeDist * be);
  float insc = exp(-rangeDist * bi);
	
  vec4 finalColor = actualcolor * ext + fogColor * (1 - insc);
  //vec3 color = applyFog(actualcolor.rgb, dist3, vec3(0,0,0) ,cameraDirection);
  //gl_FragColor = vec4(color,1);

  float rangeDistance = rangeDist;
  float planeDistance = gl_FragCoord.z / gl_FragCoord.w;

  vec4 fogColor = vec4(0.8,0.8,0.8,1); // white  
  float fogAmount;
  float vdistance;

  if(distanceMode == 1){
    vdistance = rangeDistance;
  }
  if(distanceMode == 2){
    vdistance = planeDistance;
  }

  if(fogMode == 1){
    fogAmount = fogFactorLinear(vdistance, FOG_START, FOG_END);
  }
  if(fogMode == 2){
    fogAmount = fogFactorExp(vdistance, fog_density); 
  }
  if(fogMode == 3){
     fogAmount = fogFactorExp2(vdistance, fog_density); 
  }

  //fragColor = mix(diffuseColor, fogColor, fogAmount);

  gl_FragColor = mix(actualcolor, fogColor, fogAmount);
}