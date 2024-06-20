p = ProxySpace.push(
	server: s.boot,
	clock: t = TempoClock(60/60).permanent_(true)
);
("../Setup/synthdefs.scd").loadRelative;

("../Setup/Setup.scd").loadRelative;
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




t = TempoClock(60/60).permanent_(true)

(
~rythm[0] = (
	Pbind(
		\instrument, \bufsynth,
		//\index, Pseq((0..15),inf).stutter(3),
		\buf, ( d["glitch2"]).choose, //Pfunc({|s| b.glitch2[s.index]}),
		\dur, Pbjorklund2(Pwhite(3,15),16)*0.25,
		\rate, Pwhite(1.0,5.0,inf),
		\atk, 0.05,
		\sus, Pwhite(0.0, 0.15,inf),
		\rel, 0.01,
		\amp, 0.2

	);
);

)


(
~freq = {SinOsc.kr(0.12).exprange(1500,6500)};
~hh[10]  = \filterIn ->  {|in| RLPF.ar(in, ~freq, 0.1)};
~hh.set(\wet10, 0.15)
)
~hh.play(fadeTime:5);








~rythm.ar
~hh.ar
t = TempoClock(120/60)

~rythm.play;

~mix[10] = { ~rythm + ~hh }
~mix.pause
~mix.resume


(

~bd = Pbind(
	\instrument, \bufsynth,
	\buf, d["sk"][0],
	\dur,1,
	\amp, 0.7
)

)
(

~hh = Pbind(
	\instrument, \bufsynth,
	\buf, d["h"][3],
	\dur,Pseq([0.5,1],inf),
	\amp,1,
	\atk,1,
	\sus,1
)

)

~hh.play
~hh.resume


t = p.clock.tempo_(120/60);

~rythm.play;
~rythm.resume;
~rythm.pause;
~bd.play
~bd.pause
~bd.resume
~sn.play
~sn.stop


(
~sn = Pbind(
	\instrument, \bufsynth,
	\buf, d["s"][1],
	\dur,Pbjorklund2(Pwhite(3,15),16)*0.25,
	\amp,1,
	\atk,0.5,
	\sus,0.5


)
)
(
~a = Pbindef(\p0,
	\type, \midi,

	\octave, [5],
	\midinote, Pxrand(Scale.zhi.degrees+50,inf),
	\dur, 1,
	\midicmd, \noteOn,
	\midiout,m,
	\amp,0.09,
	\sustain, 0.09

)
)

~a.play

~a.pause


~off = Tdef(\off, {
	~bd.stop;
	4.wait;
	~hh.stop;
	4.wait;
	~rythm.stop;
	2.wait;
	~mix.pause
})




~a = Pbind(\type, \midi,

	\octave, [5],
	\midinote, Pxrand(Scale.gong.degrees+50,inf),
	\dur, 1,
	\midicmd, \noteOn,
	\midiout,m,
	\amp,0.09,
	\sustain, 0.09)