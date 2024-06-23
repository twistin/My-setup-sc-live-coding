// tempo
t = p.clock.tempo_(120/60);
////////
("../Setup/Setup.scd").loadRelative;


// 泰泰泰泰泰泰泰泰泰 SEGUNDA PIEZA: Tài 泰泰泰泰泰泰泰泰泰泰泰 //

////////////////  1 //////////////////
m.noteOn(0,60,64)

//escoger el sonido en Logic-Midi GuzHeng AU

(
~a= Pbind(
    \type, \midi,
    \midicmd, \noteOn,
	\midiout, m,
    \chan, 0,
	\midinote, Pxrand(Scale.minorPentatonic.degrees+50,inf)+ Prand([0,12,24],inf),
	\octave, 3,
	\dur, 1/4,
	\legato, 0.1,
	\sustain,0.02,
	\amp, -10.dbamp

)
)

~a.play
~a.resume
~a.pause





///////////////  2 //////////////////
(
SynthDef(\paulstretchMono, { |out = 0, bufnum, envBufnum, pan = 0, stretch = 50, window = 0.25, amp = 0.2|

	// amp: amplification
	var trigPeriod, sig, chain, trig, pos, fftSize;
	// Calculating fft buffer size according to suggested window size
	fftSize = 2**floor(log2(window*SampleRate.ir));
	// Grain parameters
	// The grain is the exact length of the FFT window
	trigPeriod = fftSize/SampleRate.ir;
	trig = Impulse.ar(1/trigPeriod);
	pos = Demand.ar(trig, 0, demandUGens: Dseries(0, trigPeriod/stretch));
	// Extraction of 2 consecutive grains
	// Both grains need to be treated together for superposition afterwards
	sig = [GrainBuf.ar(1, trig, trigPeriod, bufnum, 1, pos, envbufnum: envBufnum),
		GrainBuf.ar(1, trig, trigPeriod, bufnum, 1, pos + (trigPeriod/(2*stretch)), envbufnum: envBufnum)]*amp;
	// FFT magic
	sig = sig.collect({ |item, i|
		chain = FFT(LocalBuf(fftSize), item, hop: 1.0, wintype: -1);
		// PV_Diffuser is only active if its trigger is 1
		// And it needs to be reset for each grain to get the smooth envelope
		chain = PV_Diffuser(chain, 1 - trig);
		item = IFFT(chain, wintype: -1);
	});
	// Reapply the grain envelope because the FFT phase randomization removes it
	sig = sig*PlayBuf.ar(1, envBufnum, 1/(trigPeriod), loop:1);
	// Delay second grain by half a grain length for superposition
	sig[1] = DelayC.ar(sig[1], trigPeriod/2, trigPeriod/2);
	// Panned output
	Out.ar(out, Pan2.ar(Mix.new(sig), pan));
}).add;
)

// Example
({
	var envBuf, envSignal, buffer;
	buffer = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
	// The grain envelope
	envBuf = Buffer.alloc(s, s.sampleRate, 1);
	envSignal = Signal.newClear(s.sampleRate).waveFill({|x| (1 - x.pow(2)).pow(1.25)}, -1.0, 1.0);
	envBuf.loadCollection(envSignal);
	s.sync();
	// Runs indefinitely
	Synth(\paulstretchMono, [\bufnum, buffer.bufnum, \envBufnum, envBuf.bufnum]);
}.fork;
)


///////////////  3 //////////////////
~b1.play
~b1[0] = Pbind(
	\instrument, \subBass2,
	\scale,  Scale.chromatic,
	//\degree, Pn(Pshuf([0,12,24],4),inf),
	\midinote, Pxrand(Scale.minorPentatonic.degrees+50,inf)+ Prand([0,12,24].stutter(2),inf),
	//\octave, [2],
	\dur, Pseq([0.25].stutter(2), inf),
	\amp, 0.1,
	\level, 1.5,
	\att, 0.05,
	\sus, 0.05,
	\rel, 0.5,
	\curve,6,
	\pan,Pxrand([-1,1,0.5],inf),
	\blend, 1,
	\iphase,Pxrand([-1,1,0.5],inf)
)

//////////////////////// controles /////////////////////

            ///////////  reverb ///////////

(
~mix.ar;
(
~verb = {
	XFade2.ar(
		LPF.ar(
			GVerb.ar(
				~mix.ar(1), 80,8, maxroomsize:1000),
			8500
		),
		~mix, \pan.kr(0,0.5),\rel.kr(0.15)
	)
};
~verb.play;
)
);


///////////////////////////////////////////////////////////
~mix = {  ~a}
~mix = 0

/////////////////////////////////////////////////////////

~a[1] = \filter -> {|in|  in.clip};
~b1[2] = \filter -> {|in|  in *SinOsc.ar(150*[1,0.995])};
~b1[3] = \filter -> {|in|  LPF.ar(in,freq:600, mul:1, add:0)};
~b1[4] = \filter -> {|in|  CombL.ar(in,maxdelaytime:0.2,delaytime:0.07,decaytime:1)};
~b1[5] = \filter -> {|in|  RLPF.ar(in,freq:500,rq:0.07,mul:0.8)};
~b1[6] = \filter -> {|in|  MoogFF.ar(in,freq:500,gain:0.07,reset:0,mul:1,add:0)};
~b1[7] = \filter -> {|in|  GVerb.ar(in,roomsize:10,revtime:3,damping:0.5,inputbw:0.5,spread:15,drylevel:1,earlyreflevel:0.7, taillevel:0.5,maxroomsize:300,mul:1,add:0)};
~a[7] = \filter -> {|in|  GVerb.ar(in,roomsize:10,revtime:3,damping:0.5,inputbw:0.5,spread:15,drylevel:1,earlyreflevel:0.7, taillevel:0.5,maxroomsize:300,mul:1,add:0)};

~b1.set(\wet1,0);
~b1.set(\wet2, 0);
~b1.set(\wet3, 0);
~b1.set(\wet4, 0);
~b1.set(\wet5,0);
~b1.set(\wet6, 0);
~b1.set(\wet7, 0);
~a.set(\wet7, );







//////////////////////////////////////////////////////////////////





~off = Tdef(\off, {
	~a.stop;
	4.wait;
	~b.stop;
	4.wait;
	~c.stop;
	4.wait;
	~d.stop;
	4.wait;


});

~off.play;

~mix={};






