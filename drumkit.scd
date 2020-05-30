s.boot;
s.quit;

MIDIClient.init;
MIDIIn.connectAll;

NetAddr("127.0.0.1", 57120);

(
<<<<<<< HEAD
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

~sounds = Array.with('\kick', '\snare', '\hh', '\htom', '\mtom', '\ltom');

/** MIDI interaction code **/

drums = Array.newClear(3);

~noteOnFunc = {
	arg src, chan, num, vel;
	node = drums.at(chan);

	if (node.notNil, {
		node.release;
		drums.put(chan, nil);
	});

	case(chan,
		0, {node = Synth(~sound0);},
		1, {node = Synth(~sound1);},
		2, {node = Synth(~sound2);}
	);

	drums.put(chan, node);
};

MIDIIn.addFuncTo(\noteOn, ~noteOnFunc);
=======
/** MIDI interaction code **/

MIDIFunc.noteOn({
	arg veloc, num, chan, src;
	d = case
	{chan==0}{\cassa}
	{chan==1}{\snare}
	{chan==2}{\hh}
	{chan==3}{\Htom}
	{chan==4}{\Mtom}
	{chan==5}{\Ltom};

	Synth(d);
	//d.postln
});
>>>>>>> f0ef1441185407719b0336ab514b86df1d8f650c

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
<<<<<<< HEAD
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
=======
},"main/synth2")
)
>>>>>>> f0ef1441185407719b0336ab514b86df1d8f650c
