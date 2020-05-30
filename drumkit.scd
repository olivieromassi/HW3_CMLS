s.boot;

MIDIClient.init;
MIDIIn.connectAll;

NetAddr("127.0.0.1", 57120);

(
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

/** OSC interaction code **/
OSCdef('OSCreceiver', {
	arg msg;
	/** Assign the values in the msg to the global variables */
	/* of each drum pad synth*/
},"main/synth0")

OSCdef('OSCreceiver', {
	arg msg;
	/** Assign the values in the msg to the global variables */
	/* of each drum pad synth*/
},"main/synth1")

OSCdef('OSCreceiver', {
	arg msg;
	/** Assign the values in the msg to the global variables */
	/* of each drum pad synth*/
},"main/synth2")
)
