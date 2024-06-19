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

Synth(\buf)
(
~a = Pbind(
	\instrument, \buf,
	\buf, Pxrand([d["china"]],inf),
	\dur, 10,
	\rate,1,
	\amp, 1,
	\spos, 1

)
)
~a.stop

Tdef(\def,{
loop{
Synth(\buf,[\buf, d["china"][0], \spos,0.3, \rate,])
}

});

Tdef().stop
Pattern
// Carga el buffer con el audio
b = Buffer.readChannel(s, "/Users/sdcarr/Documents/GitHub/My-setup-sc-live-coding/samples/set1/china/1.wav");

// Define el Pbind para reproducir el buffer
~a[0] = Pbind(
	\instrument,\buf,
	\buf, d["china"][4],
    \dur, 17.14, // Duración del buffer en segundos
    \loop, 0, // Repetir el buffer completo
    \amp, 0.1, // Nivel de volumen
	\atk,1,
	\sus,15,
	\rel,1.1
);
~a.play
~a.stop
~a.quant_(4).play
b.duration

d["china"][4].duration

~r1 = Pbind(
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

)

 ~mix = {}

~r1.play
~r1.stop
~r1.quant_(4).play
t = p.clock.tempo_(60/60);


~off = Tdef(\off, {
	~r1.stop;
	4.wait;
	~a.stop;
	6.wait;
})

~off.play

~mix = {}