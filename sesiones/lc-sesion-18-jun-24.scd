("../Setup/Setup.scd").loadRelative;


// Carga un archivo de audio en un búfer
(
var path = "/Users/sdcarr/Desktop/My-setup-sc-live-coding/samples/set1/china/chinese-guzheng.wav";  // Cambia esto a la ubicación de tu archivo
var miBuffer = Buffer.read(s, path);
)
d["china"][0].play

// Define un patrón Pbind para reproducir el búfer en bucle
(
Pbind(
    \instrument, \bufsynth,  // Nombre de la SynthDef que reproduce el búfer
    \buf, d["china"][0],     // Búfer cargado previamente
    \dur,4,  // Duración basada en el búfer
    \legato, 1,            // Reproduce en bucle sin espacios
).play;
)
(
Pbind(
    \instrument, \buffer,  // Usamos la SynthDef estándar \playBuf
    \bufnum, d["china"][0],     // Búfer cargado previamente
    \dur, Pkey(\buffer.numFrames) / Pkey(\buffer.sampleRate),  // Duración basada en el búfer
    \legato, 1,            // Reproduce en bucle sin espacios
).play;
)


supercollider



    // Definir SynthDef con PlayBuf
    SynthDef(\buf, {
        arg out = 0, bufnum;
        var sig,env;
		env = Env(
			levels:[0,1,1,0],
			times:[1,1,0.5],
			curve:-7
	).ar(2);

        sig = PlayBuf.ar(1, bufnum,\rate.ir(1), loop: 1);
	sig = Pan2.ar(sig,\pos.ir(0.0));
        Out.ar(out, sig);
    }).add;

    // Crear ProxySpace
    p = ProxySpace.push(s);

    // Reproducir el audio en bucle con SynthDef
	x = Synth(\reproducirAudio, [\bufnum, d["china"][0]]);

    // Reproducir en bucle con Pbind

~z = Synth(\pbufs, [\buf,d["china"][2] ])
     ~z =Pbind(
        \instrument, \pbufm,
		\buf,  d["china"][0],
        //\bufnum,  d["china"][0].bufnum,
       \dur, 4,
        \legato, 1,
	\rate,1, //Pwhite(0.5,1.5,inf),
	\amp,1,
	\pos, Pwhite([-1,1],inf)
    );
~z.resume
~z.set(\buf,7)
~z.play(fadeTime:4)
~z.stop
~z.clear
( // first, create a clock at 108 bpm and post beat information
t = TempoClock(60/60);
t.schedAbs(0, {t.beats.postln; 1;});
p = ProxySpace(clock:t).quant_(8).push
;t.stop
)
Pdef(\fauvette).play
bufnum.freeAll
Buffer.freeAll
 d["china"][0]

d["china"][0].duration
d["china"][0].play




(
SynthDef(\buffer, {
  arg bufnum, start = 0, end = 16, mul = 0.1, rate = 1;
  var sig, env, duration;

  duration = (end - start) * BufDur.kr(bufnum) * rate.reciprocal;
  env = Env.linen(0.01, duration - 0.02, 0.01, mul).ar(2);

  sig = PlayBuf.ar(1, bufnum, rate * BufRateScale.kr(bufnum), startPos: start * BufFrames.kr(bufnum));

  sig = sig * env;
  sig = Pan2.ar(sig);
	Out.ar(0, sig);
}).add;
)
d["china"][0].duration
d["china"][0].bufnum