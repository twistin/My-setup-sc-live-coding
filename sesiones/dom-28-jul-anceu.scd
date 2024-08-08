("../Setup/Setup.scd").loadRelative;


p.clock.tempo_(120/60);


// Crear un servidor
s.boot;

// Crear un buffer para almacenar la tabla de ondas
(
var size = 512; // Tamaño de la tabla de ondas
b = Buffer.alloc(s, size, 1);

// Rellenar el buffer con una forma de onda (senoidal en este caso)
b.sine1([1,0.5,0.7,0.1,0.3]); // Generar una onda senoidal pura
)
b.plot;

// Crear un SynthDef que utilice la tabla de ondas
(
SynthDef(\wavetableSynth, {
    arg freq = 440, amp = 0.1;
    var osc, env;
	env = Env.perc(\atk.ir(0.5),\rel.ir(0.5),1,curve:-7).ar(2);

    osc = Osc.ar(b, freq, 0, amp); // Oscilador usando el buffer como tabla de ondas
	osc = osc*env;
	osc = Pan2.ar(osc, \pos.ir(0));
    Out.ar(0, osc);
}).add;
)


(

~note[0] = Pbind(
	\instrument,\wavetableSynth,
	\freq, Pxrand([80,100,110,60,65],inf),
	\dur, 1/3,
	\amp, Pwhite(0.2, 0.9,inf),
	\pos, Pxrand([-0.3,-0.6,0, 0.3,0.6],inf),
	\atk, 0.05,
	\rel, 0.05


)
)
Reverb
~note.pause;
~note.resume;
~note[10] = \filter -> {|in| FreeVerb.ar(in,\mix.ir(0.55),\room.ir(1),\damp.ir(0.5))};
~note.set(\wet1,0.5)




~mix = {~note};

// Reproducir el Synth
x = Synth(\wavetableSynth);
x.set(\freq, 220); // Cambiar la frecuencia
x.free; // Detener el Synth

//////// wavetable ////////////
(
~wt0 = Signal.sineFill(
	1024,
	1/(1..8),
	0!2
).asWavetable;

~wt1 = Signal.sineFill(
	1024,
	[1,0, 1/2, 1, 1/4],
	[0,0,pi, 0,pi]
).asWavetable;

)



~wt0.plot;
~wt1.plot;



(
~b0 = Buffer.loadCollection(s, ~wt0);
~b1 = Buffer.loadCollection(s, ~wt1);

)


(
{
	var sig;
	sig = VOsc.ar(MouseX.kr(0,1),300, mul:0.2!2)
}.play;
)




//////////// tabla de ondas - video Ely Fieldsteel //////////////
//////////// https://www.youtube.com/watch?v=5krJVMxCr8s&t=670s ////////

// Pasos Básicos:
// 1. crear alguna forma cíclica
// 2. convertirla a formato Wavetable

// 3. cargarlo en un Buffer
// 4. usar un UGen oscilador wt para leer ese Buffer

(
~sig = Signal.sineFill(4096,[1],[pi]);  // el tamaño del parámetro 'size' debe ser una potencia de dos. La amp y la phase son matrices
~sig.plot;
)


(
Window.closeAll;
~sig = Signal.sineFill(4096,[1,0.2,0.4,1,0.1,0.8],[0,pi,0,pi,0,0]);  // el tamaño del parámetro 'size' debe ser una potencia de dos. La amp y la phase son matrices
~sig.plot;
)


~buf = Buffer.alloc(s,4096);
~buf.sendCollection(~sig);

(
SynthDef(\wavetableSynth, {
    arg freq = 440, amp = 0.1;
    var osc, env;
	env = Env.perc(\atk.ir(0.5),\rel.ir(0.5),1,curve:-7).ar(2);

    osc = Osc.ar(~buf, freq, 0, amp); // Oscilador usando el buffer como tabla de ondas
	osc = osc*env;
	osc = Pan2.ar(osc, \pos.ir(0));
    Out.ar(0, osc);
}).add;
)
Synth(\wavetableSynth)

(

~note[0] = Pbind(
	\instrument,\wavetableSynth,
	\freq, Pxrand([80,100,110,60,65],inf),
	\dur, 1/3,
	\amp, Pwhite(0.2, 0.9,inf),
	\pos, Pxrand([-0.3,-0.6,0, 0.3,0.6],inf),
	\atk, 0.05,
	\rel, 0.05


).play
)

(
{
	var sig;
	sig = Osc.ar(~buf,200)* 0.1!2;
}.play
)
(
{
	var sig;
	sig = Osc.ar(~buf,MouseX.kr(1,500,1))* 006.1!2;
}.play
)
s.scope;





(
Window.closeAll;
~sig = Signal.sineFill(4096,[1,0.2,0.4,1,0.1,0.8],[0,pi,0,pi,0,0]);  // el tamaño del parámetro 'size' debe ser una potencia de dos. La amp y la phase son matrices
~sig.plot;
~wt = ~sig.asWavetable;
)

Buffer.freeAll;
~buf = Buffer.alloc(s,8192);
~buf.sendCollection(~wt);
~buf.plot;

8192.sqrt


~wt.plot
(
~wt = Signal.sineFill(8192, [1,0.23,0.5,0.8,1,0.1], [0,pi,0,pi,pi,0]).asWavetable;
b = Buffer.loadCollection(s, ~wt);
)
{ Osc.ar(b, 80) * 0.2 ! 2 }.play;


/////////// VOsc

(
b = Buffer.allocConsecutive(4, s, 16384);
~wt = [
Signal.sineFill(8192, 1 ! 4, 0 ! 4),
Signal.sineFill(8192, 1 / (1..50), 0 ! 50),
Signal.sineFill(
8192,
[1 / (1, 3..50), 0 ! 25].lace(50),
0 ! 50
),
Signal.sineFill(
8192,
Array.exprand(50, 0.001, 1).sort.reverse,
{rrand(0, 2pi)} ! 50
),
];
b.do({ |buf, i| buf.loadCollection(~wt[i].asWavetable) });
)
~wt.plot; // optional visualization


(
{
var sig, bufmod;
bufmod = SinOsc.kr(0.05, 3pi/2).unipolar(2.999);
sig = VOsc.ar(b[0].bufnum + bufmod, 200);
sig = sig * 0.1 ! 2;
}.play;
)




(
~wt = Env.new([-1, 0, 1], [1, 1], [4, -4]).asSignal(8193);
b = Buffer.loadCollection(s, ~wt.asWavetableNoWrap);
)
~wt.plot; // optional visualization
(
{
var sig, index;
index = SinOsc.ar(200);
sig = Shaper.ar(b, index);
sig = sig * 0.2 ! 2;
}.play;
)


(
{
var sig, freq;
freq = LFNoise0.kr(8).exprange(150, 2000);
sig = SinOsc.ar(freq) * 0.2 ! 2;
}.play;
)

{LFNoise0.ar(XLine.kr(100, s.sampleRate, 8)) * 0.1 ! 2}.play;
{LFNoise1.ar(XLine.kr(100, s.sampleRate, 8)) * 0.1 ! 2}.play;
{LFNoise2.ar(XLine.kr(100, s.sampleRate, 8)) * 0.1 ! 2}.play;

{LFDNoise0.ar(XLine.kr(100, s.sampleRate, 8)) * 0.1 ! 2}.play;
{LFDNoise1.ar(XLine.kr(100, s.sampleRate, 8)) * 0.1 ! 2}.play;
{LFDNoise3.ar(XLine.kr(100, s.sampleRate, 8)) * 0.1 ! 2}.play;



(
{
var sig, cutoff;
cutoff = LFTri.kr(0.1, 3).exprange(100, 10000);
sig = PinkNoise.ar(1);
sig = LPF.ar(sig, cutoff) * 0.25 ! 2; // replace with HPF
}.play;
)
(
{
var sig, cutoff, rq;
cutoff = LFTri.kr(0.1, 3).exprange(100, 10000);
rq = MouseY.kr(0.01, 1, 1).clip(0.01, 1);
sig = PinkNoise.ar(1);
sig = BPF.ar(sig, cutoff, rq) * 0.25 ! 2; // replace with BRF
}.play;
)


(
{
var sig, cutoff, rq;
cutoff = LFTri.kr(0.1, 3).exprange(100, 10000);
rq = MouseY.kr(0.01, 1, 1).clip(0.01, 1);
sig = PinkNoise.ar(1);
sig = BPF.ar(sig, cutoff, rq, mul: 1 / rq.sqrt) * 0.5 ! 2;
}.play;
)

////////// Filtros


/*
Los UGens LPF, HPF, BPF y BRF ofrecen una opción para cada una de estas cuatro categorías.
LPF y HPF aceptan una señal de entrada y una frecuencia de corte. BPF y BRF aceptan una señal de entrada  una frecuencia central y un argumento adicional denominado rq, abreviatura de «calidad recíproca».
La calidad, a menudo abreviada como «Q», es una medida de la selectividad de un filtro, que se correlaciona con su  tendencia a mostrar un comportamiento resonante. En el caso de los filtros paso banda y rechazo banda, Q es la  relación entre la frecuencia central y el ancho de banda. Por ejemplo, si la frecuencia central es de 1.000 Hz y
el ancho de banda es de 100 Hz, la calidad del filtro es 1.000/100 = 10. Una mayor calidad significa  una banda más estrecha y un filtro más selectivo. En SC, los filtros esperan que este valor se especifique como  el recíproco de Q (ancho de banda dividido por la frecuencia central), una elección de diseño que aumenta ligeramente aumenta ligeramente la eficiencia del UGen. Un rq igual a uno representa una calidad de base nominal, que  aumenta a medida que rq se aproxima a cero. El ejemplo de código 3.22 incluye ejemplos de código para cada uno de estos  cuatro filtros UGen.

*/


~a.play; ~a.awake_(false);
~a = {Pan2.ar(LPF.ar(LFTri.ar(XLine.ar(80,800,\dur.ir(2.06)), \ipha.ir(0),\amp.ir(1),0),\freq.ir(10000)))*Env.linen(\atk.ir(1),\sus.ir(1),\rel.ir(0.06)).ar(2) }
~a.spawn
~b.play; ~b.awake_(false);
~b = { Pan2.ar(HPF.ar(SinOsc.ar(220,0,1),100, \amp.ir(1)),\pos.ir(0))* Env.linen(\atk.ir(0.5),\sus.ir(0.5),\rel.ir(0.08)).ar(2) };
~b.spawn

~seq = Tdef(\seq, {
	loop{
		~a.spawn([\ipha,pi, \atk,0.08,\dur, 0.3,\freq,1000,\amp, 0.1]);
		0.75.wait;
		~a.spawn([\ipha,0.03, \atk,0.8,\dur, 0.5,\freq,100,\amp,0.1]);
		0.5.wait;
		//~a.spawn([\ipha,0.6, \atk,05,\dur, 0.7,\freq,5000,\amp,0.1 ]);
		//0.7.wait;
	}
})


~off = Tdef(\off,{
	4.wait;
	~a.stop

})




// Definir múltiples tablas de ondas
a = Buffer.alloc(s, 512, 1);
a.sine1([1, 0.5, 0.25]);  // Armonicos de seno

b = Buffer.alloc(s, 512, 1);
b.cheby([1, 0.5, 0.25]);  // Chebyshev

(
{
    var freq = 440;
    var amp = 0.1;
    var osc1 = Osc.ar(a, freq, 0, amp);
    var osc2 = Osc.ar(b, freq * 1.5, 0, amp);
    var mixed = Mix([osc1, osc2]);
    mixed
}.play;
)







(
~env = Env(
	[0]++Array.rand(12,-1.0, 1.0).normalize(-1,1)++[0],
	Array.exprand(11,0.01,1),
	Array.rand(11,-4.0,4.0)

);
~env.plot;
~wt = ~env.discretize(4096).asWavetable;
r{
	Buffer.freeAll;
	s.sync;
	~buf = Buffer.sendCollection(s, ~wt);
}.play;
)

~buf.plot;

(
{
	var sig;
	sig = Osc.ar(~buf, MouseX.kr(80,800,1).poll)*0.07!2;
}.play;
)
Window.closeAll




