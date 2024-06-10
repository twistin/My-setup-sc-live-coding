("../Setup/Setup.scd").loadRelative;
t = TempoClock.default.tempo_(120/60); // Ajusta el tempo si es necesario
s.options.sampleRate = 48100

// tempo
~tempo = 60/60 * 4;
s.options.sampleRate = 44100
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
)

(
~a =Pbind(
	\type, \midi,
	\dur, l,
	\midicmd,\noteOn,
	\midiout, m,
	\midinote, Pxrand(Scale.minorPentatonic.degrees+50,inf)+Prand([0,12,24], inf),
	\amp, 0.1,
	\sustein, 0.02

).play(t,quant:4);
)
~a.pause;
~a.resume;

s.options.sampleRate = 48000

(

	~b = Pbind(
		\instrument, \kick808,

		\dur, 2,
		\sus, 1,
		\amp, 1/2

	).play(t,quant:2);

)





(
l = Prewrite(1, // start with 1
        (    1: [0.25,2],
            0.25: [3,3,2]/4,
        3/4: [0.25,1,0.125,0.125],
        ), 4);
	~c = Pbind(
		\instrument, \snare1,

		\dur, 2.5,
		\sus, 1,
		\amp, 1/2

	).play(t,quant:2);

)

///////////////////////


(
p = ProxySpace(
	server: s.boot,
	clock: t = TempoClock(90/60).permanent_(true)
).push;
)



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
)






~nz = {Hasher.ar(LFClipNoise.ar(\nFr.kr(2500),1,\add.kr(3)))!2};
~a.play; ~a.awake_(false);
~a =  {MoogFF.ar(Saw.ar(\freq.kr(5000)*[1,1.008], Decay.kr(Impulse.kr(\trig.kr(10)), ~nz *0.001)),18000,0).tanh * Env([0,1,1,0],[\atk.kr(0.002), \sus.kr(0.1),\rel.kr(0.05)]).ar(2)*\amp.kr(0.1)};
~a.spawn;

~b.play; ~b.awake;
~b = {\k.kr(0) + SinOscFB.ar(XLine.kr(\freq.kr(500)*[1, \mod.kr(0.98499)],\freq.kr * [1, \mod.kr], \d.kr(0.0005)),\fb.kr(0)).mean.tanh !2 * Env([0,1,1,0], [\atk.kr(0.005), \sus.kr(0),\rel.kr(0.3) + \d.kr]).kr(2) * \amp.kr(0.2) +(\k.kr * LPF.ar(BrownNoise.ar([0.3,0.31]),[5000,6500]) * Env.perc(0.02,\rel.kr * 0.9, \cur.kr(-5)).ar(0))}


~c.play;~c.awake_(false);
~c = {LFPulse.ar(\freq.kr(80)*[1,\mod.kr(0.5)],SinOsc.kr(0.5).range(0, 2pi), 1,\amp.kr(0.7),\add.kr(100)) * Env([0,1,1,0], [\atk.kr(0.005), \sus.kr(0),\rel.kr(0.3) + \d.kr]).kr(2)}



~seq = Tdef(\seq, {
	loop{
	~a.spawn([\freq,10000]);
	1.wait;
	~a.spawn([\freq,5000, \atk,0.4]);
	0.5.wait;
    ~a.spawn([\freq,400]);
	1.wait;
	 ~a.spawn([\freq,1000]);
	0.25.wait;

	};
})


~mix = {~a+ ~b + ~c}


~seq1 = Tdef(\seq1, {
	loop{
	~b.spawn([\freq,10000]);
	1.wait;
	~b.spawn([\freq,5000, \atk,0.4]);
	0.5.wait;
    ~b.spawn([\freq,400]);
	1.wait;
	 ~b.spawn([\freq,1000]);
	0.25.wait;

	};
})

~seq2 = Tdef(\seq2, {
	loop{
	~c.spawn([\freq,80]);
	1.wait;
	~c.spawn([\amp,0.05, \freq, 1000]);
	0.25.wait;

	};
})

~seq2.play
~seq1.pause



////////////////////////////////////////////////


MIDIIn.connectAll;

m = MIDIOut.new(0);
m.latency = 0;


m.noteOn(0,60,64);
m.noteOff(0,60,64);


(
Routine.new({
	loop{
		var note;
		note = {rrand(30,90)};
		note.do({
			arg n;
			m.noteOn(0,n,30);
		});
			2.wait;
			note.do({
			arg n;
			m.noteOff(0,n);
		});
		1.wait;
		};


}).play;
)


m.noteOff(0, [87,63,36,54])
(
CmdPeriod.add({
(0..127).do({
	arg n;
	m.noteOff(0,n);

});
});
)






~seq =Tdef(\t0,{
	loop{
		var note;
		note = {Scale.majorPentatonic.degrees.choose+40+[0,12].choose+ 4}!4;
		note.do({
			arg n;
			m.noteOn(0,n,30);
		});
			0.2.wait;
			note.do({
			arg n;
			m.noteOff(0,n);
		});
		0.25.wait;
		};


}).play;


~seq.stop

~seq.resume



~seq1 =Tdef(\t1,{
	loop{
		var note;
		note = {Scale.minor.degrees.choose+40+[2,8].choose+10}!4;
		note.do({
			arg n;
			m.noteOn(0,n,30);
		});
			0.2.wait;
			note.do({
			arg n;
			m.noteOff(0,n);
		});
		0.25.wait;
		};


}).play;
~seq1.play
Main.elapsedTime;
TempoClock
t.elapsedBeats;
t.tempo

schedAbs




///   ProxySpace

(
p = ProxySpace.push(
	server: s.boot,
	clock: t= TempoClock(90/60).permanent_(true)
)
)
s.options.sampleRate = 48000

(
~a =Pbind(
	\type, \midi,
	\dur, 1/1,
	\midicmd,\noteOn,
	\midiout, m,
	\midinote, Pxrand(Scale.minorPentatonic.degrees+50,inf)+Prand([0,12,24], inf),
	\amp, 0.4,
	\sustein, 0.02

).play(t,quant:4);
)


~a.pause;
~a.play;


~sig = Pbindef(\p0).play(t,quant:4)

~mix = {Pbindef(\p1)}
~sig.stop



/////////////////////////////////////////////
/////////////////////////////////////////////
/// Controlando sculpture Logic desde SC ////
////////////////////////////////////////////
////////////////////////////////////////////
(
Pbindef(\p0,
	\type, \midi,
	\dur, 1/4,
	\midicmd,\noteOn,
	\midiout, m,
	\midinote, Pxrand(Scale.minorPentatonic.degrees+50,inf)+Prand([0,12,24], inf),
	\amp, 0.1,
	\sustein, 0.02

).quant_(4);
)
(
Pbindef(\p1,
	\type, \midi,
	\dur, 1/4,
	\midicmd,\control,
	\midiout, m,
	\chan, 0,
	\ctlNum, 20,
	\control, Pseq((0..127).mirror, inf),

).quant_(4);
)

Pbindef(\p0).play(t,quant:4)
Pbindef(\p0).stop
Pbindef(\p0).pause
Pbindef(\p0).resume
Pbindef(\p1).play
Pbindef(\p1).stop
Pbindef(\p1).pause
Pbindef(\p1).resume

m.control(0,20,rrand(0,122));

/////////////////////////////////////////////
/////////////////////////////////////////////
/// Controlando sculpture Logic desde SC ////
////////////////////////////////////////////
////////////////////////////////////////////




(
~a =Pbindef(\p1,
	\type, \midi,
	\dur, 1/12,
	\midicmd,\control,
	\midiout, m,
	\chan, 0,
	\ctlNum, 20,
	\control, Pseq((0..127).mirror, inf),

).quant_(4);
)

Pbindef(\p1).play
Pbindef(\p1).stop





