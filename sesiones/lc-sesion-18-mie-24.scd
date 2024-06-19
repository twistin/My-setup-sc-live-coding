("../Setup/Setup.scd").loadRelative;


{SinOsc.ar(220)}.play
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

b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");
b.play
(
p = Pbind(
	\instrument, \bufseg1,
	\bufnum, b,
	\startSec, Pwhite(0,b.duration * 0.6, inf),
	\rate, 1,
	\dur, Pexprand(0.2, 0.9, inf),
	\legato, 1
).play;
)

p.stop;

Synth(\bufseg1)