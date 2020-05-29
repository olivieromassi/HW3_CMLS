s.quit
s.boot


// fonti https://www.academia.edu/8141732/Drum_Sound_Analysis_Recognition_and_Differentiation_of_Drum_Sounds_as_Extension_to_the_E-Learning_Platform_Easydrum
//Generic envelope that can be applied to every sound;
(
var attackTime, decayTime, sustainLevel, releaseTime,curve;
var env = Env.adsr(attackTime, decayTime, sustainLevel, releaseTime,1.0,curve);
// EnvGen.kr(env, doneAction: Done.freeSelf)

)
//CASSA


(
SynthDef.new("cassa", {
    arg  n=0.8, nl = 0.008, start=80, end=15, l1=0.2, l2=0.2, exp=0.8;
    var boom;
    e = pow(Line.ar(0.9,0,l2),exp);

    boom = BBandPass.ar(WhiteNoise.ar(),freq:Line.ar(100,20,nl))*Line.ar(1,0,nl)*n+
    SinOsc.ar(Line.ar(start, end, l1))*e;
    Out.ar(0,[boom,boom])

}).add;
)

x=Synth.new("cassa")

//rullante

(
SynthDef(\snare, {
    var snd;
    // a percussive click to give it some attack
    snd = LPF.ar(HPF.ar(WhiteNoise.ar, 350), 8000) * Env.linen(0.001, 0.01, 0.001).ar;
    // sine sweep body. very important!
    snd = snd + (SinOsc.ar(Env([400, 200, 6], [0.01, 0.1], \exp).ar) * Env.perc(0.04, 0.3).ar * 6.dbamp).tanh;
    // sound of snare coils rattling
    snd = snd + (HPF.ar(BPeakEQ.ar(WhiteNoise.ar, 4000, 0.5, 3), 300) * Env.perc(0.05, 0.4).delay(0.01).ar(2) * -3.dbamp);
    // another sound sweep to improve the attack, optional
    snd = snd + (SinOsc.ar(XLine.kr(350, 215, 0.01)) * Env.perc(0.001, 0.02).ar);
    // distortion helps glue everything together and acts as a compressor
    snd = (snd * 1.4).tanh;
    snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1));
    Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\snare, [amp: 0.4]);


// high tom
(
SynthDef(\Htom, {
    var snd;
    // a percussive click to give it some attack
    snd = LPF.ar(HPF.ar(WhiteNoise.ar, 300), 8000) * Env.linen(0.001, 0.01, 0.001).ar;
    // sine sweep body. very important!
    snd = snd + (SinOsc.ar(Env([400, 300, 1], [0.001, 1], \exp).ar) * Env.perc(0.01, 0.15).ar * 2.dbamp).tanh;
    // sound of snare coils rattling
    snd = snd + (HPF.ar(BPeakEQ.ar(WhiteNoise.ar, 10, 0.5, 3), 0.03) * Env.perc(0.005, 0.2).delay(0.01).ar(2) * -3.dbamp);
    // another sound sweep to improve the attack, optional
    snd = snd + (SinOsc.ar(XLine.kr(3000, 1500, 0.01)) * Env.perc(0.001, 0.02).ar);
    // distortion helps glue everything together and acts as a compressor
    snd = (snd * 1.4).tanh;
    snd = Pan2.ar(snd, \pan.kr(0), \amp.kr(0.1));
    Out.ar(\out.kr(0), snd);
}).add;
)

Synth(\Htom, [amp: 0.4]);
//middle tom
(
SynthDef("Mtom", {
    arg startPitch = 200, endPitch=60, clickLevel=0.7, pitchRel = 0.27, noiseLevel=1, noiseRel= 0.3;
    var pitchEnv = EnvGen.ar(Env.perc(0.01, pitchRel));

    var clickOsc = SinOsc.ar(pitchEnv*(startPitch-endPitch)+endPitch);
    var clickEnv = EnvGen.ar(Env.perc(0.001, pitchRel))*clickLevel;
    var noiseOsc = PinkNoise.ar();
    var noiseEnv = EnvGen.ar(Env.perc(0.01, noiseRel))*noiseLevel;
    var snd =  noiseOsc * noiseEnv +clickOsc *clickEnv;
    Out.ar(0,Pan2.ar(snd, 0, 1));
}).add;
)
//Low tom
(
SynthDef("Ltom", {
    arg startPitch = 155, endPitch=60, clickLevel=0.7, pitchRel = 0.4, noiseLevel=1, noiseRel= 0.3;
    var pitchEnv = EnvGen.ar(Env.perc(0.01, pitchRel));

    var clickOsc = SinOsc.ar(pitchEnv*(startPitch-endPitch)+endPitch);
    var clickEnv = EnvGen.ar(Env.perc(0.001, pitchRel))*clickLevel;
    var noiseOsc = PinkNoise.ar();
    var noiseEnv = EnvGen.ar(Env.perc(0.01, noiseRel))*noiseLevel;
    var snd =  noiseOsc * noiseEnv +clickOsc *clickEnv;
    Out.ar(0,Pan2.ar(snd, 0, 1));
}).add;
)


Synth(\snare, [amp: 0.4]);
Synth(\Htom, [amp: 0.4]);
Synth.new("Mtom")
x=Synth.new("Ltom")
x=Synth.new("bd")



//hihat

(
SynthDef("hh", {
	arg noiseRel = 0.5, noiseLevel=0.6, ffreq=10000, q=(-4);
    var noiseOsc = BBandPass.ar(PinkNoise.ar(), ffreq, 0.2);
    var noiseEnv = EnvGen.ar(Env.perc(0.001, noiseRel, noiseLevel, q));

	var son,snd;
	son = Klank.ar(`[
		[1400, 7000, 4900, 3800, 700, 5500,7900, 7320, 9340],  // freqs
		[0.25,0.2,0.15,0.1, 0.1, 0.1,0.1, 0.1, 0.1],// amps
		[0.2, 0.2, 0.2,0.2, 0.2, 0.2,0.4, 0.4, 0.5]   // ring times
		],
	Impulse.ar(1));

    snd = son*0.02+noiseOsc * noiseEnv * 2;
    Out.ar(0,Pan2.ar(snd*4, 0, 1));
}).add;
)
x = Synth.new("hh")
