import controlP5.*;
import oscP5.*;
import netP5.*;
import java.util.*;

/** Variables declaration **/
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
float[] attackSettings;
float[] releaseSettings;
int[] curveSettings;

// Variable for the font
PFont f;

// Called once at the beginning
void setup() {
  
  // Setting window size and color
  size(770, 530);
  background(200, 200, 200);
  
  // Smoothing the edges of the window
  smooth();
  
  frameRate(60);
  
  // The OSC object is listening to the port 12000
  oscP5 = new OscP5(this, 12000);
  
  // The socket is specified by the localhost ip and the port 57120
  // Every OSC message will be sent to this socket
  remoteAddress = new NetAddress("127.0.0.1", 57120);
  
  // Equalizers settings
  bassSettings = new int[3];
  middleSettings = new int[3];
  trebleSettings = new int[3];
  
  // Envelope settings
  attackSettings = new float[3];
  releaseSettings = new float[3];
  curveSettings = new int[3];  
  
  // Sound synth choice
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
  
  // Creating Font for Labels
  f = createFont("Broadway", 18, true);
  textFont(f);
  
  // Setting Stroke dimension
  strokeWeight(3);
}

// Loops at a fixed frequency
void draw() {
   // Drawing the Pad Controller delimiters
   
   
   fill(color(255,0,0));
   rect(10, 10, 750, 160, 10);
   
   fill(color(0,255,0));
   rect(10, 185, 750, 160, 10);
   
   fill(color(0,0,255));
   rect(10, 360, 750, 160, 10);
   
   fill(0);
   text("Equalizer", 270, 155);
   text("Equalizer", 270, 330);
   text("Equalizer", 270, 505);
   text("Envelope", 525, 155);
   text("Envelope", 525, 330);
   text("Envelope", 525, 505);
  
   fill(70);
   rect(150, 25, 330, 110, 10);
   rect(510, 25, 115, 110, 10);
    
   rect(150, 200, 330, 110, 10);
   rect(510, 200, 115, 110, 10);

   rect(150, 375, 330, 110, 10);
   rect(510, 375, 115, 110, 10);
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
    case "A": {
      attackSettings[id] = value;
      break;
    }
    case "R": {
      releaseSettings[id] = value;
      break;
    }
    case "curve": {
      curveSettings[id] = (int)value;
      break;
    } 
    case "sound": {
      soundSettings[id] = (int)value;
      break;
    }
  }
  
  // Building the OSC message to be sent to the specific synth address
  OscMessage message = new OscMessage("/main/synth"+id);
  message.add(volumeSettings[id]);
  message.add(bassSettings[id]);
  message.add(middleSettings[id]);
  message.add(trebleSettings[id]);
  message.add(attackSettings[id]);
  message.add(releaseSettings[id]);
  message.add(curveSettings[id]);
  message.add(soundSettings[id]);
  
  oscP5.send(message, remoteAddress);
  // DEBUG
  message.print();
}

/** This Class contains the definition of all the knobs needed
* to properly set the sound behaviour of the drumkit pads */
class PadController {
  Knob volume_knob;
  Knob bass_knob;
  Knob middle_knob;
  Knob treble_knob;
  Slider a_slider;
  Slider r_slider;
  Slider curve_slider;
  ScrollableList sound_list;
  
  PadController(int id, int x, int y, ControlP5 cp5) {
    volume_knob = cp5.addKnob("volume")
      .setId(id)
      .setPosition(x, y + 10)
      .setRadius(50)
      .setRange(0, 1)
      .setValue(1)
      .setColorCaptionLabel(color(20,20,20));
        
    bass_knob = cp5.addKnob("bass")
      .setPosition(x + 140, y + 10)
      .setId(id)
      .setRadius(40)
      .setRange(-20, 20)
      .setValue(0)
      
      .setColorCaptionLabel(color(255,255,255));
    
    middle_knob = cp5.addKnob("middle")
      .setPosition(x + 250, y + 10)
      .setId(id)
      .setRadius(40)
      .setRange(-20, 20)
      .setValue(0)
      .setColorCaptionLabel(color(255,255,255));
    
    treble_knob = cp5.addKnob("treble")
      .setPosition(x + 360, y + 10)
      .setId(id)
      .setRadius(40)
      .setRange(-20, 20)
      .setValue(0)
      .setColorCaptionLabel(color(255,255,255));
    
    a_slider = cp5.addSlider("A")
      .setPosition(x + 500, y + 10)
      .setId(id)
      .setWidth(10)
      .setHeight(80)
      .setRange(0, 0.2)
      .setValue(0)
      .setColorCaptionLabel(color(255));
    
    r_slider = cp5.addSlider("R")
      .setPosition(x + 535, y + 10)
      .setId(id)
      .setWidth(10)
      .setHeight(80)
      .setRange(0.05, 1)
      .setValue(1)
      .setColorCaptionLabel(color(255));
      
    curve_slider = cp5.addSlider("curve")
      .setPosition(x + 570, y + 10)
      .setId(id)
      .setWidth(10)
      .setHeight(80)
      .setRange(-5, 5)
      .setValue(0)
      .setNumberOfTickMarks(11)
      .snapToTickMarks(true)
      .showTickMarks(false)
      .setColorCaptionLabel(color(255));
      
    List synths = Arrays.asList("kick", "snare", "hh", "htom", "mtom", "ltom");
    sound_list = cp5.addScrollableList("sound")
      .setPosition(x + 620, y + 10)
      .setId(id)
      .setSize(100, 40)
      .setBarHeight(20)
      .setItemHeight(20)
      .setValue(0)
      .addItems(synths);
  }
}
