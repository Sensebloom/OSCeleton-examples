import processing.opengl.*;

import oscP5.*;
import netP5.*;

OscP5 oscP5;

int ballSize = 10;
Hashtable<Integer, Skeleton> skels = new Hashtable<Integer, Skeleton>();



void setup() {
    size(screen.height*4/3/2, screen.height/2, OPENGL); //Keep 4/3 aspect ratio, since it matches the kinect's.
    oscP5 = new OscP5(this, "127.0.0.1", 7110);
    hint(ENABLE_OPENGL_4X_SMOOTH);
    noStroke();
}



/* incoming osc message are forwarded to the oscEvent method. */
// Here you can easily see the format of the OSC messages sent. For each user, the joints are named with 
// the joint named followed by user ID (head0, neck0 .... r_foot0; head1, neck1.....)
void oscEvent(OscMessage msg) {
  msg.print();
  
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



void draw()
{
  background(0);  
  ambientLight(64, 64, 64);
  lightSpecular(255,255,255);
  directionalLight(224,224,224, .5, 1, -1);

  for (Skeleton s: skels.values()) {
    fill(s.colors[0], s.colors[1], s.colors[2]);
    for (float[] j: s.allCoords) {
      pushMatrix();
      translate(j[0]*width, j[1]*height, -j[2]*300);
      sphere(2 * ballSize/j[2]);
      popMatrix();
    }
  }
}
