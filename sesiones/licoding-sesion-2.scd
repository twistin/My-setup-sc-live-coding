("../Setup/Setup.scd").loadRelative;

m.noteOn(0,60,64)
m.noteOff(0,60,64)


(
~a = Pbindef(\p0,
	\type, \midi,

	\octave, [7],
	\midinote, Pxrand(Scale.zhi.degrees+50,inf),
	\dur, 0.50,
	\midicmd, \noteOn,
	\midiout,m,
	\amp,0.3,
	\sustain, 0.02

)
)

~a.play

~a.pause
Scale.directory