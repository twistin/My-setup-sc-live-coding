



("../Setup/Setup.scd").loadRelative;

m.noteOn(0,64,68)




~mid.stop
~mid.resume


(
~mid = Pbind(
	\type, \midi,
	\midiout, m,
	\midicmd, \noteOn,
	\midinote, Pseq([69,64,80,76],inf),
	\dur , 1/2,
	\amp, Pxrand([0.3,0.5,0.8,1],inf),
	\pan, Pxrand([-1,-0.2,-0.8, 0, 0.8,0.2,1],inf)

).stop
)


//Pbindef 1 - Generar sonido
~sound = Pbindef(\sound,
    \instrument, \electricguitar,
    \dur, 0.25,
	\octave,2,
    \degree, Pseq([0,  4].stutter(5), inf),
    \amp,1
);

// Pbindef 2 - Enviar mensajes MIDI
~midi = Pbindef(\midi,
    \type, \midi,
    \midiout, m, // Ajusta estos nombres según tu configuración
    \midicmd, \noteOn,
    \chan, 0,
    \dur,1,
    \midinote, Pxrand([60, 62, 64, 65, 67], inf),
    \vel, 64
);

// Cuantización de los Pbindef
~sound.quant_(1); // Cuantización a 1 beat
~midi.quant_(1);  // Cuantización a 1 beat

~sound.play;
~midi.stop;

~midi2.play


z=[
    [5,7,4,2,0,12,7,5,7,4,2,0],
    [5,7,4,2,0,12,4,7,5,0],
    [-5,2,0,4,7,12,5,2,7,4,0,7,2,5,5,2,4,0],
    [7,7,2,4,4,4,2,0,7,0,0],
]
~midi2 = Pbindef(\midi,
    \type, \midi,
    \midiout, m, // Ajusta estos nombres según tu configuración
    \midicmd, \noteOn,
	\octave,3,
    \chan,1,
    \dur,1,
    \midinote, Pxrand(z, inf),
    \vel, 64,
	\amp,1
);


~midi2.stop




