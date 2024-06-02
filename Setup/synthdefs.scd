// Biblioteca SynthDef

///////////////////////// Drones ///////////////////////////////////////////

SynthDef(\bplay, {
	var sig, env;
	env =     env = Env.new([0,0.70,0.70,0], [\dur.ir(55)*0.333,\dur.ir*0.333,\dur.ir*0.333]).ar(2);
	sig = PlayBuf.ar(2,\buf.ir(0),\rate.ir(1),1, \spos.ir(0));
	sig = sig * env;
	sig = Pan2.ar(sig, \pos.ir(0));
	Out.ar(\out.kr(0),sig)
}).add;



// FUENTE: https://recarteblog.wordpress.com/
//droneFM01


SynthDef(\droneFM, {
	arg f1Freq=0.1, f2Freq=1.1, f3Freq=2.2, nFreq=440, m1Ratio=1, m2Ratio=2, m3Ratio=3,
	amp=0.1, dur=55, ampM=0.84 , pan=0;
	var sig, car1, mod1, car2, mod2, car3, mod3, env, index;
	index = LFNoise1.kr(0.2).range(2, 12);
	env = EnvGen.kr(Env.new([0, 0.70, 0.70, 0], [dur*0.333, dur*0.333, dur*0.333]), doneAction:2);
	mod1 = SinOsc.ar([nFreq * m1Ratio, nFreq+0.7 * m1Ratio], mul:nFreq * m1Ratio * index) * ampM;
	car1 = SinOsc.ar(f1Freq + mod1);

	mod2 = SinOsc.ar([nFreq * m2Ratio, nFreq+1.4 * m2Ratio], mul:nFreq * m2Ratio * index) * ampM;
	car2 = SinOsc.ar(f2Freq + mod2);

	mod3 = SinOsc.ar([nFreq * m3Ratio, nFreq+0.35 * m3Ratio], mul:nFreq * m3Ratio * index) * ampM;
	car3 = SinOsc.ar(f3Freq + mod3) * 0.4;
	sig = car1 + car2 + car3 * env * amp;
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig);
}).add;






SynthDef(\droneFMPulse, {
    var sig, sig1, sig2, sig3, mod1, mod2, mod3, env, index;
    index = LFNoise1.kr(0.5).range(2,12);

    env = Env.new([0,0.70,0.70,0], [\dur.ir(55)*0.333,\dur.ir*0.333,\dur.ir*0.333]).ar(2);


    mod1 = SinOsc.ar([\nfreq.kr(440)*\m1Ratio.kr(1), \nfreq.kr +1.4* \m1Ratio.kr], 0.0,\amp.kr(440)* \m1Ratio.kr * index) * \ampM.kr(0.84);
    sig1 = LFPulse.ar(\f1freq.kr(0.1) + mod1);

      mod2 = SinOsc.ar([\nfreq.kr(440)*\m2Ratio.kr(2), \nfreq.kr +0.7* \m2Ratio.kr], 0.0,\amp.kr* \m2Ratio.kr * index) * \ampM.kr(0.84);
    sig2 = LFPulse.ar(\f2freq.kr(1.1) + mod2);



         mod3 = SinOsc.ar([\nfreq.kr(440)*\m3Ratio.kr(3), \nfreq.kr +0.35* \m3Ratio.kr], 0.0,\amp.kr* \m3Ratio.kr * index) * \ampM.kr(0.84);
    sig3 = LFPulse.ar(\f3freq.kr(2.2) + mod3);

    sig = sig1 * sig2 *sig3 *env * 0.3;
    sig = Pan2.ar(sig, \pan.kr(0));

    Out.ar(\out.kr(0), sig1);
}).add;



SynthDef(\dron, {
    | freq = 440, amp = 0.5, dur = 60 |
    var sig, mod, env;
    mod = SinOsc.ar(5 , 0, 0.5,1);
     sig = Resonz.ar( Saw.ar(freq, amp),1000,\rq.ir(1));

    sig = sig + mod;
     env = EnvGen.kr(Env.linen(2, dur, 2), doneAction: 2);
    sig = sig * env;
    //sig = FreeVerb.ar(sig, 0.5, 3, 1);
    Out.ar(0, sig ! 2); // Salida estéreo
}).add;

// Para reproducir el dron
//Synth(\dron, [\freq, 80,\rq, 2]);




// Establece la frecuencia fundamental
~freqFundamental = 80;

// Crea un dron con DFM1
SynthDef(\dronDFM1, {
    var sig, filtro, env;
    // Genera una onda senoidal como fuente de sonido
    sig = SinOsc.ar([~freqFundamental, ~freqFundamental * 1.01], 0, 0.1);
    // Modula la resonancia del filtro para que entre y salga de la auto-oscilación
    filtro = DFM1.ar(
        sig,
        ~freqFundamental * 2, // Frecuencia de corte del filtro
        SinOsc.kr(0.05).range(0.9, 1.1), // Resonancia modulada
        1, // Ganancia de entrada
        0, // Tipo de filtro: 0 para paso bajo
        0.0003, // Nivel de ruido
        0.5 // Escala la salida
    );
    // Usa una envolvente para controlar la duración del dron
    env = EnvGen.kr(Env.linen(10, 60, 10), doneAction: 2);
    filtro = filtro * env;
    // Salida estéreo
    Out.ar(0, filtro ! 2);
}).add;



// pad

SynthDef(\pad, {
    var sig, env;

    env = Env.asr(1.0,1,1.0).ar(Done.freeSelf, \gate.kr(1));

    sig = Saw.ar(\freq.kr(440)* (LFNoise2.kr(3!8)*0.2).midiratio* [1,2,1,2,2,1,2,1]);
    sig = BPF.ar(sig, {ExpRand(200,900)}!sig.size,0.2)*9.dbamp;
    sig = Splay.ar(sig, 0.3);
    sig = (sig * 10.dbamp).tanh;
    sig = Pan2.ar(sig , \pan.kr(0));
    sig = sig * env;
    sig = sig * -18.dbamp;
    Out.ar(\out.kr(0), sig)
}).add;






//////////////////////// FX /////////////////////////////////////


SynthDef(\fx, {
    var sig, fb;
    sig = In.ar(\out.kr(0),2);
    [0.2,0.3,0.35].do{ |windowSize|

        sig = sig + PitchShift.ar(sig * ToggleFF.ar(Dust.ar(4))* -123.dbamp, windowSize, 2);
    };

    sig = sig + LocalIn.ar(2);
    fb = sig;
    fb = DelayC.ar(fb, 3.0, [2.0,3.0]);
    fb = LPF.ar(fb, 3000);
    fb = HPF.ar(fb, 100);
    fb = fb* -2.dbamp;
    fb = Limiter.ar(fb);
    LocalOut.ar(fb);
    sig = LeakDC.ar(sig);
    sig = Limiter.ar(sig);
    ReplaceOut.ar(\out.kr(0), sig)
}).add;

/*
(


var a, b, c, n;



n = 40; // how many synths to create



// 3 different processes

a = { arg freq, amp, pan;

	Pan2.ar(SinOsc.ar(freq), pan, amp)};

b =  { arg amp, pan, freq;

	Pan2.ar(RLPF.ar(Saw.ar(freq), freq * 6, 0.1), pan, amp)};

c =  { arg pan, freq, amp;

	Pan2.ar(Resonz.ar(GrayNoise.ar, freq * 2, 0.1), pan, amp * 2)};



// a task to automatically create the synthdefs

*/
















