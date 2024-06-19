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


(
~a = Pbind(
	\instrument, \simpledron,
	\dur, 6,
	\amp, -20.dbamp,
	\rq, 1,

	\freq , Pwhite([80,200,220],[80,240,250],inf),

)
)
~mix = {~t4}
~a.release(4)
~a.stop(2)


Synth(\chaosGlitch2)
~t4.pause
~mix = { }
~t4 = Pbind(
	\instrument, \chaosGlitch2,
	\amp, 0.7,
	\dur,5,
	\len,5,
	\fundFreq , [40,80].choose,
	\henA , 2,
	\henB , 0.4,
	\t , 1,
	\gate, 1,
)







