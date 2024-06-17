
// Define las matrices de Pbinds con nombres específicos
// Texturas
// ritmo
// melodias
// Glitch
// Bass
// drones


~texturas = [
	// Yu
~t1 = Pbind(
	\instrument, \bpfsaw,
	\dur, 5,
	\midinote, Pxrand([
		[72.0, 78.999999999972, 84.0, 88.99999999998, 96.0 ],
		[72.0, 78.999999999972, 84.0, 88.99999999998, 96.0 ]+9,
		[72.0, 78.999999999972, 84.0, 88.99999999998, 96.0 ]+4,
		[72.0, 78.999999999972, 84.0, 88.99999999998, 96.0 ],
	]-12,inf),
	\detune, 0.08,
	\cfmin,100,
	\cfmax, 1500,
	\atk,2,
	\rel,8,
	\ldb, 6,
	\amp,0.2,
	\out,0
),
	// zhi
	~t2 = Pbind(
	\instrument, \bpfsaw,
	\dur, 5,
	\midinote, Pxrand([
		[72.0, 76.99999999998, 84.0, 88.99999999998, 92.999999999964],
		[72.0, 76.99999999998, 84.0, 88.99999999998, 92.999999999964]+9,
		[72.0, 76.99999999998, 84.0, 88.99999999998, 92.999999999964 ]+4,
		[72.0, 76.99999999998, 84.0, 88.99999999998,92.999999999964 ],
	]-12,inf),
	\detune, 0.08,
	\cfmin,100,
	\cfmax, 1500,
	\atk,2,
	\rel,8,
	\ldb, 6,
	\amp,0.2,
	\out,0
),
	// gong
	 ~t3 = Pbind(
	\instrument, \bpfsaw,
	\dur, 5,
	\midinote, Pxrand([
		[72.0, 76.99999999998,  80.999999999964, 88.99999999998, 92.999999999964]-24,
		[72.0, 76.99999999998, 80.999999999964, 88.99999999998, 92.999999999964]+9,
		[72.0, 76.99999999998, 80.999999999964, 88.99999999998, 92.999999999964 ]+4,
		[72.0, 76.99999999998, 80.999999999964, 88.99999999998,92.999999999964 ]-12,
	]-12,inf),
	\detune, 0.08,
	\cfmin,100,
	\cfmax, 1500,
	\atk,2,
	\rel,8,
	\ldb, 6,
	\amp,0.2,
	\out,0
),

	//chinese

	~t4 = Pbind(
	\instrument, \bpfsaw,
	\dur, 5,
	\midinote, Pxrand([
		[72.0, 82.999999999956,  87.999999999985, 89.999999999976, 99.999999999984]-24,
		[72.0, 82.999999999956, 87.999999999985, 89.999999999976, 99.999999999984]+9,
		[72.0, 82.999999999956, 87.999999999985, 89.999999999976, 99.999999999984]+4,
		[72.0, 82.999999999956, 87.999999999985, 89.999999999976,99.999999999984 ]-12,
	]-12,inf),
	\detune, 0.08,
	\cfmin,100,
	\cfmax, 1500,
	\atk,2,
	\rel,8,
	\ldb, 6,
	\amp,0.2,
	\out,0
),
	// shang
	~t5 0 Pbind(
	\instrument, \bpfsaw,
	\dur, 5,
	\midinote, Pxrand([
		[72.0, 76.99999999998, 84.0, 89.999999999976, 96.0]-24,
		[72.0, 76.99999999998, 84.0, 89.999999999976, 96.0]+9,
		[72.0, 76.99999999998, 84.0, 89.999999999976, 96.0]+4,
		[72.0, 76.99999999998, 84.0, 89.999999999976, 96.0]-12,
	]-12,inf),
	\detune, 0.08,
	\cfmin,100,
	\cfmax, 1500,
	\atk,2,
	\rel,8,
	\ldb, 6,
	\amp,0.2,
	\out,0
),

	// Lü (Gongchepu)
	~t6 =  Pbind(
	\instrument, \bpfsaw,
	\dur, 5,
	\midinote, Pxrand([
		[ 72.0, 76.99999999998, 81.99999999996, 84.0, 88.99999999998, 93.99999999996, 97.999999999992 ],
		[ 72.0, 76.99999999998, 81.99999999996, 84.0, 88.99999999998, 93.99999999996, 97.999999999992 ]+9,
		[ 72.0, 76.99999999998, 81.99999999996, 84.0, 88.99999999998, 93.99999999996, 97.999999999992 ]+4,
		[ 72.0, 76.99999999998, 81.99999999996, 84.0, 88.99999999998, 93.99999999996, 97.999999999992 ]-12,
	]-12,inf),
	\detune, 0.08,
	\cfmin,100,
	\cfmax, 1500,
	\atk,2,
	\rel,8,
	\ldb, 6,
	\amp,0.2,
	\out,0
)];


~ritmo = [
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

	),
	~r2 = Pbind(
		\instrument, \bufsynth,

		\buf, Pxrand(d["pajaros"],inf),
		\dur, 1/2,
		\rate, Pwhite(1.0,5.0,inf),
		\spos,0,
		\amp, 0.8,
		\atk, 0.5,
		\sus, Pwhite(0.0,0.15),
		\rel, 0.1,
		\cur,1,
		\pan, Prand([-1,0, 1],inf)

	),
	~r3 =Pbind(
		\instrument, \bufsynth,

		\buf, Pxrand(d["shout"],inf),
		\dur, 0.25,
		\rate, Pwhite(1.0,5.0,inf),
		\spos,0,
		\amp, 14.dbamp,
		\atk, 0.5,
		\sus, Pwhite(0.0,0.15),
		\rel, 0.1,
		\cur,1,
		\pan, Prand([-1,0, 1],inf)

	),
	~r4 =Pbind(
		\instrument, \bufsynth,

		\buf, Pxrand(d["voces"],inf),
		\dur, 1/4,
		\rate, Pwhite(0.8,1.5,inf),
		\spos,Pwhite(0.0,0.8,inf),
		\amp, 2.dbamp,
		\atk, 0.05,
		\sus, Pwhite(0.0,0.15),
		\rel, 0.1,
		\cur,1,
		\pan, Prand([-1,0, 1],inf)

	),
	~r5 =Pbind(
		\instrument, \bufsynth,

		\buf, Pxrand(d["etnico"],inf),
		\dur, 2,
		\rate, Pwhite(0.8,1.5,inf),
		\spos,Pwhite(0.0,0.8,inf),
		\amp, 1.dbamp,
		\atk, 0.5,
		\sus, Pwhite(0.0,0.15),
		\rel, 1,
		\cur,1,
		\pan, Prand([-1,0, 1],inf)

	),
	~r6 = Pbind(
		\instrument, \bufsynth,

		\buf, Pxrand(d["agua"],inf),
		\dur, 1/4,
		\rate, Pwhite(0.8,1.5,inf),
		\spos,Pwhite(0.0,0.8,inf),
		\amp, 4.dbamp,
		\atk, 0.05,
		\sus, Pwhite(0.0,0.15),
		\rel, 0.5,
		\cur,-4,
		\pan, Prand([-1,0, 1],inf)

	)
];


~melodia = [

// yu
	~m1 = Pbind(

	\instrument, "plucking",
	\scale, Scale.yu.tuning_(\just),
	\octave, 4,
	\degree, Pseq([0, 3, 5, 7, 10], inf), // four main notes
	\mtranspose, Pseq([Pseq([0],3),Pseq([-5],3)],inf), // switched mode every 3 notes (*2)

	\gtranspose, Pseq([Pseq([0],36),Pseq([4],36),Pseq([[-3]],36),Pseq([2],36)],inf),
	\ctranspose, Pser([Pseries(-4,1,6) +.x Pseq([0], 144)],1),

	\coef, Pser([Prand([0.2,0.3,0.4,0.5],1), Prand([0.8,0.7,0.6,0.5],11)], inf),
	\dur, Prand([0.25,0.26,0.24,0.255,0.255,0.25], inf) * 0.9,
	\decay, Prand([1,2,3,4,5], inf),
	\out, b, \amp, 0.4,
),
	// zhi

		~m2 = Pbind(

	\instrument, "plucking",
	\scale, Scale.zhi.tuning_(\just),
	\octave, 4,
	\degree, Pseq([ 0, 2, 5, 7, 9 ], inf), // four main notes
	\mtranspose, Pseq([Pseq([0],3),Pseq([-5],3)],inf), // switched mode every 3 notes (*2)

	\gtranspose, Pseq([Pseq([0],36),Pseq([4],36),Pseq([[-3]],36),Pseq([2],36)],inf),
	\ctranspose, Pser([Pseries(-4,1,6) +.x Pseq([0], 144)],1),

	\coef, Pser([Prand([0.2,0.3,0.4,0.5],1), Prand([0.8,0.7,0.6,0.5],11)], inf),
	\dur, Prand([0.25,0.26,0.24,0.255,0.255,0.25], inf) * 0.9,
	\decay, Prand([1,2,3,4,5], inf),
	\out, b, \amp, 0.4,
),


	// Gong
		~m3 = Pbind(

	\instrument, "plucking",
	\scale, Scale.gong.tuning_(\just),
	\octave, 4,
	\degree, Pseq([ 0, 2, 4, 7, 9 ], inf), // four main notes
	\mtranspose, Pseq([Pseq([0],3),Pseq([-5],3)],inf), // switched mode every 3 notes (*2)

	\gtranspose, Pseq([Pseq([0],36),Pseq([4],36),Pseq([[-3]],36),Pseq([2],36)],inf),
	\ctranspose, Pser([Pseries(-4,1,6) +.x Pseq([0], 144)],1),

	\coef, Pser([Prand([0.2,0.3,0.4,0.5],1), Prand([0.8,0.7,0.6,0.5],11)], inf),
	\dur, Prand([0.25,0.26,0.24,0.255,0.255,0.25], inf) * 0.9,
	\decay, Prand([1,2,3,4,5], inf),
	\out, b, \amp, 0.4,
),
	// chinese

			~m4 = Pbind(

	\instrument, "plucking",
	\scale, Scale.chinese.tuning_(\just),
	\octave, 4,
	\degree, Pseq([ 0, 4, 6, 7, 11 ], inf), // four main notes
	\mtranspose, Pseq([Pseq([0],3),Pseq([-5],3)],inf), // switched mode every 3 notes (*2)

	\gtranspose, Pseq([Pseq([0],36),Pseq([4],36),Pseq([[-3]],36),Pseq([2],36)],inf),
	\ctranspose, Pser([Pseries(-4,1,6) +.x Pseq([0], 144)],1),

	\coef, Pser([Prand([0.2,0.3,0.4,0.5],1), Prand([0.8,0.7,0.6,0.5],11)], inf),
	\dur, Prand([0.25,0.26,0.24,0.255,0.255,0.25], inf) * 0.9,
	\decay, Prand([1,2,3,4,5], inf),
	\out, b, \amp, 0.4,
),
	// shang
		~m5 = Pbind(

	\instrument, "plucking",
	\scale, Scale.shang.tuning_(\just),
	\octave, 4,
	\degree, Pseq([ 0, 2, 5, 7, 10,7,5,2 ], inf), // four main notes
	\mtranspose, Pseq([Pseq([0],3),Pseq([-5],3)],inf), // switched mode every 3 notes (*2)

	\gtranspose, Pseq([Pseq([0],36),Pseq([4],36),Pseq([[-3]],36),Pseq([2],36)],inf),
	\ctranspose, Pser([Pseries(-4,1,6) +.x Pseq([0], 144)],1),

	\coef, Pser([Prand([0.2,0.3,0.4,0.5],1), Prand([0.8,0.7,0.6,0.5],11)], inf),
	\dur, Prand([0.25,0.26,0.24,0.255,0.255,0.25], inf) * 0.9,
	\decay, Prand([1,2,3,4,5], inf),
	\out, b, \amp, 0.4,
),
	// Lü
		~m6 = Pbind(

	\instrument, "plucking",
	\scale, Scale.chromatic.tuning_(\just),
	\octave, 4,
	\degree, Pseq([ 0, 2, 3, 5, 6,8,9,11 ], inf), // four main notes
	\mtranspose, Pseq([Pseq([0],3),Pseq([-5],3)],inf), // switched mode every 3 notes (*2)

	\gtranspose, Pseq([Pseq([0],36),Pseq([4],36),Pseq([[-3]],36),Pseq([2],36)],inf),
	\ctranspose, Pser([Pseries(-4,1,6) +.x Pseq([0], 144)],1),

	\coef, Pser([Prand([0.2,0.3,0.4,0.5],1), Prand([0.8,0.7,0.6,0.5],11)], inf),
	\dur, Prand([0.25,0.26,0.24,0.255,0.255,0.25], inf) * 0.9,
	\decay, Prand([1,2,3,4,5], inf),
	\out, b, \amp, 0.4,
)];

~glitch = [
~g1 = Pbind(
	\instrument, \chaosGlitch2,
	\dur, 1,
	\len, Pseq([1, 1.5, 1.75, 2]+10,inf),
	\henA, Pseq([2, 1.3, 1.29, 1.25], inf),
	\henB, Pseq([0.2, 0.3], inf),
	\t, Pseq([2, 4, 2, 6], inf),
	\fundFreq, Pseq([40, 600, 8000, 200, 600, 6000], inf),
	\amp,0.1
),
		~g2 = Pbind(
\instrument, \hasherTest,
\dur, Pxrand([2,5,7,9],inf),
\rate, Pfuncn({100.rand}, inf),
\freq, Pfuncn({10000.rand}, inf),
\index, Pfuncn({20000.rand}, inf),
\tRate, Pfuncn({1000.rand}, inf),
\fRate, Pxrand([2,5,7,9],inf),
	\amp, 0.2
),
	~g3 = Pbind(
	\instrument, \bufsynth,
	\buf, Pxrand(d["glitch2"], inf),
	\dur, 1/2,
	\rate, Pwhite(0.5,1.5,inf),
	\amp, Pwhite(0.4,1.0,inf),
	\atk, 0.05,
	\sus, 0.04,
	\rel, 0.005
),
	~g4 = Pbind(
	\instrument, \pbufs,
	\buf, Pxrand(d["rim"], inf),
	\dur, 1/2,
	\rate, Pwhite(0.5,1.5,inf),
	\amp, Pwhite(0.4,1.0,inf),
	\atk, 0.5,
	\sus, 0.4,
	\rel, 0.05
),
	~g5 = Pbind(
	\instrument, \pbufs,
	\buf, Pxrand(d["pajaros"], inf),
	\dur, 1/2,
	\rate, Pwhite(0.5,1.5,inf),
	\amp, Pwhite(0.4,1.0,inf),
	\atk, 2,
	\sus, 2,
	\rel, 0.5
),
	~g6 = Pbind(
	\instrument, \pbufs,
	\buf, Pxrand(d["orquesta"], inf),
	\dur, 1/2,
	\rate, Pwhite(0.5,1.5,inf),
	\amp, Pwhite(0.1,4.0,inf),
	\atk, 2,
	\sus, 2,
	\rel, 0.5,

)];

~bass= [
	~b1 = Pbind(
	\instrument, \blip1,
	\scale,  Scale.yu,
	\degree, Pn(Pshuf([0,3,5,7,10],4),inf),
	\octave, [2],
	\dur, Pseq([0.25], inf),
	\amp, 0.2,
	\level, 1.5,
	\atk, 0,
	\sus, 0,
	\rel, 0.75,
	\curve,-6,
	\pan,0
),

	~b2=  Pbind(
	\instrument, \ksBass,
	\scale,  Scale.zhi,
	\degree, Pn(Pshuf([0,2,5,7,9,7,5,2],4),inf),
	\octave, [3],
	\dur, Pseq([1/2], inf),
	\amp, 0.2,
	\level, 1.5,
	\atk, 0,
	\sus, 0,
	\rel, 0.75,
	\curve,-6,
	\pan,0
),
	~b3= Pbind(
	\instrument, \rubberBand,
	\scale,  Scale.gong,
	\degree, Pn(Pshuf([0,2,4,7,9],4),inf),
	\octave, [2],
	\dur, Pseq([1], inf),
	\amp, 0.09,
	\level, 1.5,
	\atk, 0,
	\sus, 0,
	\rel, 0.75,
	\curve,-6,
	\pan,0
)
,
	~b4 =  Pbind(
	\instrument, \subBass2,
	\scale,  Scale.chinese,
	\degree, Pn(Pshuf([0,4,6,7,11],4),inf),
	\octave, [2],
	\dur, Pseq([1], inf),
	\amp, 0.09,
	\level, 1.5,
	\atk, 0,
	\sus, 0,
	\rel, 0.75,
	\curve,-6,
	\pan,0
),
	 ~b5 = Pbind(
	\instrument, \subBass2,
	\scale,  Scale.shang,
	\degree, Pn(Pshuf([[0,2],[5,7],[10,2],[5,7]],4),inf),
	\octave, [2,3,4],
	\dur, Pseq([1], inf),
	\amp, 0.09,
	\level, 1.5,
	\atk, 0,
	\sus, 0,
	\rel, 0.75,
	\curve,-6,
	\pan,0
	),
	~b6 =Pbind(
	\instrument, \subBass2,
	\scale, Scale.minorPentatonic,
	\degree, Prand([0, [3,11], 7, [5,13],  10 ],inf),
	\octave, [2,3,4],
	\dur, Pseq([1], inf),
	\amp, 0.09,
	\level, 1.5,
	\atk, 0,
	\sus, 0,
	\rel, 0.75,
	\curve,-6,
	\pan,0
	)
];

// drones


//evaluate this twice with a couple of seconds of gap in between
//the argument 'mult' is used for speed - to copy and paste the entire NodeProxy and set multiplications quickly during performance
(
~r = {54};
~dfm1 = {arg mult = 1; DFM1.ar(SinOsc.ar([~r,~r*1.01]*mult,0,0.1),(~r*2)*mult,SinOsc.kr(0.05).range(0.9,1.1),1,0,0.0003,0.5)};
~dfm2 = {arg mult = 2; DFM1.ar(SinOsc.ar([~r,~r*1.01]*mult,0,0.1),(~r*2)*mult,SinOsc.kr(0.06).range(0.9,1.1),1,0,0.0003,0.5)};
~dfm3 = {arg mult = 3; DFM1.ar(SinOsc.ar([~r,~r*1.01]*mult,0,0.1),(~r*2)*mult,SinOsc.kr(0.056).range(0.9,1.1),1,0,0.0003,0.5)};
~dfm4 = {arg mult = 4; DFM1.ar(SinOsc.ar([~r,~r*1.01]*mult,0,0.1),(~r*2)*mult,SinOsc.kr(0.07).range(0.9,1.1),1,0,0.0003,0.5)};
~dfm5 = {arg mult = 4;DFM1.ar(SinOsc.ar([~r, ~r*1.02] * mult, 0, 0.1),(~r * 1.5) * mult,SinOsc.kr(0.1).range(0.8, 1.2),1,0,0.0004, 0.6)};
~dfm6 = {arg mult = 4;DFM1.ar(Pulse.ar([~r, ~r*1.03] * mult, 0.5, 0.1),(~r * 2.5) * mult,LFTri.kr(0.05).range(0.7, 1.3),1,0,0.0002,0.4)};
	)

	~dfm1.play;~dfm2.play;~dfm3.play;~dfm4.play;~dfm5.play;~dfm6.play

~drones = [~dfm1.play, ~dfm2.play, ~dfm3.play, ~dfm4.play, ~dfm5.play, ~dfm6.play]


