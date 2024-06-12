("../Setup/Setup.scd").loadRelative;

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
	\instrument, \doubleBass,
	\scale,  Scale.zhi,
	\degree, Pn(Pshuf([0,2,5,7,9],4),inf),
	\octave, [5],
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

Pbindef(\p1).stop;
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













