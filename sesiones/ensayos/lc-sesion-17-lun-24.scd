("../Setup/Setup.scd").loadRelative;
m.noteOn(6,56,64)

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
~l = Pbindef(\p0,
	\type, \midi,
	\midicmd,\noteOn,
	\dur, 1/4,
	\amp, 0.5,
	\freq, Pwhite(80,120,inf),
	\midiout,m,
	\chan,0,
	\sustain, 0.02,
	\midinote, Pxrand(Scale.minorPentatonic.degrees+50)+Prand([0,12,24],inf)
).play
)


~l.play





t = p.clock.tempo_(120/60);
~b1[0] = Pbind(
	\instrument, \blip1,
	\scale,  Scale.yu,
	\degree, Pn(Pshuf([0,3,5,7,10],4),inf),
	\octave, [2],
	\dur, Pseq([0.25,0.25,0.50,1], inf),
	\amp, 0.2,
	\level, 1.5,
	\atk, 0,
	\sus, 0,
	\rel, 0.75,
	\curve,-6,
	\pan,0
)


~b1.play;
~b1.pause;
~mix = {}

~b1[1] = \filter -> { |in| in.clip};
~b1[2] = \filter -> { |in| in*Saw.ar(150*[100,0.9995])};

~b1[3] = \filter -> { |in| CombL.ar(in, 0.08, 0.07,2.5)};

~b1.set(\wet1,0.0);
~b1.set(\wet2,0.0);
~b1.set(\wet3,0.0);



t = p.clock.tempo_(60/60);
~g1[0]= Pbind(
	\instrument, \chaosGlitch2,
	\dur, Pseq([0.25,0.25,0.50,1], inf),
	\len, Pseq([1, 1.5, 1.75, 2]+10,inf),
	\henA, Pseq([2, 1.3, 1.29, 1.25], inf),
	\henB, Pseq([0.2, 0.3], inf),
	\t, Pseq([2, 4, 2, 6], inf),
	\fundFreq, Pseq([40, 600, 8000, 200, 600, 6000], inf),
	\amp,0.1
)
~g1.play;
~g1.resume
~g1.pause
~g1[1] = \filter -> { |in| in.clip};
~g1[2] = \filter -> { |in| in*SinOsc.ar(150*[100,0.9995])};

~g1[3] = \filter -> { |in| GVerb.ar(in, 0.08, 0.07,2.5,maxroomsize:1000,roomsize:100)};
~mix = {~g1}
~g1.set(\wet1,1.0);
~g1.set(\wet2,0.0);
~g1.set(\wet3,0.0);


[Synth(\plucking), Synth(\plucking)]
~m1 = Pbind

	\instrument, \plucking,
	\scale, Scale.yu,
	\octave, 4,
	\degree, Pseq([0, 3, 5, 7, 10], inf), // four main notes
	\mtranspose, Pseq([Pseq([0],3),Pseq([-5],3)],inf), // switched mode every 3 notes (*2)

	\gtranspose, Pseq([Pseq([0],36),Pseq([4],36),Pseq([[-3]],36),Pseq([2],36)],inf),
	\ctranspose, Pser([Pseries(-4,1,6) +.x Pseq([0], 144)],1),

	\coef, Pser([Prand([0.2,0.3,0.4,0.5],1), Prand([0.8,0.7,0.6,0.5],11)], inf),
	\dur, Prand([0.25,0.26,0.24,0.255,0.255,0.25], inf) * 0.9,
	\decay, Prand([1,2,3,4,5], inf),
	\out, b,
	\amp, 0.4,
)



~m1.play;
~m1.resume
~m1.pause
~m1.stop
~m1[1] = \filter -> { |in| in.clip};
~m1[2] = \filter -> { |in| in*SinOsc.ar(150*[100,0.9995])};

~m1[3] = \filter -> { |in| GVerb.ar(in, 0.08, 0.07,2.5,maxroomsize:1000,roomsize:100)};
~mix = {~m1}
~m1.set(\wet1,1.0);
~m1.set(\wet2,0.0);
~m1.set(\wet3,0.0);



d["china"][4].numChannels
∫

(

~c = Pbind(
	\instrument,\simplebuf,
	\buf, d["china"][4],
	\dur, Pseq([0.25,0.25,0.50,1], inf),
	\amp,1,
	\rate,1,
	\atk,6,
	\sus, 6,
	\rel,6
)
)
~c.play
~c.resume
~c.pause

(
SynthDef(\play,{
	arg buf;
	var sig,env;
	env = Env(
		levels:[0,1,0],
		times: [\atk.ir(0.001),\rel.ir(0.5)],
		curve:[2,-2]
		).ar(2);
	sig = PlayBuf.ar(
		numChannels:1,
		bufnum:buf,
		rate: BufRateScale.ir(buf)*\rate.kr(1)*
		SinOsc.kr(6).bipolar(0.5).midiratio,
		loop:\loop.kr(1)
	);
	sig = Pan2.ar(sig, \pos.kr(0));
	sig = sig * env;
	sig = sig * \amp.kr(0.5);
	Out.ar(\out.ir(0),sig);
}).add
)

Synth(\play,[\buf, d["china"][1]])

(
~p = Pbind(
	\instrument, \play,
	\buf,d["china"][6],
	\dur, 6,
	\rate, 1,
	\amp,1,
	\atk,5,
	\rel,5,
	\bufnum, d["china"][0],
	\loop,1
)
)
~p.play
~p.resume


~p1.play
~p1.pause
(
~p1 = Pbind(
	\instrument, \play,
	\buf,d["china"][4],
	\dur, Pseq([1/4,1/4,1],inf),
	\rate, Pwhite(0.5,1.0,inf),
	\amp,1,
	\atk,0.9,
	\rel,0.5,
	\bufnum, d["china"][0],
	\loop,1
)
)


~g3 = Pbind(
	\instrument, \bufsynth,
\buf, Pxrand(d['glitch2'], inf),
	\dur, 1/2,
	\rate, Pwhite(0.5,1.5,inf),
	\amp, Pwhite(0.4,1.0,inf),
	\atk, 0.05,
	\sus, 0.04,
	\rel, 0.005
)

~g3 = Pbind(
	\instrument, \bufsynth,
	\buf, Pxrand(d["glitch2"], inf),
	\dur, 1/2,
	\rate, Pwhite(0.5,1.5,inf),
	\amp, Pwhite(0.4,1.0,inf),
	\atk, 0.05,
	\sus, 0.04,
	\rel, 0.005
)

~g3.play
4s
~k.play
~k = Pbind(\instrument,\bufsynth,
	\buf,d["k"][2],

	\dur,1,
	\amp,1);
t = p.clock.tempo_(110/60);
~sn.stop
~b1 = Pbind(
	\instrument, \blip1,
	\scale,  Scale.yu,
	\degree, Pn(Pshuf([0,3]*2,4),inf),
	\octave, [2],
	\dur, 1/2,//Pseq([0.25], inf),
	\amp, 0.2,
	\level, 1.5,
	\atk, 0,
	\sus, 0,
	\rel, 0.75,
	\curve,-6,
	\pan,0
)
~b1.play