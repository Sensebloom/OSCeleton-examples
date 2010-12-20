import oscP5.*;
import netP5.*;

import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// A reference to our box2d world
PBox2D box2d;

// An ArrayList of particles that will fall on the surface
ArrayList particles;
  
OscP5 oscP5;

float noiseIter = 0.0;
int ballSize = 10;

Hashtable<Integer, Skeleton> skels = new Hashtable<Integer, Skeleton>();

void setup() {
    size(screen.height*4/3, screen.height);    // use OPENGL rendering for bilinear filtering on texture
    smooth();
    oscP5 = new OscP5(this, "127.0.0.1", 7110);
    
    // Initialize box2d physics and create the world
  box2d = new PBox2D(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -40);

  // Create the empty list
  particles = new ArrayList();
}

/* incoming osc message are forwarded to the oscEvent method. */
// Here you can easily see the format of the OSC messages sent. For each user, the joints are named with 
// the joint named followed by user ID (head0, neck0 .... r_foot0; head1, neck1.....)
void oscEvent(OscMessage msg) {
  if (msg.checkAddrPattern("/joint") && msg.checkTypetag("sifff")) {
    // We have received joint coordinates, let's find out which skeleton/joint and save the values ;)
    Integer id = msg.get(1).intValue();
    Skeleton s = skels.get(id);
    if (s == null) {
      s = new Skeleton(id);
      skels.put(id, s);
    }
    if (msg.get(0).stringValue().equals("head")) {
      s.headCoords[0] = msg.get(2).floatValue();
      s.headCoords[1] = msg.get(3).floatValue();
      s.headCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("neck")) {
      s.neckCoords[0] = msg.get(2).floatValue();
      s.neckCoords[1] = msg.get(3).floatValue();
      s.neckCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("r_collar")) {
      s.rCollarCoords[0] = msg.get(2).floatValue();
      s.rCollarCoords[1] = msg.get(3).floatValue();
      s.rCollarCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("r_shoulder")) {
      s.rShoulderCoords[0] = msg.get(2).floatValue();
      s.rShoulderCoords[1] = msg.get(3).floatValue();
      s.rShoulderCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("r_elbow")) {
      s.rElbowCoords[0] = msg.get(2).floatValue();
      s.rElbowCoords[1] = msg.get(3).floatValue();
      s.rElbowCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("r_wrist")) {
      s.rWristCoords[0] = msg.get(2).floatValue();
      s.rWristCoords[1] = msg.get(3).floatValue();
      s.rWristCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("r_hand")) {
      s.rHandCoords[0] = msg.get(2).floatValue();
      s.rHandCoords[1] = msg.get(3).floatValue();
      s.rHandCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("r_finger")) {
      s.rFingerCoords[0] = msg.get(2).floatValue();
      s.rFingerCoords[1] = msg.get(3).floatValue();
      s.rFingerCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("r_collar")) {
      s.lCollarCoords[0] = msg.get(2).floatValue();
      s.lCollarCoords[1] = msg.get(3).floatValue();
      s.lCollarCoords[2] = msg.get(4).floatValue();
    }  
    else if (msg.get(0).stringValue().equals("l_shoulder")) {
      s.lShoulderCoords[0] = msg.get(2).floatValue();
      s.lShoulderCoords[1] = msg.get(3).floatValue();
      s.lShoulderCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("l_elbow")) {
      s.lElbowCoords[0] = msg.get(2).floatValue();
      s.lElbowCoords[1] = msg.get(3).floatValue();
      s.lElbowCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("l_wrist")) {
      s.lWristCoords[0] = msg.get(2).floatValue();
      s.lWristCoords[1] = msg.get(3).floatValue();
      s.lWristCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("l_hand")) {
      s.lHandCoords[0] = msg.get(2).floatValue();
      s.lHandCoords[1] = msg.get(3).floatValue();
      s.lHandCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("l_finger")) {
      s.lFingerCoords[0] = msg.get(2).floatValue();
      s.lFingerCoords[1] = msg.get(3).floatValue();
      s.lFingerCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("torso")) {
      s.torsoCoords[0] = msg.get(2).floatValue();
      s.torsoCoords[1] = msg.get(3).floatValue();
      s.torsoCoords[2] = msg.get(4).floatValue();
    }
    else if (msg.get(0).stringValue().equals("r_hip")) {
      s.rHipCoords[0] = msg.get(2).floatValue();
      s.rHipCoords[1] = msg.get(3).floatValue();
      s.rHipCoords[2] = msg.get(4).floatValue();
    } 
    else if (msg.get(0).stringValue().equals("r_knee")) {
      s.rKneeCoords[0] = msg.get(2).floatValue();
      s.rKneeCoords[1] = msg.get(3).floatValue();
      s.rKneeCoords[2] = msg.get(4).floatValue();
    } 
    else if (msg.get(0).stringValue().equals("r_ankle")) {
      s.rAnkleCoords[0] = msg.get(2).floatValue();
      s.rAnkleCoords[1] = msg.get(3).floatValue();
      s.rAnkleCoords[2] = msg.get(4).floatValue();
    } 
    else if (msg.get(0).stringValue().equals("r_foot")) {
      s.rFootCoords[0] = msg.get(2).floatValue();
      s.rFootCoords[1] = msg.get(3).floatValue();
      s.rFootCoords[2] = msg.get(4).floatValue();
    } 
    else if (msg.get(0).stringValue().equals("l_hip")) {
      s.lHipCoords[0] = msg.get(2).floatValue();
      s.lHipCoords[1] = msg.get(3).floatValue();
      s.lHipCoords[2] = msg.get(4).floatValue();
    } 
    else if (msg.get(0).stringValue().equals("l_knee")) {
      s.lKneeCoords[0] = msg.get(2).floatValue();
      s.lKneeCoords[1] = msg.get(3).floatValue();
      s.lKneeCoords[2] = msg.get(4).floatValue();
    } 
    else if (msg.get(0).stringValue().equals("l_ankle")) {
      s.lAnkleCoords[0] = msg.get(2).floatValue();
      s.lAnkleCoords[1] = msg.get(3).floatValue();
      s.lAnkleCoords[2] = msg.get(4).floatValue();
    } 
    else if (msg.get(0).stringValue().equals("l_foot")) {
      s.lFootCoords[0] = msg.get(2).floatValue();
      s.lFootCoords[1] = msg.get(3).floatValue();
      s.lFootCoords[2] = msg.get(4).floatValue();
    } 
  }
  else if (msg.checkAddrPattern("/new_user") && msg.checkTypetag("i")) {
    // A new user is in front of the kinect... Tell him to do the calibration pose!
    println("New user with ID = " + msg.get(0).intValue());
  }
  else if(msg.checkAddrPattern("/new_skel") && msg.checkTypetag("i")) {
    //New skeleton calibrated! Lets create it!
    Integer id = msg.get(0).intValue();
    Skeleton s = new Skeleton(id);
    skels.put(id, s);
  }
  else if(msg.checkAddrPattern("/lost_user") && msg.checkTypetag("i")) {
    //Lost user/skeleton
    Integer id = msg.get(0).intValue();
    println("Lost user " + id);
    skels.remove(id);
  }
}


void drawBone(float joint1[], float joint2[]) {
  if ((joint1[0] == -1 && joint1[1] == -1) || (joint2[0] == -1 && joint2[1] == -1))
    return;
  
  float dx = (joint2[0] - joint1[0]) * width;
  float dy = (joint2[1] - joint1[1]) * height;
  float steps = 2 * sqrt(pow(dx,2) + pow(dy,2)) / ballSize;
  float step_x = dx / steps / width;
  float step_y = dy / steps / height;
  
  for (int i=0; i<=steps; i++) {
    ellipse((joint1[0] + (i*step_x))*width, 
            (joint1[1] + (i*step_y))*height, 
            ballSize, ballSize);
  }
}


void draw() {
  background(0);
  noStroke();
  
  for (Skeleton s: skels.values()) {
    s.addCollisionLine();
  
    //Head
    ellipse(s.headCoords[0]*width, 
            s.headCoords[1]*height + 10, 
            ballSize*5, ballSize*6);
  
    //Head to neck 
    drawBone(s.headCoords, s.neckCoords);
    //Center upper body
    //drawBone(lShoulderCoords, rShoulderCoords);
    drawBone(s.headCoords, s.rShoulderCoords);
    drawBone(s.headCoords, s.lShoulderCoords);
    drawBone(s.neckCoords, s.torsoCoords);
    //Right upper body
    drawBone(s.rShoulderCoords, s.rElbowCoords);
    drawBone(s.rElbowCoords, s.rHandCoords);
    //Left upper body
    drawBone(s.lShoulderCoords, s.lElbowCoords);
    drawBone(s.lElbowCoords, s.lHandCoords);
    //Torso
    //drawBone(rShoulderCoords, rHipCoords);
    //drawBone(lShoulderCoords, lHipCoords);
    drawBone(s.rHipCoords, s.torsoCoords);
    drawBone(s.lHipCoords, s.torsoCoords);
    //drawBone(lHipCoords, rHipCoords);
    //Right leg
    drawBone(s.rHipCoords, s.rKneeCoords);
    drawBone(s.rKneeCoords, s.rFootCoords);
  //  drawBone(rFootCoords, lHipCoords);
    //Left leg
    drawBone(s.lHipCoords, s.lKneeCoords);
    drawBone(s.lKneeCoords, s.lFootCoords);
  //  drawBone(lFootCoords, rHipCoords);
    
    for (float j[]: s.allCoords) {
      ellipse(j[0]*width, j[1]*height, ballSize*2, ballSize*2);
    }  
    s.body.createShape(s.edges);
  }
  
  particles.add(new Particle(noise(noiseIter)*width,
                             0,random(2,6)));
  noiseIter += 0.01;
  
  // We must always step through time!
  box2d.step();

  // Draw all particles
  for (int i = 0; i < particles.size(); i++) {
    Particle p = (Particle) particles.get(i);
    p.display();
  }

  // Particles that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  for (int i = particles.size()-1; i >= 0; i--) {
    Particle p = (Particle) particles.get(i);
    if (p.done()) {
      particles.remove(i);
    }
  }

  for (Skeleton s: skels.values()) {
    box2d.destroyBody(s.body);
    s.body = box2d.world.createBody(s.bd);
    s.edges = new EdgeChainDef();
    s.edges.setIsLoop(false);   // We could make the edge a full loop
    s.edges.friction = 0.1;    // How much friction
    s.edges.restitution = 1.3; // How bouncy
  }
}
