(
// Vibrato Synth Deffinition
SynthDef(\vibrato_Synth, { |out, freqBase, freqBPM, modulation, depthBase, depthBPM, bandPassStrong, bandPassQuality, sinePower, squarePower, sawthothPower|
	/*
	out: Channel for Output

	freqBase: Original Key to play
	freqBPM: Frequency of the BandPass

	modulation: Frequency of Modulation
	depthBase: Frequency Range for Vibrato Source
	depthBPM: Frequency Range for Vibrato the BandPass

	bandPassStrong: Ratio of BandPassed Signal in Result

	sinePower: Power of the Sinusidal Source
	squarePower: Power of the square Source
	sawthothPower: Power of the Sawthoth Sorce
	*/

	// Variable Declarations
	var sig, sigdry, sigwet, // Signals; Master Signal. Signaldrye, SignalWet
	sine, square, sawthoth, // Intermediated Signals: Sine- Square- Sawthoth- -Signal
	mod1, mod2; // Modulation Signals: Original Vibrato, BandPass Vibrato

	// Modulation Sorces
	// Vibrato Modulation
	mod1 = SinOsc.kr(modulation, 0, depthBase);
	// BandPass Modulation
	mod2 = SinOsc.kr(modulation, 0, depthBPM);

	// Signal Sources with master Frequency and Modulation and Power of Source
	// For Sine
	sine = SinOsc.ar(freqBase+mod1, 0, sinePower);
	// For Square
	square = Pulse.ar(freqBase+mod1, 0, squarePower);
	// for Sawthoth
	sawthoth = Saw.ar(freqBase+mod1, sawthothPower);

	// Mixing of the Sources
	sig = ( sine + square + sawthoth);

	// BandPass Modulation Unit
	// BayPass of dry Signal
	sigdry = sig * (1-bandPassStrong);
	// BandPass Function with Frequency and Modulatrion and Quality of Filtering and Power of Signal
	sigwet =       BPF.ar(sig, freqBPM+mod2, bandPassQuality, bandPassStrong);
	// ReCreating the Final Signal
	sig = sigdry + sigwet;
	// Output the final Signal
	Out.ar(out, sig);
}).add;
)

// Test Call for the Vibrato Synth
x = Synth(\vibrato_Synth, [freqBase: 440, freqBPM: 440, modulation: 0.3, depthBase: 0, depthBPM: 100, bandPassStrong: 0.7 , bandPassQuality: 0.1]);
x.free;

// Function to Change the Sound Color
// For Parameters see the SynthDef of the Vibrato Synth
(
~instrumental = {
	~modulation = rrand(0.3, 16);
	~bandPassStrong = rrand(0, 1);
	~bandPassQuality = rrand(0.001, 0.25);
	~sinePower = rrand(0, 1);
	~squarePower = rrand(0,1);
	~sawthothPower = rrand(0,1);
}
)

// Function to call the Vibrato Synth
(
~vib = { arg pitch, diff;
	/* Input of the Master FRequency and the Width of the Vibrato */
	// Variable Declaration for the Actual KeyPitch and the Frequency of the BandPass FRequency
	var keypitch, freqBPM;
	// Choosing a actual KeyPoitch by addition and substraction of the Width for the Master Vibration
	keypitch = pitch + (diff*(rrand(-1, 1).round(1)));
	// Choosing the Frequency for the BandPass Unit
	freqBPM = rrand(keypitch, 10000);
	// Call a mostly randomised Vibrato Synth and mark it at ~x
	~x = Synth(\vibrato_Synth,  [freqBase: keypitch, freqBPM: freqBPM, modulation: ~modulation, depthBase: rrand(0, keypitch), depthBPM: rrand(1, rrand(0.25, freqBPM)), bandPassStrong: ~bandPassStrong ,bandPassQuality: ~bandPassQuality, sinePower: ~sinePower, squarePower: ~squarePower, sawthothPower: ~sawhothPower]);
}
)

(
// Declaration of the Routine to Play the Melody of the Vibrato Synth
r = Routine {
	/* Declration of the Variables for
	pitch : Master Pitch of the Melody
	diff : Choosing width of the Melodic Vibrato
	vibLoop: Choosing Events in the Melodic Vibration
	duratio: Calculatd Time for each Event in the Melodic Vibration*/
	var pitch, diff, keypitch, vibLoop, loopDuration, duration;

	// Set Pitch for Beginning to default 440 Hz
	pitch = 440;

	// Beginn endles loop
	while {true}{
		// Choose a LoopDuration
		loopDuration = rrand(0.5, 3);
		// Make a new Quint Interval for the Master Pitch
		pitch = [ pitch*2/3, pitch*3/2].choose;
		pitch = max(min(pitch, 10000),40);
		// Choose a Vibrato Difference between minimal and a Third Interval
		diff = rrand(0.1, 0.3)*pitch;
		// Choose the lenght of the actual Vibrato Figure
		vibLoop = rrand(1, 7).round(1);
		// Calculate the Duration for each Event in the Vibrato Figure
		duration = loopDuration / vibLoop;

		// Iterate about the Events in the Vibrato Figure
		for(1, vibLoop){
			// Call the Function to call the Vibrato Synth
			~vib.value(pitch, diff);
			// Wait for the Duration of the Event
			duration.wait;
			// Remove the played Synth
			~x.free;
		}
	}
};
);

// Play the Ornamentic Synth System
r.play;
r.stop;
~instrumental.value();