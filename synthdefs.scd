    /////// ////// SynthDefs ////// ///////

// Sintesis Granular


// Audio estereo convertido en mono para la sintesis granular, es mejor leer un sólo canal

b = Buffer.readChannel(s,"/Users/sdcarr/Desktop/samples /set1/etnico/perc1.wav", channels:[0]);
c = Buffer.readChannel(s,"/Users/sdcarr/Desktop/samples /set1/etnico/melodia1.wav",channels:[0]);

(
SynthDef(\grainbuf, {
	var sig, env;

	env = Env([0,1,1,0], [\atk.ir(1),\sus.ir(4),\rel.ir(1)], [1,0,-1]).kr(2);

	sig = GrainBuf.ar(
		numChannels:2,
		trigger:Dust.kr(40), // 40 granos por segundo
		dur:0.1,
		sndbuf:\buf.kr(0),
		rate:BufRateScale.kr(\buf.kr(0)) * \rate.kr(1),
		pos: Line.kr(0,1,BufDur.kr(\buf.kr(0))* \timescale.kr(5)),
		interp:2,
		pan:0,
		envbufnum:-1
	);
	sig = sig * env * \amp.kr(0.5);

	Out.ar(\out.kr(0), sig);

}).add;
)

// calcular duracion de  "~buffers"
d = c.numFrames / c.sampleRate;




(
SynthDef(\tgrains, {
	var sig, env;

	env = Env([0,1,1,0], [\atk.ir(1),\sus.ir(4),\rel.ir(1)], [1,0,-1]).kr(2);

	sig = TGrains.ar(
		numChannels:2,
		trigger:Dust.kr(40), // 40 granos por segundo
		bufnum:\buf.kr(0),
		dur:0.05,
		rate: \rate.kr(1),
		centerPos:\pos.kr(0.5),
		pan:0,
		amp:0.5,
		interp:2
	);
	sig = sig * env * \amp.kr(0.9);

	Out.ar(\out.kr(0), sig);

}).add;
)







///////////////////////////////////

d = Buffer.alloc(s, s.sampleRate * 3);// Crea un buffer vacio

(
SynthDef(\tgrains_live, {
	var sig, env;

	env = Env.asr(\atk.ir(0.1), \sus.ir(1), \rel.ir(1)).kr(2, \gate.kr(1));

	sig = TGrains.ar(
		numChannels:2,
		trigger:Dust.kr(40), // 40 granos por segundo
		bufnum:\buf.kr(0),
		dur:0.05,
		rate: \rate.kr(1),
		centerPos:\pos.kr(0.5),
		pan:0,
		amp:0.5,
		interp:2
	);
	sig = sig * env * \amp.kr(0.9);

	Out.ar(\out.kr(0), sig);

}).add;
)



///////////////////////


(
SynthDef(\tgrains_live, {
	var sig, ptr, env,pos, mic, buf = \buf.kr(0);

	env = Env.asr(\atk.ir(0.1), \sus.ir(1), \rel.ir(1)).kr(2,\gate.kr(1));
	mic = SoundIn.ar(0);
	ptr = Phasor.ar(0,1,0,BufFrames.kr(\buf.kr(0)));
    BufWr.ar(mic, \buf.kr(0), ptr);

	pos = (ptr/SampleRate.ir) - 0.25;
	pos = pos + LFNoise1.kr(100).bipolar(0.2);
	sig = TGrains.ar(
		numChannels:2,
		trigger:Dust.kr(40), // 40 granos por segundo
		bufnum:buf,
		dur:0.05,
		rate: \rate.kr(1),
		centerPos:(ptr/SampleRate.ir)-1,
		pan:0,
		amp:1,
		interp:2
	);
	sig = sig * env * \amp.kr(0.9);

	Out.ar(\out.kr(0), sig);

}).add;
)











