class Skeleton {
  // We just use this class as a structure to store the joint coordinates sent by OSC.
  // The format is {x, y, z}, where x and y are in the [0.0, 1.0] interval, 
  // and z is in the [0.0, 7.0] interval.
  float headCoords[] = new float[3];
  float neckCoords[] = new float[3];
  float rCollarCoords[] = new float[3];
  float rShoulderCoords[] = new float[3];
  float rElbowCoords[] = new float[3];
  float rWristCoords[] = new float[3];
  float rHandCoords[] = new float[3];
  float rFingerCoords[] = new float[3];
  float lCollarCoords[] = new float[3];
  float lShoulderCoords[] = new float[3];
  float lElbowCoords[] = new float[3];
  float lWristCoords[] = new float[3];
  float lHandCoords[] = new float[3];
  float lFingerCoords[] = new float[3];
  float torsoCoords[] = new float[3];
  float rHipCoords[] = new float[3];
  float rKneeCoords[] = new float[3];
  float rAnkleCoords[] = new float[3];
  float rFootCoords[] = new float[3];
  float lHipCoords[] = new float[3];
  float lKneeCoords[] = new float[3];
  float lAnkleCoords[] = new float[3];
  float lFootCoords[] = new float[3];
  float[] allCoords[] = {headCoords, neckCoords, rCollarCoords, rShoulderCoords, rElbowCoords, rWristCoords,
                       rHandCoords, rFingerCoords, lCollarCoords, lShoulderCoords, lElbowCoords, lWristCoords,
                       lHandCoords, lFingerCoords, torsoCoords, rHipCoords, rKneeCoords, rAnkleCoords,
                       rFootCoords, lHipCoords, lKneeCoords, lAnkleCoords, lFootCoords};
                       
  float[][] collisionLine = {lHandCoords, lElbowCoords, lShoulderCoords, headCoords, 
                             rShoulderCoords, rElbowCoords, rHandCoords};
                    
  int id; //here we store the skeleton's ID as assigned by OpenNI and sent through OSC.
  float colors[] = {255, 255, 255};// The color of this skeleton

  // An object to store information about the uneven surface
  EdgeChainDef edges = new EdgeChainDef ();
  BodyDef bd = new BodyDef();
  Body body;

  Skeleton(int id) {
    this.id = id;
    colors[0] = random(128, 255);
    colors[1] = random(128, 255);
    colors[2] = random(128, 255);
    
    // Create the surface
    bd.position.set(0.0f,0.0f);
    body = box2d.world.createBody(bd);
  }
  
  void addCollisionLine() {
    Vec2 screenVertex;
    Vec2 worldVertex;
  
    for (float[] j: collisionLine) {
      screenVertex = new Vec2(j[0]*width,j[1]*height);
      worldVertex = box2d.screenToWorld(screenVertex);
      edges.addVertex(worldVertex);
    }
  }
}
