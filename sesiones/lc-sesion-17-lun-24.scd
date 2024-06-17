(
SynthDef(\tone, {
	var sig, env;
	env = Env.adsr(
		\atk.ir(0.001), \dec.ir(0.2), \slev.ir(0.4), \rel.ir(0.3)
	).ar(Done.freeSelf, \gate.kr(1));
	sig = LFTri.ar(\freq.kr(880));
	sig = Pan2.ar(sig, \pan.kr(0), \amp.kr(0.3));
	sig = sig * env;
	Out.ar(\out.kr(0), sig);
}).add;
)