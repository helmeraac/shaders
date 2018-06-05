import peasy.*;
PeasyCam cam;

PShape treeShape, char2;
PShape grid;
PShader terrainShader;
PShader fogShader;
PImage heightMap;

PVector origin;
PVector[] positions;
float[] scales;

int itemNumber = 150;
int distance = 1000;
int landSize = 3000;

void settings() {
  //fullScreen(P3D);
  size(1200, 600, P3D);
}

void setup(){   
  cam = new PeasyCam(this, 1500);
  cam.setMinimumDistance(5);
  cam.setMaximumDistance(100000);
  
  origin = new PVector(width/2, height/2, 0);
  treeShape = loadShape("Tree.obj");
  char2 = loadShape("character.obj");
  heightMap = loadImage("goodmountains.jpg");  
  
  positions = new PVector[itemNumber];
  scales = new float[itemNumber];  
  for (int i=0; i < itemNumber; i++) {    
    float x = random(-distance,distance);
    float z = random(-distance,distance);     
    positions[i] = new PVector(x,0,z);
    scales[i] =  random(5,10); 
  }  
  
  setupGrid();
  setupShaders();
}

void draw(){
  translate(origin.x,origin.y);
  fill(255,255,255);  
  directionalLight(0, 104, 104, 200, 200, 200);
  //ambientLight(102, 102, 102);
  background(250*0.8);
  noStroke();
  
  renderTerrain();  
  
  renderLandscape();
}

public void renderLandscape() {
    shader(fogShader);
    
    pushMatrix();
    //box(landSize, 5, landSize);    
    rotateX(radians(90));    
    scale(8);
    shape(treeShape);  
    popMatrix();
    
    for (int i=0; i < itemNumber; i++) { 
    pushMatrix();
    translate(positions[i].x,0,positions[i].z);
    rotateX(radians(90));
    scale(scales[i]);
    shape(treeShape);
    popMatrix();
  }    
}

public void renderTerrain(){
  shader(terrainShader);
  
  pushMatrix(); 
  scale(10);
  rotateX(radians(90));   
  shape(grid);  
  popMatrix();
}

void setupShaders(){
  terrainShader = loadShader("fragment.glsl", "vertex.glsl");
  terrainShader.set("heightMap", heightMap); 
  terrainShader.set("bumpScale", 0.05f);
  terrainShader.set("fogMode", 1); 
  terrainShader.set("distanceMode", 1); 
  terrainShader.set("fog_density", 0.005f);
  terrainShader.set("height_scale", 15.0f);
  
  fogShader = loadShader("frag.glsl", "vert.glsl");
  fogShader.set("fogMode", 1); 
  fogShader.set("distanceMode", 1); 
  fogShader.set("fog_density", 0.005f);
}

void setupGrid() {
  grid = createShape();
  grid.beginShape(QUADS);
  //grid.stroke(0,55,0);
  grid.noStroke();
  for (int i = 0; i < 180; i++) {
    for (int j = 0; j < 240; j++) {
      float x0 = map(i, 0, 180, -90, 90); 
      float x1 = x0 + 1;
      float y0 = map(j, 0, 240, -120, 120); 
      float y1 = y0 + 1;    
      float u0 = map(x0, -90, 90, 0, 1);
      float u1 = map(x1, -90, 90, 0, 1);      
      float v0 = map(y0, -120, 120, 0, 1);
      float v1 = map(y1, -120, 120, 0, 1);
      grid.normal(0, 0, 1); 
      grid.vertex(x0, y0, u0, v0);
      grid.vertex(x1, y0, u1, v0);
      grid.vertex(x1, y1, u1, v1);
      grid.vertex(x0, y1, u0, v1);
    }  
  } 
  grid.endShape();  
}