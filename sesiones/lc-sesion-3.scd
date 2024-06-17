


("../Setup/Setup.scd").loadRelative;
t = p.clock.tempo_(60/60);


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

~mix = {~stress + ~a }

(
// ritmo

~k = Pbind(
	\instrument,\pbufm,
	\buf,d["k"][0],
	\dur,1,
	\atk, 0.005,
	\sus, 0.03,
	\amp, 0.6,
	\rate, Pwhite(0.5, 1.5, inf)

);


~sn = Pbind(\instrument,\pbufm,
	\buf,d["s"][5],
	\dur,2,
	\amp,1,
	\rate,Pbjorklund2(5, 8, inf)/4,
	);

~c[0] = Pbind(
	\instrument,\pbufm,
	\buf,d["c"][5],
	\dur,Pbjorklund2(3, 8, inf)/2,
	\amp,0.4

);


~c[10] = \filter -> {|in| in* SinOsc.ar(150* [1,0.995])};
~c[11] = \filter -> {|in| in.clip};
~c[11] = \filter -> {|in| CombL.ar(in, 0.08, 0.07,0.5)};

~c.set(\wet, 0.5);
~c.set(\wet, 0.7);
~c.set(\wet, 0.5)





Scale.directory


(
~a = Pbindef(\p0,
	\type, \midi,

	\octave, [7],
	\midinote, Pxrand(Scale.chinese.degrees+50,inf),
	\dur, 1,
	\midicmd, \noteOn,
	\midiout,m,
	\amp,0.2,
	\sustain, 0.02

)
)

)
~a.release(2)
~k.play;
~k.release(2)
~sn.play
~sn.release(2)
~c.play;
~c.pause
~c.resume
~e.play



~dfm1Send = {Mix.ar([~one])};
~dfm1Filt = {arg freq = 1000, res = 0.7, noise = 0.0003, type = 0; DFM1.ar(NumChannels.ar([~dfm1Send]),freq,res,1,type,noise,1)};
~dfm1Filt.play;



~stress.release(2)
~stress ={ Streson.ar(LFSaw.ar([220, 180], Impulse.kr(1000), mul:EnvGen.kr(Env.asr(0.5, 1, 0.02), 1.0) * 0.2), LinExp.kr(LFCub.kr(0.1, 0.5*pi), -1, 1, 280, 377).reciprocal, 0.9, 0.3) }

∫
(
Tdef(\task,{
	loop{
		stuff.do
		1.wait;
}});
)




~drone = {DFM1.ar(SinOsc.ar([100,101],0,1),200,SinOsc.kr(0.05).range(0.9,1.1),1,0,0.0003,0.5)};

~drone.release()

~pianoChop.play
~pianoChop = Pbind(\instrument,\pbufm,\buf,d["piano"][1],\dur,Pbjorklund2(5, 8, inf)/4,\atk,0.6,\sus,0.04,\rel,0.5,\pos,Pexprand(0.2,0.5),\amp,1,\rate,2)