import controlP5.*;
import oscP5.*;
import netP5.*;
import java.util.*;

// Variable declaration
OscP5 oscP5;
NetAddress remoteAddress;

// GUI objects declaration
ControlP5 cp5;
Knob volume_knob;
Knob lowpass_knob;
Knob hipass_knob;
ScrollableList sound_list;

float volume;
int lpFreq;
int hpFreq;
int sound;

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
  
  cp5 = new ControlP5(this);
  volume_knob = cp5.addKnob("volume")
    .setPosition(25, 20)
    .setRadius(50)
    .setRange(0, 1)
    .setValue(1)
    .setColorCaptionLabel(color(20, 20, 20));
        
  lowpass_knob = cp5.addKnob("lpFreq")
    .setPosition(150, 20)
    .setRadius(50)
    .setRange(3000, 20000)
    .setValue(20000)
    .setColorCaptionLabel(color(20, 20, 20));
    
  hipass_knob = cp5.addKnob("hpFreq")
    .setPosition(275, 20)
    .setRadius(50)
    .setRange(0, 350)
    .setValue(20)
    .setColorCaptionLabel(color(20, 20, 20));
    
  List synths = Arrays.asList("kick", "snare", "closed hh");
  sound_list = cp5.addScrollableList("sound")
    .setPosition(400, 20)
    .setSize(100, 40)
    .setBarHeight(20)
    .setItemHeight(20)
    .setValue(0)
    .addItems(synths);
    
}

// Loops at a fixed frequency
void draw() {
   background(200, 200, 200);
   rect(10, 10, width - 20, height/3 - 10);
}
  

void controlEvent(ControlEvent theEvent) {
  OscMessage message = new OscMessage("/pos");
  
  message.add(volume);
  message.add(lpFreq);
  message.add(hpFreq);
  message.add(sound);
  
  oscP5.send(message, remoteAddress);
  message.print();
}
