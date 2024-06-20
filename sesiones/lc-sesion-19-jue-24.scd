      /////////////////////&


p == currentEnvironment



Pbrown




(
~a = Pbind(
	\instrument,\buf,
	\buf, Pxrand([d["glitch"]], inf),
	\dur, Pseq([1/4],inf),
	\rate, Pwhite(1.0,5.0,inf),
	\spos,0,
	\amp,0.4,
	\atk,0,
	\sus, 0.03,
	\rel, 0.01,
	\curve1,1,
	\curve2,2,
	\pan,0


)
)