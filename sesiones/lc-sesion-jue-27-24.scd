

"/Volumes/H6_SD/FOLDER01/"


"/Users/sdcarr/Documents/Grabaciones-de-Campo"

("../Setup/Setup.scd").loadRelative;

(
~pat = Pseries(start: 50, step: 7, length: 6);
~seq = ~pat.asStream;
)
~seq.next; // evaluate repeatedly

~pat = Pseries(2,3,6);
~pat.next

(
~pat = Pwhite(lo: 48, hi: 72, length: 10);
~seq = ~pat.asStream;
)
~seq.nextN(4); // evaluate repeatedly
~seq.reset;
~seq.all;

(
~pat  = Pbind(
	\instrument,\blip1,
	\freq, Pwhite(200,440,inf),
	\numharm, Pseries(10,10,inf),
	\dur, 1/3,
	\amp,1,
	\rel, Pxrand([0.1,0.01,0.008,1],inf),
	\att, Pgeom(0.06,1,inf),
	\pan, Pwrand([-0.2,-0.8,0,0.2,0.8],[1, 3, 5].normalizeSum,inf)
)
)

~pat.play;
~pat.stop;
~pat.release(5);




(
~pat = Pwhite(0.0, 1.0, inf) * Pseq([-1, 1], inf);
~seq = ~pat.asStream.nextN(8);
)


(0..999).postln;
(0..999).postln;\
(0..999).postcs;

(0..999).postcs;\


(
~func = { |input|
input = input + 2;
};
)

~func.postcs;\
~func.postln;\
().play.postln




(
SynthDef(\bpf_brown, {
arg atk = 0.02, rel = 2, freq = 800,
rq = 0.005, pan = 0, amp = 1, out = 0;
var sig, env;
env = Env([0, 1, 0], [atk, rel], [1, -2]).kr(2);
sig = BrownNoise.ar(0.8);
sig = BPF.ar(sig, freq, rq, 1 / rq.sqrt);
sig = Pan2.ar(sig, pan, amp) * env;
Out.ar(out, sig);
}).add;
)
(instrument: \bpf_brown, freq: 500, atk: 2, rel: 4, amp: 0.6).play






(
p = Pbind(
\midinote, Pseq([55, 57, 60], 2),
\db, Pwhite(-20.0, -10.0, 6),
\pan, Prand([-0.5, 0, 0.5], 6)
).trace;// postln no funcionará en este contexto
~seq = p.play;
)




~a.play; ~a.awake_(false);
~a = {Pan2.ar(MoogFF.ar(SinOscFB.ar(\freq.ir(220),\fb.ir(0), \amp.ir(1),0),\mfreq.ir(200),\gan.ir(2),\res.ir(0),\amp.ir,0) * Env.perc(\atk.ir(0.2),\rel.ir(0.1),\lev.ir(1),\cur.ir(-5)).ar(2), \pos.ir(0))};


(
~r[0] = Tdef(\r, {
	loop{
		~a.spawn([\freq,85, \mfreq,100, \rel,0.05]);
		0.5.wait;
		~a.spawn([\freq, 300, \lev, 10, \atk, 0.05, \fb,0.5]);
		0.75.wait;
		~a.spawn([\freq,1000, \mfreq, 600, \atk,0.8,\rel, 0.4, \fb,[0,0.4,0.9,1].choose]);
		0.25.wait;
		~a.spawn([\freq,10000, \mfreq, 600, \atk,0.08,\rel, 0.04, \fb,[0,0.4,0.9,1].choose]);
		1.wait;
		~b.spawn(\rate, 1,\amp,1, \atk,3,\rel, 1, \bufnum,d["glitch"][3] );
			1.wait;
	};
})

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



~b.play; ~b.awake_(false);
~b = {Pan2.ar(PlayBuf.ar(1, d["glitch"][1],\rate.ir(1),\trig.ir(1),\spos.ir(0))*Env.linen(\att.ir(1),\sus.ir(2), \rel.ir(0.6),1,\cur.ir(-5)).ar(2),\pos.ir(0) )* \amp.ir(0.5)}
d["glitch"][].play



~mix = { ~a + ~b }

~r.resume(4)
~r[1] = \filter -> { |in| in.clip};
~r[2] = \filter -> { |in| SinOsc.ar(100*[1,5.345])};
~r.set(\wet2,0)

