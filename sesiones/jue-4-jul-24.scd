("../Setup/Setup.scd").loadRelative;
Server.default.options.outDevice = "BlackHole 2ch";
Server.default.reboot; //
Server.default.options;

 p.clock.tempo_(40/60);
{SinOsc.ar(220)!2}.play

(
~m[0] = Pbind(
	\type, \midi,
	\midiout,m,
	\midicmd, \noteOn,
	\midinote, Pwhite(40,90,inf),
	\amp, Pexprand(0.1,0.5,inf),
	\dur, Prand([0.1,0.2,0.4], inf),
);
)
~m.play.quant_(1);
~m.pause
~m.resume
~m.stop
~m.clear;

~m[1] = \filter -> {|in| in.clip};
~m[2]= \filter -> {|in| GVerb.ar(in, roomsize:200,maxroomsize:1000)};
~m[3] = \filter -> {|in| CombL.ar(in, 0.0,0.07,2.5)};

~m.set(\wet1,0)
~m.set(\wet2,1)
~m.set(\wet3,1)


(
~b[0] = Pbind(
	\instrument,\waveguideFlute,
	\scale, Scale.major,

	\midinote, Pseq([69,67,65, 64],inf),
	\legato,0.9,
	\amp,0.3,
	\dur,1
)
)
~b.clear
~b.fadeTime(2);
~b.play(fadeTime:2).quant_(1);
~b.stop
~b.pause
~b[1] = \filter -> {|in| in.clip};
~b[2]= \filter -> {|in| GVerb.ar(in, roomsize:200,maxroomsize:500)};
~b[3] = \filter -> {|in| CombL.ar(in, 0.0,0.07,2.5)};

/////

~a.clear;
~a.fadeTime(2);
~a.play(fadeTime:2).quant_(1);
~a.pause;
~a.stop

~a[1] = \filter -> {|in| in.clip};
~a[2]= \filter -> {|in| GVerb.ar(in, roomsize:200,maxroomsize:500)};
~a[3] = \filter -> {|in| CombL.ar(in, 0.0,0.07,2.5)};
~a[4] = \filter -> {|in| RLPF.ar(in, 1500,4,2.5)};

~a.set(\wet1,0)
~a.set(\wet2,0.8)
~a.set(\wet3,0)
~a.set(\wet4,0)




(
~a = Pbind(
	\instrument,\strings,
	\scale, Scale.major,
	\root,Prand([-10,-5,0,2],inf),
	\degree, Pseq([0,3,5,7,9,11],inf),
	\legato,0.3,
	\amp,0.8,
	\dur,0.25
)
)


