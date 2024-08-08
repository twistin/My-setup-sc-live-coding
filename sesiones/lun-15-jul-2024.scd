MethodOverride.printAll
SynthDescLib.global.browse
("../Setup/Setup.scd").loadRelative;
p.clock.tempo_(40/60);


(
~a[0] = Pbind(
	\instrument, \noQuarter,
	\freq, Pxrand([80,85,90,100,110]*10,inf),
	\dur, 1,
	\pan, Pxrand([-0.4,-0.8,0,0.4,0.8],inf),
	\att, Pwhite(0,0.5,inf),
	\rel, Pwhite(0.3,1,inf),
	\curve, Pxrand([5,1,-5],inf),
	\amp, Pxrand([0.2,0.04,0.06],inf)
);
)
~a.quant_(1).play;
~a.quant_(1).stop;

~a[1] = \filter -> {|in| GVerb.ar(in)}
~a[2] = \filter -> {|in| in.clip};
~a[3] = \filter -> {|in| CombL.ar(in,0.8)}
~a.set(\wet1, 0.2)
~a.set(\wet2, 0)
~a.set(\wet3, 0.3)

(
~b[0] = Pbind(
	\instrument, \bufseg1,
	\bufnum, Pxrand(d["glitch2"], inf),
	\dur, 1/4,
	\amp,1,
	\pan, Pxrand([-0.4,-0.8,0,0.4,0.8],inf)
)
)

~b.quant_(1).play;
~b.quant_(1).stop;
~b[1] = \filter -> {|in| GVerb.ar(in,roomsize:100)}
~b[2] = \filter -> {|in| in.clip};
~b[3] = \filter -> {|in| CombL.ar(in,1,decaytime:4)}

~b.set(\wet1, 0.4)
~b.set(\wet2, 0.1)
~b.set(\wet3, 0.1)



(
~c[0] = Pbind(
	\instrument, \bufseg1,
	\bufnum,d["orquesta"][6], //Pxrand(d["orquesta"], inf),
	\dur, 10,
	\amp,1,
	\pan, Pxrand([-0.4,-0.8,0,0.4,0.8],inf),
	\rate, Pxrand([0.2,0.5,1,1.5,2],inf)
)
)
~c[1] = \filter -> {|in| GVerb.ar(in,roomsize:100)};
~c[2] = \filter -> {|in| in.clip};
~c.quant_(1).play;
~c.quant_(1).stop;
~c.set(\wet1, 0.4)
~c.set(\wet2, 0,1)




 /////////       Time Stretch & Spectral Freeze /////////

// Importante!! liberar todos los buferes, rebotra el interprete y matar los servidores antes de esta operación

PV_PlayBuf

b = Buffer.read(s, "/Users/sdcarr/Desktop/My-setup-sc-live-coding/samples/set1/jazz/davisBgreen4.wav")
b.play

(
~fftsize = 8192;
~hop = 0.25;
~win = 0;
)

f = Buffer.alloc(s,b.duration.calcPVRecSize(~fftsize, ~hop));



(
{
	var sig, chain, localbuf;
	sig = PlayBuf.ar(1,b, BufRateScale.kr(b),doneAction: 2);
	localbuf = {LocalBuf.new(~fftsize)}!2;
	chain = FFT(localbuf, sig,~hop,~win);
	chain = PV_RecordBuf(chain, f, run:1, hop:~hop, wintype:~win);
	0;
}.play;
)

f.do(_.plot(minval:0, maxval:100));


(
x = {
	var sig, chain, localbuf;
	localbuf = {LocalBuf.new(~fftsize)}!2;
	chain = PV_PlayBuf(localbuf, f,\rate.kr(1), loop:1);
	sig = IFFT(chain, ~win);
}.play;
)

x.set(\rate,0);
x.set(\rate,1);
x.set(\rate, 1/10);
x.set(\rate, 1/3);
x.set(\rate,-2/3);

x.release(2);


x[0] = \filter -> {|in| GVerb.ar(in,roomsize:100)}

/////////    Lag Ugens /////////

(
SynthDef(\my_synth, {
	arg freq= 220, gate=1, freqlag= 1, freqcrv=0,amp= 0.3,out= 0;
	var sig, env;
	freq = freq.lag(freqlag, freqcrv); //Lag.kr(freq, freqlag);
	env = Env.asr().ar(2, gate);
	sig = SinOsc.ar(freq)!2;
	sig = sig * amp;
	sig = sig * env;
	Out.ar(out, sig);

}).add;
)
x = Synth(\my_synth);

x.set(\freq, 520, \freqlag,2,\freqcrv, 0);

x.set(\freq, 440, \freqlag,2,\freqcrv, 15);
x.set(\freq, 220, \freqlag,2,\freqcrv, -15);
x.set(\gate,0);



(
Pbind(
	\instrument, \my_synth,
	\freq ,Pxrand([80,85,90,95,100,110].midicps,inf),
	\dur, 1,
	\freqlag, 1
).play
)


///////////////     VarLag Ugen      /////////////////
// used to lag pitch
{
    SinOsc.ar(                              // sine wave
        VarLag.kr(                            // lag the modulator
            LFPulse.kr(1).range(100,400),   // frequency modulator
            0.8,                            // lag time
            Line.kr(-8, 8, 15, doneAction: Done.freeSelf) // modulate shape
        ),
        0,                                  // sine phase
        0.3                                 // sine amplitude
    )
}.play

// Definir un SynthDef que use Lag
(
SynthDef(\lagSynth, { |out=0, freq=440, amp=0.1, lagTime=0.1|
    var sig,env,  laggedFreq;
	env = Env.linen(0.01, 0.5, 0.8).ar(2);
    laggedFreq = Lag.kr(freq, lagTime);
    sig = SinOsc.ar(laggedFreq) * amp;
	sig = sig * env;
    Out.ar(out, sig ! 2);
}).add;
)

(
Pbind(
    \instrument, \lagSynth,
    \freq, Pwhite(200, 800, inf),  // Frecuencia aleatoria entre 200 y 800 Hz
    \lagTime, 0.7,                 // Tiempo de Lag de 0.1 segundos
    \amp, 0.1,                     // Amplitud constante
    \dur, 1                     // Duración de cada nota
).play;
)


// Definir un SynthDef que use VarLag
(
SynthDef(\varLagSynth, { |out=0, freq=440, amp=0.1, lagTime=0.1, lagCurve=0.1|
    var sig, env,laggedFreq;
	env = Env.linen(0.01, 0.5, 0.8).ar(2);
    laggedFreq = VarLag.kr(freq, lagTime, lagCurve);

    sig = SinOsc.ar(laggedFreq) * amp;
	sig = sig * env;
    Out.ar(out, sig !2);
}).add;
)

(
Pbind(
    \instrument, \varLagSynth,
    \freq, Pwhite(200, 800, inf),  // Frecuencia aleatoria entre 200 y 800 Hz
    \lagTime, 5,                 // Tiempo de Lag de 0.1 segundos
    \lagCurve, -5,                // Curvatura del Lag de 0.1
    \amp, 0.1,                     // Amplitud constante
    \dur, 1                      // Duración de cada nota
).play;
)



//////// timestretch



///////////////////////////     Miles' spectrum






(
SynthDef(\timeStretch, { |out=0, bufnum=0, rate=1|
    var sig, env;
	env = Env.linen(\atk.ir(0.05),\sus.ir(2),\rel.ir(0.5),1,\curve.ir(-5)).ar(2);
    sig = PlayBuf.ar(1, bufnum, rate, loop: 1);
    sig = sig* env;
	sig = Pan2.ar(sig,\pos.ir(0));
    Out.ar(out, sig);
}).add;
)

// Cargar un buffer de sonido
b = Buffer.read(s,"/Users/sdcarr/Desktop/davisInterview27.wav");
b.play
// Crear un synth para el time stretching
x = Synth(\timeStretch, [\bufnum, b, \rate, 0.2]);
x = Synth(\grainbuf, [\bufnum, b, \rate, 1]);

(
~a = Pbind(
    \instrument, \timeStretch,
	\bufnum, Pxrand(d["jazz"],inf),  // Frecuencia aleatoria entre 200 y 800 Hz
   \pos, Pxrand([-0.3,-0.6,0,0.3,0.6],inf),
	\rate, Pxrand([0.5,0.6,1,1.2,1.5],inf),
	\legato, 1,
    \amp, 0.1,                     // Amplitud constante
    \dur, 2                      // Duración de cada nota
);
)

~a.quant_(1).play;
~a.stop;


~a[1] = \filter -> {|in| GVerb.ar(in,roomsize:100, maxroomsize:1000)};
~a[2] = \filter -> {|in| in.clip}
~a[3] = \filter -> {|in| CombL.ar(in,maxdelaytime:0.8,delaytime:0.5,decaytime:0.5)}
~a[4] = \filter -> {|in| BrownNoise.ar(in)}
~a.set(\wet1, 0.6)
~a.set(\wet2, 0)
~a.set(\wet3, 0.5)
~a.set(\wet4, 0)



d["jazz"][1].play

// Miles speech
(
~b[0] = Pbind(
	\instrument, \grainbuf,
	\buf, b,
	\atk, 0.5,
	\sus, Pwhite(1,3,inf),
	\rate,1, //Pxrand([0.8,1.8,1,0.2,2],inf),
	\timescale, 1,//Pgauss(0.1, 10, inf),
	\mgra,500,
	\dur , 5,
	\amp, 0.3
)
)
Pattern
~b.quant_(1).play;
~b.clear
~b.stop

~b[1] = \filter -> {|in| GVerb.ar(in,roomsize:100, maxroomsize:1000)};
~b[2] = \filter -> {|in| GrainBuf.ar(sndbuf:in,maxGrains:1000)};

~b.set(\wet1, 0.2)
~b.set(\wet2, 0.8)


// perc


(
~c[0] = Pbind(
	\instrument, \bufseg1,
	\bufnum, Pxrand(d["glitch2"],inf),
	\pan, Pwhite(-0.5, 0.5,inf),
	\dur, 1/4,
	\amp,0.3,

	\rate, Pwhite(2,3,inf)

)
)

GrainBuf

~c.quant_(1).play;
~c.stop;
~c[1] = \filter -> {|in| GVerb.ar(in,roomsize:100, maxroomsize:1000)};

~c.set(\wet1, 0.3)



~off = Tdef(\off, {

	~b.stop;
	4.wait;
	~c.stop;
	4.wait;
	~a.stop;
	10.wait;
});


~on = Tdef(\on, {
	~a.play;
	10.wait;
	~b.play;
	4.wait;
	~c.play;
	4.wait;
});

