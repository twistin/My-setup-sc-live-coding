"/Users/sdcarr/Desktop/My-setup-sc-live-coding/samples/set1/china/"

// tempo
t = p.clock.tempo_(90/60);
////////
("../Setup/Setup.scd").loadRelative;
// 艮 艮 艮 艮 艮 艮 艮 艮 QUINTA PIEZA:  gèn 艮 艮 艮 艮 艮 艮 艮 艮//

b = (); b.china = PathName("/Users/sdcarr/Desktop/My-setup-sc-live-coding/samples/set1/china/").entries.collect({ |n| Buffer.readChannel(s,n.fullPath,channels:[0]);})


////////////////  1 //////////////////
(
~a = Pbind(
	\instrument, \bufseg1,
	\bufnum, b.china[6],
	\startSec, Pwhite(0, b.china[6].duration * 0.6, inf),
	\rate, 1,
	\dur, 20, //Pexprand(0.2, 0.9, inf),
	\legato, 1,
	\amp,5
);
)
b.china[6].play
~a.play;
~a.resume;
~a.release(2);

////////////////  2  //////////////////


(
~b = Pbind(
	\instrument, \bufseg1,
	\bufnum, b.china[14],
	\startSec, Pwhite(0, b.china[14].duration * 0.6, inf),
	\rate, 1,
	\dur, 20, //Pexprand(0.2, 0.9, inf),
	\legato, 1,
	\amp,1
);
)
~b.play;
~b.resume;
~b.release(2);

////////////////  3 //////////////////

~nz = {Hasher.ar(LFClipNoise.ar(\nFr.kr(2500),1,\add.kr(3)))!2};
~a.play; ~a.awake_(false);
~a =  {MoogFF.ar(Saw.ar(\freq.kr(5000)*[1,1.008], Decay.kr(Impulse.kr(\trig.kr(10)), ~nz *0.001)),18000,0).tanh * Env([0,1,1,0],[\atk.kr(0.002), \sus.kr(0.1),\rel.kr(0.05)]).ar(2)*\amp.kr(0.1)};

////////////////  4 //////////////////
~c.play; ~c.awake;
~c = {\k.kr(0) + SinOscFB.ar(XLine.kr(\freq.kr(500)*[1, \mod.kr(0.98499)],\freq.kr * [1, \mod.kr], \d.kr(0.0005)),\fb.kr(0)).mean.tanh !2 * Env([0,1,1,0], [\atk.kr(0.005), \sus.kr(0),\rel.kr(0.3) + \d.kr]).kr(2) * \amp.kr(0.2) +(\k.kr * LPF.ar(BrownNoise.ar([0.3,0.31]),[5000,6500]) * Env.perc(0.02,\rel.kr * 0.9, \cur.kr(-5)).ar(0))}

////////////////  5 //////////////////
~d.play;~d.awake_(false);
~d = {LFPulse.ar(\freq.kr(80)*[1,\mod.kr(0.5)],SinOsc.kr(0.5).range(0, 2pi), 1,\amp.kr(0.7),\add.kr(100)) * Env([0,1,1,0], [\atk.kr(0.005), \sus.kr(0),\rel.kr(0.3) + \d.kr]).kr(2)}



//////////////////////// controles /////////////////////

            ///////////  reverb ///////////

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
);


///////////////////////////////////////////////////////////
+ ~b+ ~c +~p
~mix = {~a }

/////////////////////////////////////////////////////////

~seq = Tdef(\seq, {
	loop{
	~c.spawn([\freq,10000]);
	1.wait;
	~c.spawn([\freq,5000, \atk,0.4]);
	0.5.wait;
    ~c.spawn([\freq,400]);
	1.wait;
	 ~c.spawn([\freq,1000]);
	0.25.wait;

	};
})


~seq1 = Tdef(\seq1, {
	loop{
	~d.spawn([\freq,10000]);
	1.wait;
	~d.spawn([\freq,5000, \atk,0.4]);
	0.5.wait;
    ~d.spawn([\freq,400]);
	1.wait;
	 ~d.spawn([\freq,1000]);
	0.25.wait;

	};
})
~seq.stop
~seq1.stop