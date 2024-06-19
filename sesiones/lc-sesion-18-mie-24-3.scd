("../Setup/Setup.scd").loadRelative;
t = p.clock.tempo_(60/60);

(
SynthDef(\bufseg1, { |out, gate = 1, bufnum, startSec, rate = 1, amp = 1, pan = 0|
	var sig = PlayBuf.ar(
		1, bufnum,
		rate * BufRateScale.kr(bufnum),
		startPos: startSec * BufSampleRate.kr(bufnum)
	);
	var eg = EnvGen.ar(Env.asr(0.005, 1, 0.005, \lin), gate, doneAction: 2);
	Out.ar(out, Pan2.ar(sig * (eg * amp), pan))
}).add;
)

b = Buffer.readChannel(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav",0);
b.play.numChannel
(
~p[0] = Pbind(
	\instrument, \bufseg1,
	\bufnum, d["china"][2],
	\startSec, Pwhite(0, b.duration * 0.6, inf),
	\rate, 1,//Pxrand([0.3,0.8,1,2],inf),
	\dur, Pexprand(2, 2.9, inf),
	\legato, 1,
	\amp, 1,
	// 70% chance of being a rest
    \dummy, Pwrand([Rest(), 1], [0.4, 0.3].normalizeSum, inf),
);
)
~p.clear
~p.play
~p.stop


d["china"][0].stop
p.stop
d["orquesta"][2].play


~b1[1] = \filter -> {|in|  in.clip};
~p1[2] = \filter -> {|in|  in *SinOsc.ar(150*[1,0.995])};
~b1[3] = \filter -> {|in|  LPF.ar(in,freq:600, mul:1, add:0)};
~b1[4] = \filter -> {|in|  CombL.ar(in,maxdelaytime:0.2,delaytime:0.07,decaytime:1)};
~b1[5] = \filter -> {|in|  RLPF.ar(in,freq:500,rq:0.07,mul:0.8)};
~p[6] = \filter -> {|in|  MoogFF.ar(in,freq:100,gain:0.07,reset:0,mul:1,add:0)};
~p[7] = \filter -> {|in|  GVerb.ar(in,roomsize:10,revtime:3,damping:0.5,inputbw:0.5,spread:15,drylevel:1,earlyreflevel:0.7, taillevel:0.5,maxroomsize:300,mul:1,add:0)};


~b.set(\wet1,0);
~b.set(\wet2, 0);
~b.set(\wet3, 0);
~b.set(\wet4, 0);
~b.set(\wet5,0);
~b.set(\wet6, 0);
~p.set(\wet7, 0);
~g3=clear
~mix = {~g3 + ~r6 + ~b6}

~g3.play;
~g3[0] = Pbind(
	\instrument, \bufsynth,
\buf, Pxrand(d["glitch2"], inf),
	\dur, 1/2,
	\rate, Pwhite(0.5,1.5,inf),
	\amp, Pwhite(0.4,1.0,inf),
	\atk, 0.05,
	\sus, 0.04,
	\rel, 0.005
)

~r6.play
~r6[0] = Pbind(
	\instrument, \pulse,
	\dur, 1,
	\sustain, 0.2,
	\degree, Pseq([0, 1, 2, 3,5], inf),
	\db, -10,
	\atk, 0.01,
	\dec, 0.08,
	\slev, 0,
	\rel, 0,

)


~off.play


~off = Tdef(\off,{
	~g3.stop;
	4.wait;
	~r6.stop;
	4.stop;
	~p.stop;
	6.wait;
	~mix ={};
	3.wait;
	~b6.stop;


})
d["k"][2].play

~b6.play
~k = Pbind(\instrument,\bufsynth,\buf,d["k"][6],\dur,1,\amp,1);
~sn = Pbind(\instrument,\bufsynth,\buf,d["s"][1],\dur,2,\amp,1, \rate, Pxrand([0.2,0.4,0.9],inf));
~k.play;
~sn.play
~b6[0] =Pbind(
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

Synth(\buf)
