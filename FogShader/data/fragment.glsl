#version 410
#define FOG_DENSITY 0.005
#define FOG_START 50
#define FOG_END 800

uniform sampler2D heightMap;
uniform float bumpScale;
uniform vec4 lightPosition;
uniform vec3 lightDiffuse;
uniform int fogMode;
uniform int distanceMode;
uniform float fog_density;

in VertexData {
  vec3 position;
  vec4 color;
  vec3 normal;
  vec2 texCoord;
	vec3 lightDir;
  vec3 cameraDir;
} vData;

out vec4 fragColor;

vec2 dHdxy_fwd(vec2 vUv) {
  vec2 dSTdx = dFdx(vUv);
  vec2 dSTdy = dFdy(vUv);

  float Hll = bumpScale * texture(heightMap, vUv).x;
  float dBx = bumpScale * texture(heightMap, vUv + dSTdx).x - Hll;
  float dBy = bumpScale * texture(heightMap, vUv + dSTdy).x - Hll;

  return vec2(dBx, dBy);
}

vec3 perturbNormal(vec3 surf_pos, vec3 surf_norm, vec2 dHdxy) {
  vec3 vSigmaX = dFdx(surf_pos);
  vec3 vSigmaY = dFdy(surf_pos);
  vec3 vN = surf_norm;// normalized
  
  vec3 R1 = cross(vSigmaY, vN);
  vec3 R2 = cross(vN, vSigmaX);

  float fDet = dot(vSigmaX, R1);

  vec3 vGrad = sign(fDet) * (dHdxy.x * R1 + dHdxy.y * R2);
  return normalize(abs(fDet) * surf_norm - vGrad);
}

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

//GroundFog
vec3 applyFog( in vec3  rgb,      // original color of the pixel
               in float rdistance, // camera to point distance
               in vec3  rayOri,   // camera position
               in vec3  rayDir )  // camera to point vector
{
    float c = -0.009;
    float b = -0.01;

    float fogAmount =  c*exp(-rayOri.y*b)*(1.0-exp(-rdistance*rayDir.y*b))/rayDir.y;
    vec3  fogColor  =  vec3(0.8,0.8,0);
    return mix( rgb, fogColor, 1.0-fogAmount );
}

void main() {
  vec2 tcoord = vData.texCoord.st;

  vec3 normal = perturbNormal(normalize(vData.position), vData.normal, dHdxy_fwd(tcoord));  
  vec3 direction = normalize(vData.lightDir);
  float intensity = max(0.0, dot(direction, normal));  
  vec4 diffuseColor = vec4(lightDiffuse * intensity ,1 ) ;  
  
  float rangeDistance = abs(vData.position.z);
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

  fragColor = mix(diffuseColor, fogColor, fogAmount);
  
  //fogAmount = fogFactorExp(rangeDistance, FOG_DENSITY);
  //fogAmount = fogFactorLinear(rangeDistance, FOG_START, FOG_END);
  //float distLength = length(vData.position);

  //groundFog not working propertly
  //vec3 color = applyFog(diffuseColor.rgb, distLength, vec3(0,0,0) ,vData.cameraDir);
  //fragColor = vec4(color,1);
}