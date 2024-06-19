("../Setup/Setup.scd").loadRelative;
(
~g5[0] = Pbind(
	\instrument, \buf,
	\buf, [d["set-sounds"][6],d["set-sounds"][5]],
	\dur, 1/4,
	\rate, Pwhite(0.5,1.5,inf),
	\amp, 0.3,
	\atk, 2,
	\sus, 2,
	\rel, 0.5

))
~g5.play;
~mix = {~g5}
Synth(\buf)

d["set-sounds"][0].play
d.keys

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

~r6.play
~r6[0] = Pbind(
	\instrument, \pulse,
	\dur, Pxrand([0.5,0.25,0.75],inf),
	\sustain, 0.2,
	\degree, Pxrand([0, 1, 2, 3,5], inf),
	\db, -10,
	\atk, 0.01,
	\dec, 0.08,
	\slev, 0,
	\rel, 0,

)