import controlP5.*;
import oscP5.*;
import netP5.*;
import java.util.*;

// Variable declaration
OscP5 oscP5;
NetAddress remoteAddress;

// GUI objects declaration
ControlP5 cp1, cp2, cp3;

// Objects that represent each single pad's controllers
PadController pad1, pad2, pad3;

// Arrays representing the state of the pads
int[] bassSettings;
int[] middleSettings;
int[] trebleSettings;
int[] soundSettings;
float[] volumeSettings;

// Called once at the beginning
void setup() {
  
  size(720, 576);
  background(51);
  
  // Smoothing the edges of the window
  smooth();
  
  noStroke();
  
  frameRate(60);
  
  // The OSC object is listening to the port 12000
  oscP5 = new OscP5(this, 12000);
  
  // The socket is specified by the localhost ip and the port 57120
  // Every OSC message will be sent to this socket
  remoteAddress = new NetAddress("127.0.0.1", 57120);
  
  bassSettings = new int[3];
  middleSettings = new int[3];
  trebleSettings = new int[3];
  soundSettings = new int[3];
  volumeSettings = new float[3];
  
  // GUI elements initialization
  cp1 = new ControlP5(this);
  cp2 = new ControlP5(this);
  cp3 = new ControlP5(this);
  
  // Pads initialization
  pad1 = new PadController(0, 25, 25, cp1);
  pad2 = new PadController(1, 25, 200, cp2);
  pad3 = new PadController(2, 25, 375, cp3);
  
}

// Loops at a fixed frequency
void draw() {
   background(200, 200, 200);
}
 

void controlEvent(ControlEvent theEvent) {
  String name = theEvent.getName();
  float value = theEvent.getValue();
  int id = theEvent.getId();
  
  // Updating the state once an Event is detected
  switch(name) {
    case "volume": {
      volumeSettings[id] = value;
      break;
    }
    case "bass": {
      bassSettings[id] = (int)value;
      break;
    } 
    case "middle": {
      middleSettings[id] = (int)value;
      break;
    }
    case "treble": {
      trebleSettings[id] = (int)value;
      break;
    }
    case "sound": {
      soundSettings[id] = (int)value;
      break;
    }
  }
  
  /*println(id, name, value);
  OscMessage message = new OscMessage("/pos");
  
  oscP5.send(message, remoteAddress);
  message.print();*/
}

/** This Class contains the definition of all the knobs needed
* to properly set the sound behaviour of the drumkit pads */
class PadController {
  Knob volume_knob;
  Knob bass_knob;
  Knob middle_knob;
  Knob treble_knob;
  ScrollableList sound_list;
  
  PadController(int id, int x, int y, ControlP5 cp5) {
    volume_knob = cp5.addKnob("volume")
    .setId(id)
    .setPosition(x, y + 20)
    .setRadius(50)
    .setRange(0, 1)
    .setValue(1)
    .setColorCaptionLabel(color(20,20,20));
        
  bass_knob = cp5.addKnob("bass")
    .setPosition(x + 125, y + 20)
    .setId(id)
    .setRadius(50)
    .setRange(-20, 20)
    .setValue(0)
    .setColorCaptionLabel(color(20,20,20));
    
  middle_knob = cp5.addKnob("middle")
    .setPosition(x + 250, y + 20)
    .setId(id)
    .setRadius(50)
    .setRange(-20, 20)
    .setValue(0)
    .setColorCaptionLabel(color(20,20,20));
    
  treble_knob = cp5.addKnob("treble")
    .setPosition(x + 375, y + 20)
    .setId(id)
    .setRadius(50)
    .setRange(-20, 20)
    .setValue(0)
    .setColorCaptionLabel(color(20,20,20));
    
  List synths = Arrays.asList("kick", "snare", "closed hh");
  sound_list = cp5.addScrollableList("sound")
    .setPosition(x + 500, y + 20)
    .setId(id)
    .setSize(100, 40)
    .setBarHeight(20)
    .setItemHeight(20)
    .setValue(0)
    .addItems(synths);
  }
}
