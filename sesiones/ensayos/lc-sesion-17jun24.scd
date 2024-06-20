("../Setup/Setup.scd").loadRelative

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

T3	R1	M2	G5	B6	D1

~t3 = Pbind(
	\instrument, \ping_mh,
	\dur, 1/4,
	\midinote, Pxrand([
		[72.0, 76.99999999998,  80.999999999964, 88.99999999998, 92.999999999964]+6,
		[72.0, 76.99999999998, 80.999999999964, 88.99999999998, 92.999999999964],
		[72.0, 76.99999999998, 80.999999999964, 88.99999999998, 92.999999999964 ]-6,
		[72.0, 76.99999999998, 80.999999999964, 88.99999999998,92.999999999964 ]-12,
	]-12,inf),
	\detune, 0,
	\cfmin,100,
	\cfmax, 1500,
	\atk,0.02,
	\rel,0.1,
	\ldb, 0.2,
	\amp,0.03,
	\out,0
)


~m2 = Pbind(

	\instrument, \plucking,
	\scale, Scale.zhi,
	\octave, 4,
	\degree, Pseq([ 0, 2, 5, 7, 9 ], inf), // four main notes
	\mtranspose, Pseq([Pseq([0],3),Pseq([-5],3)],inf), // switched mode every 3 notes (*2)

	\gtranspose, Pseq([Pseq([0],36),Pseq([4],36),Pseq([[-3]],36),Pseq([2],36)],inf),
	\ctranspose, Pser([Pseries(-4,1,6) +.x Pseq([0], 144)],1),

	\coef, Pser([Prand([0.2,0.3,0.4,0.5],1), Prand([0.8,0.7,0.6,0.5],11)], inf),
	\dur, Prand([0.25,0.26,0.24,0.255,0.255,0.25], inf) * 0.9,
	\decay, Prand([1,2,3,4,5], inf),
	\out, b,
    \amp, 0.4,
)

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

~g5 = Pbind(
	\instrument, \pbufs,
	\buf, Pxrand(d["pajaros"], inf),
	\dur, Pseq([1/2,1/2],inf),
	\rate, Pwhite(0.5,1.5,inf),
	\amp,2,// Pwhite(0.4,1.0,inf),
	\atk, 4,
	\sus, 2,
	\rel, 0.5,
	\rate,1,// Pxrand()
)

stutter
~b3.play(p.clock)
~b6.stop
(
Pbind(
	\instrument, \bass,
	\freq, 70 * Pseq([0,1].midiratio,inf).stutter(16) * Pseq([1,2],inf).stutter(64),
	\fmrange, Pseq([0.5,1,1.5],inf),
	\fmfreq, Pseq([0.5,1,2,4],inf),
	\dur, 1/4,
	\igate, Pseq([
		1,0,0,0,
		0,0,0,0,
	],inf),
	\iadsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,4.1) ],
	],inf),
	\lpf, Pkey(\freq) * Pseq([
		2,1,4,8,
		2,1,4,8,
		2,1,4,8,
		4,2,2,4,
	],inf).stutter(8),
	\hpf, Pkey(\freq) / 2,

	\amp, Pkey(\amp) * 2,
	\isRest, false,
)
~b3 = Pbind(
	\instrument, \bass,
	\freq, 70 * Pseq([0,1].midiratio,inf).stutter(16) * Pseq([1,2],inf).stutter(64),
	\fmrange, Pseq([0.5,1,1.5],inf),
	\fmfreq, Pseq([0.5,1,2,4],inf),
	\dur, 1/4,
	\igate, Pseq([
		1,0,0,0,
		0,0,0,0,
	],inf),
	\iadsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,4.1) ],
	],inf),
	\lpf, Pkey(\freq) * Pseq([
		2,1,4,8,
		2,1,4,8,
		2,1,4,8,
		4,2,2,4,
	],inf).stutter(8),
	\hpf, Pkey(\freq) / 2,

	\amp, Pkey(\amp) * 2,
	\isRest, false,
)
~b3.play
~r = {54};
~dfm1 = {arg mult = 1; DFM1.ar(SinOsc.ar([~r,~r*1.01]*mult,0,0.1),(~r*2)*mult,SinOsc.kr(0.05).range(0.9,1.1),1,0,0.0003,0.5)};
~dfm2 = {arg mult = 2; DFM1.ar(SinOsc.ar([~r,~r*1.01]*mult,0,0.1),(~r*2)*mult,SinOsc.kr(0.06).range(0.9,1.1),1,0,0.0003,0.5)};
~dfm3 = {arg mult = 3; DFM1.ar(SinOsc.ar([~r,~r*1.01]*mult,0,0.1),(~r*2)*mult,SinOsc.kr(0.056).range(0.9,1.1),1,0,0.0003,0.5)};
~dfm4 = {arg mult = 4; DFM1.ar(SinOsc.ar([~r,~r*1.01]*mult,0,0.1),(~r*2)*mult,SinOsc.kr(0.07).range(0.9,1.1),1,0,0.0003,0.5)};
~dfm5 = {arg mult = 4;DFM1.ar(SinOsc.ar([~r, ~r*1.02] * mult, 0, 0.1),(~r * 1.5) * mult,SinOsc.kr(0.1).range(0.8, 1.2),1,0,0.0004, 0.6)};
~dfm6 = {arg mult = 4;DFM1.ar(Pulse.ar([~r, ~r*1.03] * mult, 0.5, 0.1),(~r * 2.5) * mult,LFTri.kr(0.05).range(0.7, 1.3),1,0,0.0002,0.4)};
);
~dfm1.play;~dfm2.play;~dfm3.play;~dfm4.play;~dfm5.play;~dfm6.play
~dfm1.stop

~mix = { }
~r1.play
~t3.play

~g5.play

~b6.play
~m2.play



~off = Tdef(\off, {
	~r1.stop;
	6.wait;
	~b6.stop;
	6.wait;
	~t3.stop;
	6.wait;
	~dfm1.stop;
	4.wait;
	~m2.stop;
	4.wait
})


~mix = {}

~g5.stop

[72.0, 76.0,  80.0, 88.0, 92.0].midicps.round

SynthDef(\bass, { arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;
	var sig, sig1, sig2, sig3;
	freq = SinOsc.ar(freq*\fmfreq.kr(1).lag(0.3)) * \fmrange.kr(0.5).lag(0.3) * LFNoise1.kr(1/7).range(0.9,1.1) + 1 * freq;
	sig = SinOsc.ar(freq.lag(0.1) * [1,8,2,4,1.002]);
	sig1 = LFPulse.ar(freq * [1,4,1.001,2 * LFNoise1.kr(1/10).range(0.999,1.001),1/2], mul:1.00);
	sig = sig + sig1;
	sig = sig.fold2(SinOsc.kr(1/13).range(0.9,1));
	sig = sig.wrap2(SinOsc.kr(1/14).range(0.9,1));
	sig = RLPF.ar(sig, \lpf.kr(500).lag(0.4) * LFNoise1.kr(1/9).range(0.9,1.1), \rq.kr(0.5));
	sig = HPF.ar(sig, \hpf.kr(40));
	sig = sig * EnvGen.ar(\iadsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),\igate.kr(1),doneAction:0);
	sig = sig * EnvGen.ar(\adsr.kr(Env.adsr(0.01,0.1,0.8,0.1)),gate,doneAction:doneAction);
	sig = Splay.ar(sig, spread, amp, pan);
	Out.ar(out, sig);
}).add;

Pdef(\bass).stop


(
Pdef(\bass, Pmono(\bass,
	\freq, 70 * Pseq([0,1].midiratio,inf).stutter(16) * Pseq([1,2],inf).stutter(64),
	\fmrange, Pseq([0.5,1,1.5],inf),
	\fmfreq, Pseq([0.5,1,2,4],inf),
	\dur, 1,
	\igate, Pseq([
		1,0,0,0,
		0,0,0,0,
	],inf),
	\iadsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,4.1) ],
	],inf),
	\lpf, Pkey(\freq) * Pseq([
		2,1,4,8,
		2,1,4,8,
		2,1,4,8,
		4,2,2,4,
	],inf).stutter(8),
	\hpf, Pkey(\freq) / 2,

	\amp, Pkey(\amp) * 2,
	\isRest, false,
));
Pdef(\bass).play;
)


Pbind(
	\instrument, \bass,
	\freq, 70 * Pseq([0,1].midiratio,inf).stutter(16) * Pseq([1,2],inf).stutter(64),
	\fmrange, Pseq([0.5,1,1.5],inf),
	\fmfreq, Pseq([0.5,1,2,4],inf),
	\dur, 1/4,
	\igate, Pseq([
		1,0,0,0,
		0,0,0,0,
	],inf),
	\iadsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,4.1) ],
	],inf),
	\lpf, Pkey(\freq) * Pseq([
		2,1,4,8,
		2,1,4,8,
		2,1,4,8,
		4,2,2,4,
	],inf).stutter(8),
	\hpf, Pkey(\freq) / 2,

	\amp, Pkey(\amp) * 2,
	\isRest, false,
).play;
Pdef(\bass).play;
)

////////////


~b3 = Pbind(
	\instrument, \bass,
	\freq, 70 * Pseq([0,1].midiratio,inf).stutter(16) * Pseq([1,2],inf).stutter(64),
	\fmrange, Pseq([0.5,1,1.5],inf),
	\fmfreq, Pseq([0.5,1,2,4],inf),
	\dur, 1/4,
	\igate, Pseq([
		1,0,0,0,
		0,0,0,0,
	],inf),
	iadsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,4.1) ],
	],inf),
	\lpf, Pkey(req) * Pseq([
		2,1,4,8,
		2,1,4,8,
		2,1,4,8,
		4,2,2,4,
	],inf).stutter(8),
	\hpf, Pkey(req) / 2,

	\amp, Pkey(amp) * 2,
	\isRest, false,
)

~b3.play
~mix = {~b3}

~b3 = Pbind(
	\instrument, \bass,
	\freq, 70 * Pseq([0,1].midiratio,inf).stutter(16) * Pseq([1,2],inf).stutter(64),
	\fmrange, Pseq([0.5,1,1.5],inf),
	\fmfreq, Pseq([0.5,1,2,4],inf),
	\dur, 1/4,
	\igate, Pseq([
		1,0,0,0,
		0,0,0,0,
	],inf),
	\iadsr, Pseq([
		[ Env.adsr(0.1,0.1,0.8,4.1) ],
	],inf),
	\lpf, Pkey(\freq) * Pseq([
		2,1,4,8,
		2,1,4,8,
		2,1,4,8,
		4,2,2,4,
	],inf).stutter(8),
	\hpf, Pkey(\freq) / 2,

	\amp, Pkey(\amp) * 2,
	\isRest, false,
)
/////////





~freq = {[60,62,64,69].midicps}
~padmod = {LFTri.kr(4).exprange(0.1,0.3)}

~freq ={([72,74,65,69]+.x[0,0.1]).midicps * 0.midiratio};
~freq.reshaping_(\elastic);

~freq.quant_(nil)
~freq.fadeTime_(1)

~freq = {[60,62,64,69,70].midicps}
(
~pad = {
	var sig;
	sig = LFTri.ar(~freq.kr)* 0.2;
	sig = sig * ~padmod.kr(1);
}
)
~pad.stop;
~pad.play
~padmod = {LFTri.kr(4).exprange(0.1,0.3)}


[72,34,56,78]+ .t [0,1]

////////////////


~pad.play
~pad.stop
~freq ={([70,72,63,66]+.x[0,0.2]).midicps * -7.midiratio};
(
~pad[0] = {
	var sig;
	sig = LFTri.ar(~freq.kr)* 0.2;
	sig = sig * ~padmod.kr(1);
}
)
Tdef(\freq).play(p.clock)


(
Tdef(\freq, {
	loop{
		([0,-5,-7,-12]-12).do({ |i|
			~freq ={([72,74,65,69] +.x[0,0.2]).midicps * i.midiratio};
			8.wait;
		})
	}
}).play;
)
~padmod = {LFTri.kr(t.tempo * 2).exprange(0.02,0.3)}
Tdef(\freq).play

~mix = {}

~pad[1] = \filter -> {|in| CombL.ar(in, 2,t.beatDur*2*3/4,10, 0.75 )}

~pad.set(\wet1, 0);

~g1.play(p.clock)

~g1[0] = Pbind(
	\instrument, \chaosGlitch2,
	\dur, 2,
	\len, Pseq([1, 1.5, 1.75, 2]+10,inf),
	\henA, Pseq([2, 1.3, 1.29, 1.25], inf),
	\henB, Pseq([0.2, 0.3], inf),
	\t, Pseq([2, 4, 2, 6], inf),
	\fundFreq, Pseq([40, 600, 8000, 200, 600, 6000], inf),
	\amp,0.1
)

~g1.pause;
~mix = {}
~g1[1] = \filter -> {|in| CombL.ar(in, 22,t.beatDur*2*3/4,10, 0.75 )}


~g2 = Pbind(
\instrument, \hasherTest,
\dur, 1,
\rate, Pfuncn({100.rand}, inf),
\freq, Pfuncn({10000.rand}, inf),
\index, Pfuncn({20000.rand}, inf),
\tRate, Pfuncn({1000.rand}, inf),
\fRate, Pxrand([2,5,7,9],inf),
\amp, 0.2
)


~g5.play
~g5.stop


~mix = {~g5 }
~g5[0] = Pbind(
	\instrument, \pbufs,
	\buf, Pxrand(d["pajaros"], inf),
	\dur, 1/4,
	\rate, Pwhite(0.5,1.5,inf),
	\amp, 3,//Pwhite(0.4,1.0,inf),
	\atk, 2,
	\sus, 2,
	\rel, 0.5
)

~g5.play;
~mix = {}
~g5[1] = \filter -> {|in| CombL.ar(in, 100,t.beatDur*2*3/4,10, 0.75 )}
~g5[2] = \filter -> {|in| Saw.ar(1000*[1,0.996])*in!2}
~g5[3] = \filter -> {|in| in.clip}
~g5.set(\wet2, 0);
~g5.set(\wet3, 0);






~g6 = Pbind(
	\instrument, \pbufs,
	\buf, Pxrand(d["orquesta"], inf),
	\dur, 1/2,
	\rate, Pwhite(0.5,1.5,inf),
	\amp, Pwhite(0.1,4.0,inf),
	\atk, 2,
	\sus, 2,
	\rel, 0.5,

)


~g6.stop;
~mix = {}
~g6[1] = \filter -> {|in| CombL.ar(in, 0.08,0.07,2.5)}
~g6[2] = \filter -> {|in| SinOsc.ar(1000*[1,0.996])*in!2}
~g6[3] = \filter -> {|in| in.clip}
~g6.set(\wet1, 0);
~g6.set(\wet2, 0);
~g6.set(\wet3, 0);


~g2.play
~g2 = Pbind(
\instrument, \hasherTest,
\dur, Pxrand([2,5,7,9],inf),
\rate, Pfuncn({100.rand}, inf),
\freq, Pfuncn({10000.rand}, inf),
\index, Pfuncn({20000.rand}, inf),
\tRate, Pfuncn({1000.rand}, inf),
\fRate, Pxrand([2,5,7,9],inf),
\amp, 0.2
)




SynthDef.new(\varsawPerc, {
		arg	freq=40, detune=0.2, atk=0.05, sus=0, rel=1, cAtk=1, cRel=(-4),
		dutyLo=0.001, dutyHi=0.999, freqRandLo=0.1, freqRandHi=0.3, rq=0.25,
		lpfA=5000, lpfB=200, lpfC=100, lpfAtk=0.05, lpfSus=0, lpfRel=1,
		lpfC1=(-3), lpfC2=(-2), lpfMul=1, lpfAdd=0,
		amp=1, pan=0, out=0, thresh=(-6), ratio=8;
		var	sig, temp, env;
		sig = 0;
		env = Env([0,1,1,0],[atk,sus,rel],[cAtk,0,cRel]).kr(2);
		4.do{
			temp = VarSaw.ar(
				freq * LFNoise1.kr({Rand(freqRandLo,freqRandHi)}!2).bipolar(detune).midiratio,
				Rand(0.0, 1.0),
				ExpRand(dutyLo,dutyHi)
			);
			temp = RLPF.ar(
				temp,
				Env([lpfA,lpfB,lpfB,lpfC],[lpfAtk,lpfSus,lpfRel],[lpfC1,0,lpfC2]).ar(0,1,1,lpfMul,lpfAdd),
				rq
			);
			temp = temp * 0.1;
			sig = sig + temp;
		};
		sig = sig * env;
		sig = Balance2.ar(sig[0], sig[1], pan, amp);
		sig = Compander.ar(sig, sig, thresh.dbamp, 1, 1/ratio);
		sig = sig.tanh;
		Out.ar(out, sig);
	}).add;

//synthdefs
	SynthDef(\reverb, {
		arg in=60, out=0, amp=1, mix=0.06, lpf=5000, revTime=2.5, preDel=0.05;
		var wet, dry, temp, sig;
		mix = mix.clip(0,1);
		dry = In.ar(in, 2);
		temp = In.ar(in, 2);
		wet = 0;
		temp = DelayN.ar(temp, preDel, preDel);
		16.do{
			temp = AllpassN.ar(temp, 0.06, {Rand(0.001,0.06)}!2, revTime);
			temp = LPF.ar(temp, lpf);
			wet = wet + temp;
		};
		sig = XFade2.ar(dry, wet, mix*2-1, amp);
		Out.ar(out, sig);
	}).add;

Synth(\reverb)
(
~z= Pbind(
	\instrument, \feedbackPad3,
	\dur, 0.25,
	\midinote, Pseq([33,45,57,60,62,64,67,72,79],1),
	\atk, 0.01,
	\rel, 3,
	\c2, -2,
	\lpfMul, 0,
	\lpfAdd, Pkey(\midinote).midicps * Pexprand(1.5,3),
	\dutyLo, Pgeom(0.8,0.8,12),
	\dutyHi, Pkey(\dutyLo),
	\amp, Pexprand(0.15,0.2),
	\pan, Pwhite(-0.3,0.3),
	\out, ~bus[\reverb1],
).play(t);
)
Synth( \feedbackPad3)