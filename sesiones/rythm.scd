


	/////////// Parámetro ritmo //////////////////


~ritmoPat = [
	~rythm1[0] =Pbind(
		\instrument, \bufsynth,

		\buf, Pxrand(d["glitch2"],inf),
		\dur, 1/4,
		\rate, Pwhite(1.0,5.0,inf),
		\spos,0,
		\amp, 0.8,
		\atk, 0,
		\sus, Pwhite(0.0,0.15),
		\rel, 0.01,
		\cur,1,
		\pan, Prand([-1,0, 1],inf)

	),
	~rythm2[0] =Pbind(
		\instrument, \bufsynth,

		\buf, Pxrand(d["pajaros"],inf),
		\dur, 1/2,
		\rate, Pwhite(1.0,5.0,inf),
		\spos,0,
		\amp, 0.8,
		\atk, 0.5,
		\sus, Pwhite(0.0,0.15),
		\rel, 0.1,
		\cur,1,
		\pan, Prand([-1,0, 1],inf)

	),
	~rythm3[0] =Pbind(
		\instrument, \bufsynth,

		\buf, Pxrand(d["shout"],inf),
		\dur, 0.25,
		\rate, Pwhite(1.0,5.0,inf),
		\spos,0,
		\amp, 14.dbamp,
		\atk, 0.5,
		\sus, Pwhite(0.0,0.15),
		\rel, 0.1,
		\cur,1,
		\pan, Prand([-1,0, 1],inf)

	),
	~rythm4[0] =Pbind(
		\instrument, \bufsynth,

		\buf, Pxrand(d["voces"],inf),
		\dur, 1/4,
		\rate, Pwhite(0.8,1.5,inf),
		\spos,Pwhite(0.0,0.8,inf),
		\amp, 2.dbamp,
		\atk, 0.05,
		\sus, Pwhite(0.0,0.15),
		\rel, 0.1,
		\cur,1,
		\pan, Prand([-1,0, 1],inf)

	),
		~rythm5[0] =Pbind(
		\instrument, \bufsynth,

		\buf, Pxrand(d["etnico"],inf),
		\dur, 2,
		\rate, Pwhite(0.8,1.5,inf),
		\spos,Pwhite(0.0,0.8,inf),
		\amp, 1.dbamp,
		\atk, 0.5,
		\sus, Pwhite(0.0,0.15),
		\rel, 1,
		\cur,1,
		\pan, Prand([-1,0, 1],inf)

	),
		~rythm6[0] =Pbind(
		\instrument, \bufsynth,

		\buf, Pxrand(d["agua"],inf),
		\dur, 1/4,
		\rate, Pwhite(0.8,1.5,inf),
		\spos,Pwhite(0.0,0.8,inf),
		\amp, 4.dbamp,
		\atk, 0.05,
		\sus, Pwhite(0.0,0.15),
		\rel, 0.5,
		\cur,-4,
		\pan, Prand([-1,0, 1],inf)

	)

]

