#include "MIDIUSB.h"

const int N = 3;
bool prevState[N];
byte i;
byte a = 0;
byte pitch[] = {35,42,38};

//check for a voltage change at the input pins
int changedStatus(){
  for (i=0;i<N;i++){
    if (digitalRead(2+i) != prevState[i]){
      return i+1;
    }
  }
  return 0;
}

//Send a MIDI event
void noteOn(byte channel, byte pitch, byte velocity) {
  midiEventPacket_t noteOn = {0x09, 0x90 | channel, pitch, velocity};
  MidiUSB.sendMIDI(noteOn);
  MidiUSB.flush();
}

void setup() {
  Serial.begin(9600);
  for (i=0;i<N;i++){
    pinMode(2+i,INPUT_PULLUP);
    prevState[i] = 1;
  }
}

void loop() {
  if (a = changedStatus()){
    a--;
    prevState[a] = !prevState[a];
    if (prevState[a]==LOW){
      noteOn(a,0,100);
      delay(5); //avoid key bounce problems
    }
  }
}
