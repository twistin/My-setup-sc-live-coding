("../Setup/Setup.scd").loadRelative;


b = (); b.china = PathName("/Users/sdcarr/Documents/GitHub/My-setup-sc-live-coding/samples/set1/china/").entries.collect({ |n| Buffer.readChannel(s,n.fullPath,channels:[0]);})




s.boot;

(
SynthDef(\bufseg1, { |out, gate = 1, bufnum, startSec, rate = 1, amp = 0.1, pan = 0|
	var sig = PlayBuf.ar(
		1, bufnum,
		rate * BufRateScale.kr(bufnum),
		startPos: startSec * BufSampleRate.kr(bufnum)
	);
	var eg = EnvGen.ar(Env.asr(0.005, 1, 0.005, \lin), gate, doneAction: 2);
	Out.ar(out, Pan2.ar(sig * (eg * amp), pan))
}).add;
)



~r1[0] = Pbind(
		\instrument, \bufsynth,

\buf, Pxrand(d["glitch2"],inf),
		\dur, 1/2,
		\rate, Pwhite(1.0,5.0,inf),
		\spos,0,
		\amp, 0.2,
		\atk, 0,
		\sus, Pwhite(0.0,0.15),
		\rel, 0.01,
		\cur,1,
		\pan, Prand([-1,0, 1],inf)

)

~r1.play
b = (); b.china = PathName("/Users/sdcarr/Documents/GitHub/My-setup-sc-live-coding/samples/set1/china/").entries.collect({ |n| Buffer.readChannel(s,n.fullPath,channels:[0]);})

s.boot;

(
SynthDef(\bufseg1, { |out, gate = 1, bufnum, startSec, rate = 1, amp = 0.1, pan = 0|
	var sig = PlayBuf.ar(
		1, bufnum,
		rate * BufRateScale.kr(bufnum),
		startPos: startSec * BufSampleRate.kr(bufnum)
	);
	var eg = EnvGen.ar(Env.asr(0.005, 1, 0.005, \lin), gate, doneAction: 2);
	Out.ar(out, Pan2.ar(sig * (eg * amp), pan))
}).add;
)

Synth(\bufseg1)

(
p = Pbind(
	\instrument, \bufseg1,
	\bufnum, Pxrand([b.china,inf]),
	\startSec, Pwhite(0,  b.china[0].duration * 0.6, inf),
	\rate, Pxrand([0.2,0.4,0.8,1],inf),
	\dur, 4, //Pexprand(0.2, 0.9, inf),
	\legato, 1
).play;
)

p.stop;



b.china[0].play



~b1[1] = \filter -> {|in|  in.clip};
~b1[2] = \filter -> {|in|  in *SinOsc.ar(150*[1,0.995])};
~b1[3] = \filter -> {|in|  LPF.ar(in,freq:600, mul:1, add:0)};
~b1[4] = \filter -> {|in|  CombL.ar(in,maxdelaytime:0.2,delaytime:0.07,decaytime:1)};
~b1[5] = \filter -> {|in|  RLPF.ar(in,freq:500,rq:0.07,mul:0.8)};
~b1[6] = \filter -> {|in|  MoogFF.ar(in,freq:500,gain:0.07,reset:0,mul:1,add:0)};
~r1[7] = \filter -> {|in|  GVerb.ar(in,roomsize:10,revtime:3,damping:0.5,inputbw:0.5,spread:15,drylevel:1,earlyreflevel:0.7, taillevel:0.5,maxroomsize:300,mul:1,add:0)};


~b.set(\wet1,0);
~b.set(\wet2, 0);
~b.set(\wet3, 0);
~b.set(\wet4, 0);
~b.set(\wet5,0);
~b.set(\wet6, 0);
~b.set(\wet7, 0.1);



~t1.play
~t1[0] = Pbind(
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
)

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
~mix = ~r1
~k.play
~k = Pbind(\instrument,\bufsynth,\buf,d["k"][2],\dur,[1,1,1/2].choose,\amp,1);
Synth(\abstractDrum)
