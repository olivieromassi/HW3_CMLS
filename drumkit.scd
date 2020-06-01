s.boot;
s.quit;

MIDIClient.init;
MIDIIn.connectAll;

NetAddr("127.0.0.1", 57120);

(
SynthDef(\kick, {
	arg volume=1.0, bass=0.0, middle=0.0, treble=0.0, attack=0.0, release=1.0, curve=0;
    var  n=0.8, nl = 0.008, start=80, end=15, l1=0.3, l2=1, exp=0.8;
    var boom;

	var env = Env.perc(attack, release, volume, curve);
	var gen = EnvGen.kr(env);

    e = pow(Line.ar(0.9,0,l2),exp);
    boom = BBandPass.ar(WhiteNoise.ar(10),freq:Line.ar(100,20,nl))*Line.ar(1,0,nl)*n+SinOsc.ar(Line.ar(start, end, l1))*e;
	boom = boom*gen;

	boom = BPeakEQ.ar(boom, 100, 1.0, bass);
	boom = BPeakEQ.ar(boom, 600, 1.0, middle);
	boom = BPeakEQ.ar(boom, 1500, 1.0, treble);

    Out.ar(0,[boom,boom]);
}).add;


SynthDef(\snare, {
	arg volume=1.0, bass=0.0, middle=0.0, treble=0.0, attack=0.0, release=1.0, curve=0;

	var env = Env.perc(attack, release, volume, curve);
	var gen = EnvGen.kr(env);

	var snd;

    snd = LPF.ar(HPF.ar(WhiteNoise.ar, 350), 8000) * Env.linen(0.001, 0.01, 0.001).ar;
    snd = snd + (SinOsc.ar(Env([400, 200, 6], [0.01, 0.1], \exp).ar) * Env.perc(0.004, 0.2).ar * 6.dbamp).tanh;
    snd = snd + (HPF.ar(BPeakEQ.ar(WhiteNoise.ar, 4000, 0.5, 3), 300) * Env.perc(0.05, 0.4).delay(0.01).ar(2) * -3.dbamp);
    snd = snd + (SinOsc.ar(XLine.kr(350, 215, 0.01)) * Env.perc(0.001, 0.02).ar);
    snd = (snd * 1.4).tanh;
    snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1));
	snd = snd * gen;

	snd = BPeakEQ.ar(snd, 100, 1.0, bass);
	snd = BPeakEQ.ar(snd, 600, 1.0, middle);
	snd = BPeakEQ.ar(snd, 1500, 1.0, treble);

    Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\htom, {
	arg volume=1.0, bass=0.0, middle=0.0, treble=0.0, attack=0.0, release=1.0, curve=0;

	var env = Env.perc(attack, release, volume, curve);
	var gen = EnvGen.kr(env);

	var snd;

    snd = LPF.ar(HPF.ar(WhiteNoise.ar, 300), 8000) * Env.linen(0.001, 0.01, 0.001).ar;
    snd = snd + (SinOsc.ar(Env([400, 300, 1], [0.001, 1], \exp).ar) * Env.perc(0.01, 0.15).ar * 2.dbamp).tanh;
    snd = snd + (HPF.ar(BPeakEQ.ar(WhiteNoise.ar, 10, 0.5, 3), 0.03) * Env.perc(0.005, 0.2).delay(0.01).ar(2) * -3.dbamp);
    snd = snd + (SinOsc.ar(XLine.kr(3000, 1500, 0.01)) * Env.perc(0.001, 0.02).ar);
    snd = (snd * 1.4).tanh;
    snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1));
	snd = snd * gen;

	snd = BPeakEQ.ar(snd, 100, 1.0, bass);
	snd = BPeakEQ.ar(snd, 600, 1.0, middle);
	snd = BPeakEQ.ar(snd, 1500, 1.0, treble);

    Out.ar(\out.kr(0), snd);
}).add;

SynthDef(\mtom, {
	arg volume=1.0, bass=0.0, middle=0.0, treble=0.0, attack=0.0, release=1.0, curve=0;

    var startPitch = 200, endPitch=150, clickLevel=0.7, pitchRel = 0.27, noiseLevel=1, noiseRel= 0.3;

	var env = Env.perc(attack, release, volume, curve);
	var gen = EnvGen.kr(env);

    var pitchEnv = EnvGen.ar(Env.perc(0.01, pitchRel));

    var clickOsc = SinOsc.ar(pitchEnv*(startPitch-endPitch)+endPitch);
    var clickEnv = EnvGen.ar(Env.perc(0.001, pitchRel))*clickLevel;
    var noiseOsc = PinkNoise.ar();
    var noiseEnv = EnvGen.ar(Env.perc(0.01, noiseRel))*noiseLevel;
	var snd =  (noiseOsc * noiseEnv +clickOsc *clickEnv);
	snd = snd * gen;

	snd = BPeakEQ.ar(snd, 100, 1.0, bass);
	snd = BPeakEQ.ar(snd, 600, 1.0, middle);
	snd = BPeakEQ.ar(snd, 1500, 1.0, treble);

    Out.ar(0,Pan2.ar(snd, 0, 1));
}).add;

SynthDef(\ltom, {
	arg volume=1.0, bass=0.0, middle=0.0, treble=0.0, attack=0.0, release=1.0, curve=0;

    var startPitch = 155, endPitch=60, clickLevel=0.7, pitchRel = 0.4, noiseLevel=1, noiseRel= 0.3;

	var env = Env.perc(attack, release, volume, curve);
	var gen = EnvGen.kr(env);

    var pitchEnv = EnvGen.ar(Env.perc(0.01, pitchRel));

    var clickOsc = SinOsc.ar(pitchEnv*(startPitch-endPitch)+endPitch);
    var clickEnv = EnvGen.ar(Env.perc(0.001, pitchRel))*clickLevel;
    var noiseOsc = PinkNoise.ar();
    var noiseEnv = EnvGen.ar(Env.perc(0.01, noiseRel))*noiseLevel;
	var snd =  (noiseOsc * noiseEnv +clickOsc *clickEnv);
	snd = snd * gen;

	snd = BPeakEQ.ar(snd, 100, 1.0, bass);
	snd = BPeakEQ.ar(snd, 600, 1.0, middle);
	snd = BPeakEQ.ar(snd, 1500, 1.0, treble);

    Out.ar(0,Pan2.ar(snd, 0, 1));
}).add;

SynthDef(\hh, {
	arg volume=1.0, bass=0.0, middle=0.0, treble=0.0, attack=0.0, release=1.0, curve=0;

	var noiseRel = 0.5, noiseLevel=0.6, ffreq=10000, q=(-4);
    var noiseOsc = BBandPass.ar(PinkNoise.ar(), ffreq, 0.2);
    var noiseEnv = EnvGen.ar(Env.perc(0.001, noiseRel, noiseLevel, q));

	var env = Env.perc(attack, release, volume, curve);
	var gen = EnvGen.kr(env);

	var son,snd;
	son = Klank.ar(`[
		[1400, 7000, 4900, 3800, 700, 5500,7900, 7320, 9340],
		[0.25,0.2,0.15,0.1, 0.1, 0.1,0.1, 0.1, 0.1],
		[0.2, 0.2, 0.2,0.2, 0.2, 0.2,0.4, 0.4, 0.5]
		],
	Impulse.ar(1));

    snd = son*0.02+noiseOsc * noiseEnv * 2;
	snd = snd * gen;

	snd = BPeakEQ.ar(snd, 100, 1.0, bass);
	snd = BPeakEQ.ar(snd, 600, 1.0, middle);
	snd = BPeakEQ.ar(snd, 1500, 1.0, treble);

    Out.ar(0,Pan2.ar(snd*10, 0, 1));
}).add;
)

(
var drums;

~volume0 = 1.0;
~volume1 = 1.0;
~volume2 = 1.0;

~bass0 = 0;
~bass1 = 0;
~bass2 = 0;

~middle0 = 0;
~middle1 = 0;
~middle2 = 0;

~treble0 = 0;
~treble1 = 0;
~treble2 = 0;

~attack0 = 0.0;
~attack1 = 0.0;
~attack2 = 0.0;

~release0 = 1.0;
~release1 = 1.0;
~release2 = 1.0;

~curve0 = 0;
~curve1 = 0;
~curve2 = 0;

~sound0;
~sound1;
~sound2;

~sounds = Array.with(\kick, \snare, \hh, \htom, \mtom, \ltom);

/** MIDI interaction code **/

drums = Array.newClear(3);

~noteOnFunc = {
	arg src, chan, num, vel;
	var node;
	node = drums.at(chan);

	if (node.notNil, {
		node.release;
		drums.put(chan, nil);
	});

	case(chan,
		0, {node = Synth.tail(nil, ~sound0, [\volume,~volume0,
			\bass, ~bass0,
			\middle, ~middle0,
			\treble, ~treble0,
			\attack, ~attack0,
			\release, ~release0,
			\curve, ~curve0]);},
		1, {node = Synth.tail(nil, ~sound1, [\volume,~volume1,
			\bass, ~bass1,
			\middle, ~middle1,
			\treble, ~treble1,
			\attack, ~attack1,
			\release, ~release1,
			\curve, ~curve1]);},
		2, {node = Synth.tail(nil, ~sound2, [\volume,~volume2,
			\bass, ~bass2,
			\middle, ~middle2,
			\treble, ~treble2,
			\attack, ~attack2,
			\release, ~release2,
			\curve, ~curve2]);}
	);

	drums.put(chan, node);
};

MIDIIn.addFuncTo(\noteOn, ~noteOnFunc);

/** OSC interaction code **/
OSCdef('synth0', {
	arg msg;
	/** Assign the values in the msg to the global variables */
	/* of each drum pad synth*/
	~volume0 = msg[1];
	~bass0 = msg[2];
	~middle0 = msg[3];
	~treble0 = msg[4];
	~attack0 = msg[5];
	~release0 = msg[6];
	~curve0 = msg[7];
	~sound0 = ~sounds.at(msg[8]);

},"main/synth0");

OSCdef('synth1', {
	arg msg;
	/** Assign the values in the msg to the global variables */
	/* of each drum pad synth*/
	~volume1 = msg[1];
	~bass1 = msg[2];
	~middle1 = msg[3];
	~treble1 = msg[4];
	~attack1 = msg[5];
	~release1 = msg[6];
	~curve1 = msg[7];
	~sound1 = ~sounds.at(msg[8]);

},"main/synth1");

OSCdef('synth2', {
	arg msg;
	/** Assign the values in the msg to the global variables */
	/* of each drum pad synth*/
	~volume2 = msg[1];
	~bass2 = msg[2];
	~middle2 = msg[3];
	~treble2 = msg[4];
	~attack2 = msg[5];
	~release2 = msg[6];
	~curve2 = msg[7];
	~sound2 = ~sounds.at(msg[8]);

},"main/synth2");
)