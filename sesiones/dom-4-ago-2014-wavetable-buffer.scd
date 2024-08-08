



(
~wt = Signal.sineFill(16384.0, [1,0.5,0.34,0.16,0.9],[0,0,pi,1/pi,0]);
b = Buffer.loadCollection(s,~wt);
)
b.plot
Window.closeAll



{Osc.ar(b,80)*0.6 !2}.play

Array.fill(44100, {|i| i.rand});

a = Array.fill(10, {Buffer.alloc(s,44100 * 8.0, 2)});
a[3].bufnum
a[0].numFrames

10.do({arg i; a[i].free;})


a = Array.fill(44100, {1.0.rand2});
b = Buffer.loadCollection(s, a);
b.play


// We could then observe the samples by getting it back to the language like we did above:
a = Array.fill(44100, {arg i; i=i/10; sin(i)}); // fill a buffer with a sine wave
b = Buffer.loadCollection(s, a); // load the array onto the server
b.play // and now we have a beautiful sine!
b.loadToFloatArray(action: {arg array; a = array; Post << a}) // lots of samples







b = Buffer.read(s, "/Applications/SuperCollider.app/Contents/Resources/sounds/a11wlk01.wav");
b.play
SynthDef(\playMono, { arg out=0, buffer, rate=1;
    Out.ar(out, PlayBuf.ar(1, buffer, rate, loop:1) ! 2)
}).add;

SynthDef(\playStereo, { arg out=0, buffer, rate=1;
    Out.ar(out, PlayBuf.ar(2, buffer, rate, loop:1)) // no "! 2"
}).add;

// And then
If(b.numChannels == 1, {
    x = Synth(\playMono, [\buffer, b]) // we pass in either the buffer or the buffer number
}, {
    x = Synth(\playStereo, [\buffer, b]) // we pass in either the buffer or the buffer number
});

PlayBuf


       // CONCEPTO DE INTERPOLACIÓN //

// tenemos un buffer de audio con varias muestras discretas. Cada punto en el gráfico representa una muestra de audio en el buffer.
// Buffer de Muestras:

Tiempo:    |----|----|----|----|----|----|----|
Muestras:  *    *    *    *    *    *    *    *

// Ahora, supongamos que queremos leer un valor que no coincide exactamente con una de las muestras discretas. Aquí es donde entra la interpolación.

           //Interpolación Lineal
//La interpolación lineal estima el valor intermedio como un punto en la línea recta entre dos muestras adyacentes.

Tiempo:    |----|----|----|----|----|----|----|
Muestras:  *    *    *    *    *    *    *    *
Interpolado: |    |    |    |    |    |    |


//El punto interpolado está en la línea recta entre las muestras adyacentes.

            //Interpolación Cúbica
//La interpolación cúbica utiliza una curva basada en varias muestras vecinas para estimar el valor intermedio, resultando en una curva más suave.



Tiempo:    |----|----|----|----|----|----|----|
Muestras:  *    *    *    *    *    *    *    *
Interpolado: \    /    \    /    \    /    \
              \  /      \  /      \  /      \



                  // Interpolación Variable en BufRd

// La interpolación variable en BufRd significa que puedes elegir qué tipo de interpolación utilizar al leer los valores del buffer. En SuperCollider, esto se hace configurando el argumento interp de BufRd.

interp=1: Interpolación lineal.
interp=2: Interpolación cúbica.


// Ejemplo en SC
(


s.waitForBoot {

    var buffer, env, interpType, synth;

    // Cargar un buffer de audio
    buffer = Buffer.read(s,"/Applications/SuperCollider.app/Contents/Resources/sounds/a11wlk01-44_1.aiff" );

    // Crear un entorno gráfico para elegir el tipo de interpolación
    env = Env.perc;
    interpType = 2; // Cambia esto a 1 para interpolación lineal

    // Definir el sintetizador que usa BufRd
    SynthDef(\bufRdExample, {
        arg buf, rate = 1, startPos = 0, interp = 2;
        var sig, phase;
        phase = Phasor.ar(0, BufRateScale.kr(buf) * rate, startPos, BufFrames.kr(buf));
        sig = BufRd.ar(1, buf, phase, interp);
        Out.ar(0, sig * 0.5);
    }).add;

    // Iniciar el sintetizador con el buffer cargado y el tipo de interpolación seleccionado
    synth = Synth(\bufRdExample, [\buf, buffer, \interp, interpType]);

 	s.boot;
};
)

Interp. Lineal:   *----*----*----*----*
Interp. Cúbica:   *~~~~*~~~~*~~~~*~~~~*

Los puntos * representan las muestras originales del buffer, las líneas ---- representan la interpolación lineal, y las líneas ~~~~ representan la interpolación cúbica más suave.

b = Buffer.read(s,"/Applications/SuperCollider.app/Contents/Resources/sounds/a11wlk01-44_1.aiff");
b.play
{BufRd.ar(1,b,SinOsc.ar(0.1) * BufFrames.ir(b),1,2)}.play
{BufRd.ar(1,b, LFNoise1.ar(1) * BufFrames.ir(b)) }.play;
{ BufRd.ar(1, b, LFTri.ar(0.1) + LFTri.ar(0.23) * BufFrames.ir(b)) }.play;
{PlayBuf.ar(1,b,SinOsc.ar(0.1) * BufFrames.ir(b),1,2)}.play
{PlayBuf.ar(1,b,1,1,0,1,0)}.play

//////////////////////////////////////

("../Setup/Setup.scd").loadRelative;

//////////////////////////////////////

Buffer.freeAll
b = Buffer.read(s,"/Applications/SuperCollider.app/Contents/Resources/sounds/a11wlk01-44_1.aiff");
b.duration.round

d = b.numFrames/b.sampleRate // Calcular la duracion
d.round

~a.play; ~a.awake_(false);
~a = {BufRd.ar(1,b, LFNoise1.ar(1) * BufFrames.ir(b))* Env.linen(\atk.ir(0.2),\sus.ir(2),\rel.ir(0.4)).ar(2)}


~seq = Tdef(\seq,{
	loop{
	~a.spawn([\atk,[0.2,0.6].choose]);
	0.7.wait;

	}
})

~seq.pause

s.options.sampleRate = 44000;  // Ajustar la tasa de muestreo a 48000 Hz

duration
(
SynthDef(\synth1, {arg out=0, freq=440, envdur=1, amp=0.4, pan=0;
    var x, env;
    env = EnvGen.kr(Env.perc(0.001, envdur, amp), doneAction:2);
    x = Mix.ar([FSinOsc.ar(freq, pi/2, 0.5), Pulse.ar(freq,Rand(0.3,0.7))]);
    x = RLPF.ar(x,freq*4,Rand(0.04,1));
    x = Pan2.ar(x,pan);
    Out.ar(out, x*env);
}).add;

)

Synth(\synth1,[\freq,80]);

(
~seq = Pbind(
	\instrument, \synth1,
	\freq, Pxrand([80,85,90,95,100],inf),
	\dur, Pseq([1/3,1/3,1/3, Rest(1/3)],inf),
	\pan, Pxrand([-0.4,-0.8,0,0.4,0.8],inf),

)
)
~seq.quant_(1).play
s.makeWindow;
s.plotTree

// Definir y reproducir el patrón en el ProxySpace
p[\seq1] = Pbind(
    \instrument, \synth1,
    \freq, Pxrand([180, 185, 190, 195, 1100], inf),
    \dur, Pseq([Rest(1/3),1/3,1/3,1/3],inf),
    \pan, Pxrand([-0.4, -0.8, 0, 0.4, 0.8], inf)
);

p[\seq1].quant_(1).play;

~k = Pbind(\instrument,\pbufm,
	//\buf,d["k"][0],
	\buf,Pxrand([d["k"]],inf),
	\dur,1, //Pseq([Rest(1/3),1/3,1/3,1/3],inf),
	\amp,1

);
~k.play
~k = Pbind(\instrument,\buffer,\bufnum,d["k"][0],\dur,1,\amp,1);

d["k"].play
////////////////////////////////////////////////////////////////////

~z.play; ~z.awake_(false);
~z = {
	|sig, env|
	env = Env.linen(\atk.ir(0.05),\sus.ir(2), \rel.ir(1),1,curve:-6).ar(2);
	sig = PlayBuf.ar(1, d["china"][0],\rate.ir(1),1, \spos.ir(0),0,0);
	sig = sig * env;
	sig = Pan2.ar(sig, \pos.ir(0))
}

~z.play
(
~seq = Tdef(\seq, {
	loop{
		~z.spawn([\bufnum, d["china"][3],\rate, 0.3]);
	1.wait;
	  // ~z.spawn([\bufnum, d["china"][2],\rate, 1.3]);
	 1/2.wait

	};
})
)
Tdef(\seq).pause
~seq.clear
~seq.stop
~seq.resume
Pwrand
Pbjorklund2


z =Pwrand([1,Pbjorklund2(5,16,1)/4],[0.8,0.2],inf).postln
z.postln

Buffer.freeAll
d["k"].numChannels;





           /////////////////////////////////////////////////////////
           ///////////////////////////////////////////////////////
            ////////////////////////////////////////////////////



(
SynthDef(\bplay, {
	arg out = 0, rate= 1, amp=1, pan= 0, pos= 0, rel=1;
	var env, sig;
	env = Env.perc(\atk.ir(0.01),rel, \curve.ir(-5)).ar(2);
	sig = PlayBuf.ar(1,\buf.ir(d["k"][0]),rate, 1, pos, 0,2);
	sig = sig * env*0.1;
	sig = Pan2.ar(sig,pos);
	Out.ar(out, sig);
}).add;
)

Synth(\bplay)


(
~k[0] = Pbind(
	\instrument, \bplay,
	\buf,d["k"][0] ,
	\dur,2, //Pwrand([1,Pbjorklund2(5,16,1)/4],[0.8,0.2],inf),

	//\pos, Pxrand(#[-0.4,-0.8,0,0.4,0.8],inf),// la # hace que los valores de la matriz sean inmutables durante la reproducción
	\rate, 1,//Pwrand([0.3,0.8,1,1.3,1.8], [1,2,3,4,5].normalizeSum,inf),
	\rel, 0.5,
	\atk, 0.05,

)
)
normalizeSum


~k.quant_(1).play;
~k.stop;
~k.pause;
~k.resume;

~k[10] = \filter -> {|in| GVerb.ar(in, roomsize:100, maxroomsize:600)};
~k[20] = \filter -> {|in| CompanderD.ar(in,0.8,0.5,1.5,0.05,0.05 )};
~k.set(\wet10, 0.08);
~k.set(\wet20, 0.1)

(
~sn[0] = Pbind(
	\instrument, \bplay,
	\buf,d["s"][3] ,
	\dur,1, //Pwrand([1,Pbjorklund2(5,16,1)/4],[0.8,0.2],inf),

	//\pos, Pxrand(#[-0.4,-0.8,0,0.4,0.8],inf),// la # hace que los valores de la matriz sean inmutables durante la reproducción
	\rate, 1,//Pwrand([0.3,0.8,1,1.3,1.8], [1,2,3,4,5].normalizeSum,inf),
	\rel, 0.5,
	\atk, 0.05,

)
)

~sn.play;
~sn.stop;
~sn.pause;
~sn.resume;

~sn[10] = \filter -> {|in| GVerb.ar(in, roomsize:20, maxroomsize:600)};
~sn[20] = \filter -> {|in| CompanderD.ar(in,0.8,0.5,1.5,0.05,0.05 )};
~sn.set(\wet10, 0.08);
~sn.set(\wet20, 0.1);



(
~hh[0] = Pbind(
	\instrument, \bplay,
	\buf,d["h"][2] ,
	\dur,0.25, //Pwrand([1,Pbjorklund2(5,16,1)/4],[0.8,0.2],inf),

	//\pos, Pxrand(#[-0.4,-0.8,0,0.4,0.8],inf),// la # hace que los valores de la matriz sean inmutables durante la reproducción
	\rate, 1,//Pwrand([0.3,0.8,1,1.3,1.8], [1,2,3,4,5].normalizeSum,inf),
	\rel, 0.5,
	\atk, 0.05,

)
)

~hh.play;
~hh.stop;
~hh.pause;
~hh.resume;

~hh[10] = \filter -> {|in| GVerb.ar(in, roomsize:10, maxroomsize:600)};
~hh[20] = \filter -> {|in| CompanderD.ar(in,0.8,0.5,1.5,0.05,0.05 )};
~hh.set(\wet10, 0);
~hh.set(\wet20,0);

(
~c[0] = Pbind(
	\instrument, \bplay,
	\buf,d["c"][8] ,
	\dur,0.75, //Pwrand([1,Pbjorklund2(5,16,1)/4],[0.8,0.2],inf),

	//\pos, Pxrand(#[-0.4,-0.8,0,0.4,0.8],inf),// la # hace que los valores de la matriz sean inmutables durante la reproducción
	\rate, 1,//Pwrand([0.3,0.8,1,1.3,1.8], [1,2,3,4,5].normalizeSum,inf),
	\rel, 0.5,
	\atk, 0.05,

)
)
~c[10] = \filter -> {|in| GVerb.ar(in, roomsize:50, maxroomsize:1000)};
~c.set(\wet10, 0.06);
~c.quant_(1).play;

(
~oh = Pbind(\instrument,\bplay,
	\buf,d["oh"][0],
	\dur,Pseq([0.5,Pseq([1],inf)],inf),
	\amp,1);
)
~oh.quant_(1).play;
~oh[10] = \filter -> {|in| GVerb.ar(in, roomsize:50, maxroomsize:1000)};
~oh.set(\wet10, 0.1);
~oh.pause;





~k.pause;
~sn.pause;
~hh.pause;
~c.pause;


