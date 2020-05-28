s.boot;

MIDIClient.init;
MIDIIn.connectAll;

NetAddr("127.0.0.1", 57120);

(
/** MIDI interaction code **/
var drums;
drums = Array.newClear(3);

~noteOnFunc = {
	arg src, chan, num, vel;
	/**Complete function with the necessary code*/
};

MIDIIn.addFuncTo(\noteOn, ~noteOnFunc);

/**Still not clear if necessary */
~noteOffFunc = {
	arg src, chan, num, vel;
	/**Complete function with the necessary code*/
};

MIDIIn.addFuncTo(\noteOff, ~noteOffFunc);


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