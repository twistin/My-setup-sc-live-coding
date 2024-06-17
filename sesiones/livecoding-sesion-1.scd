("../Setup/Setup.scd").loadRelative;

t = p.clock.tempo_(60/60);


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



~off = Tdef(\off,{
	~t3.stop;
	4.wait;
	~r1.stop;
	6.wait;
	~m2.stop;
	4.wait;
	~g5.stop;
	2.wait;
	~b3.stop;
	4.wait;
	~d3.stop;
	6.wait


})

~t3 = Pbind(
	\instrument, \bpfsaw,
	\dur, 5,
	\midinote, Pxrand([
		[72.0, 76.99999999998,  80.999999999964, 88.99999999998, 92.999999999964]-24,
		[72.0, 76.99999999998, 80.999999999964, 88.99999999998, 92.999999999964]+9,
		[72.0, 76.99999999998, 80.999999999964, 88.99999999998, 92.999999999964 ]+4,
		[72.0, 76.99999999998, 80.999999999964, 88.99999999998,92.999999999964 ]-12,
	]-12,inf),
	\detune, 0.08,
	\cfmin,100,
	\cfmax, 1500,
	\atk,2,
	\rel,8,
	\ldb, 6,
	\amp,0.7,
	\out,0
)

~t3.play

~r1 = Pbind(
		\instrument, \bufsynth,

	\buf, Pxrand(d["glitch2"],inf),
		\dur, 1/4,
		\rate, Pwhite(1.0,5.0,inf),
		\spos,0,
		\amp, 1,
		\atk, 0,
		\sus, Pwhite(0.0,0.15),
		\rel, 0.01,
		\cur,1,
		\pan, Prand([-1,0, 1],inf)

)

~r1.play

~mix = {}

~m2 = Pbind(

	\instrument, \plucking,
	\scale, Scale.zhi,
	\octave, 4,
	\degree, Pseq([ 0, 2, 5, 7, 9 ], inf),
	\mtranspose, Pseq([Pseq([0],3),Pseq([-5],3)],inf),

	\gtranspose, Pseq([Pseq([0],36),Pseq([4],36),Pseq([[-3]],36),Pseq([2],36)],inf),
	\ctranspose, Pser([Pseries(-4,1,6) +.x Pseq([0], 144)],1),

	\coef, Pser([Prand([0.2,0.3,0.4,0.5],1), Prand([0.8,0.7,0.6,0.5],11)], inf),
	\dur, 1,//Prand([0.25,0.26,0.24,0.255,0.255,0.25], inf) * 0.9,
	\decay, Prand([1,2,3,4,5], inf),
	\out, b,
    \amp, 0.6,
)

~m2.play


~b3= Pbind(
	\instrument, \rubberBand,
	\scale,  Scale.gong,
	\degree, Pn(Pshuf([0,2,4,7,9],4),inf),
	\octave, [2],
	\dur, Pseq([1], inf),
	\amp, 0.09,
	\level, 1.5,
	\atk, 0,
	\sus, 0.1,
	\rel, 0.75,
	\curve,-6,
	\pan,0
)
~b3.play

~g5 = Pbind(
	\instrument, \pbufs,
	\buf, Pxrand(d["pajaros"], inf),
	\dur, 1/2,
	\rate, Pwhite(0.5,1.5,inf),
	\amp, Pwhite(0.4,1.0,inf),
	\atk, 2,
	\sus, 2,
	\rel, 0.5
)
~g5.play


~r = {54};
~dfm1 = {arg mult = 1; DFM1.ar(SinOsc.ar([~r,~r*1.01]*mult,0,0.1),(~r*2)*mult,SinOsc.kr(0.05).range(0.9,1.1),1,0,0.0003,0.5)};
~dfm2 = {arg mult = 2; DFM1.ar(SinOsc.ar([~r,~r*1.01]*mult,0,0.1),(~r*2)*mult,SinOsc.kr(0.06).range(0.9,1.1),1,0,0.0003,0.5)};
~dfm3 = {arg mult = 3; DFM1.ar(SinOsc.ar([~r,~r*1.01]*mult,0,0.1),(~r*2)*mult,SinOsc.kr(0.056).range(0.9,1.1),1,0,0.0003,0.5)};
~dfm4 = {arg mult = 4; DFM1.ar(SinOsc.ar([~r,~r*1.01]*mult,0,0.1),(~r*2)*mult,SinOsc.kr(0.07).range(0.9,1.1),1,0,0.0003,0.5)};
~dfm5 = {arg mult = 4;DFM1.ar(SinOsc.ar([~r, ~r*1.02] * mult, 0, 0.1),(~r * 1.5) * mult,SinOsc.kr(0.1).range(0.8, 1.2),1,0,0.0004, 0.6)};
~dfm6 = {arg mult = 4;DFM1.ar(Pulse.ar([~r, ~r*1.03] * mult, 0.5, 0.1),(~r * 2.5) * mult,LFTri.kr(0.05).range(0.7, 1.3),1,0,0.0002,0.4)};
);
~dfm1.play;~dfm2.play;~dfm3.play;~dfm4.play;~dfm5.play;~dfm6.play

~dfm1.stop;~dfm2.stop;~dfm3.stop;~dfm4.stop;~dfm5.stop;~dfm6.stop







Pbind(
	\instrument, \bpfsaw,
	\dur, 5,
	\midinote, Pxrand([
		[72.0, 78.999999999972, 84.0, 88.99999999998, 96.0 ],
		[72.0, 78.999999999972, 84.0, 88.99999999998, 96.0 ]+9,
		[72.0, 78.999999999972, 84.0, 88.99999999998, 96.0 ]+4,
		[72.0, 78.999999999972, 84.0, 88.99999999998, 96.0 ],
	]-12,inf),
	\detune, 0.08,
	\cfmin,100,
	\cfmax, 1500,
	\atk,2,
	\rel,8,
	\ldb, 6,
	\amp,0.2,
	\out,0
)
(
~midiPattern = Pbind(
    //specifies type of message sent
    \type, \midi,
    //specifies type of midi message
    \midicmd, \noteOn,
    //the MIDI Out used
    \midiout, d[\m],
  //the MIDI channel
    \chan, 0,
    //The rest of the pattern
    \scale,Scale.minor,
    \degree, Pseq([0,2,4],inf),
    \octave, 3,
    \dur, 0.5,
    \legato, 0.4
)
)

~midiPattern.play


Scale.directory

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
~note[0] = Pbind(
	\instrument, \blip1,
	\scale,  Scale.yu,
	\degree, Pn(Pshuf([0,2,5,7,9],4),inf),
	\octave, [2],
	\dur, Pseq([0.25], inf),
	\amp, 0.2,
	\level, 1.5,
	\atk, 0,
	\sus, 0,
	\rel, 0.75,
	\curve,-6,
	\pan,0
)
)

~note.play(fadeTime:2);
~note.stop;
~note.resume;

~note[1] = \filter -> {|in| in* SinOsc.ar(150*[1,0.995])};
~note[2] = \filter -> {|in| in.clip};
~note[3] = \filter -> {|in| CombL.ar(in, 0.08, 0.07, 2.5)};

~note.set(\wet1, 0)
~note.set(\wet2, 0.5)
~note.set(\wet3, 0)

(
~a = Pbindef(\p0,
	\type, \midi,
	\dur, 1/12,
	\midicmd, \noteOn,
	\midiout, m,
	\chan, 0,
	\midinote, Pseq([38,38, 50], inf)+Prand([19,7,3,0],inf)+12,
	\amp,0.02,
	\sustain, 0.02,

).quant_(4);
)


Pbindef(\p0).stop;
Pbindef(\p0).clear;

m.control(0,20, rrand(0,127));
Pbindef(\p1).play(t,quant:4);


(
~b = Pbindef(\p1,
	\type, \midi,
	\dur, 1/12,
	\midicmd, \control,
	\midiout, m,
	\chan,0,
	\ctlNum,20,
	\control, Pwhite(0,127,inf),

).quant_(4);
)

Pbindef(\p1).play;
Pbindef(\p1).clear;



(
~out = Tdef(\out, {
	2.do({
		~note.stop;
		4.wait;
		~a.stop;
		2.wait;
		~b.stop;


	});
})
)
~out.play













