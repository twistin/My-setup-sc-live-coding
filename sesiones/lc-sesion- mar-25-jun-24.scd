

("../Setup/Setup.scd").loadRelative;
{SinOsc.ar(420)!2}.play;
p.activeProxies
t = p.clock.tempo_(60/60);
m.noteOn(0,60,64);
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

(
~a.play; ~a.awake_(false);
~a= {SinOsc.ar(\freq.ir(100)*[4,0.854], \phase.ir(0), \amp.ir(1),0).mean.tanh!2* Env([0,1,1,0],[\atk.ir(0.005),\sus.ir(0.1), \rel.ir(0.02)], -5).ar(2)};

~b.play; ~b.awake_(false);
~b = {SinOsc.ar(\freq.ir(100)*[4,0.854]).mean.tanh !2 *Env([0,1,1,0],[\atk.ir(0.005),\sus.ir(0.1), \rel.ir(0.02)], -5).ar(2)*\amp.ir(0.1) };

~c.play; ~c.awake_(false);
~c = {HPF.ar(WhiteNoise.ar([1,1]), 8000)* Env([0,1,1,0],[\atk.ir(0.05),\sus.ir(0.1), \rel.ir(0.02)], -5).ar(2)* \amp.kr(0.1)};
~d.play; ~d.awake_(false);
~d= {RHPF.ar(Gendy5.ar(minfreq:\freq.ir(50), maxfreq:\freq.ir(50)),[500,650],0.2)*Env.perc(\atk.ir(0.1),\rel.ir(1) ).kr(2)*\amp.ir(0.05)};
~e.play; ~e.awake_(false);
~e = {SinOsc.ar(\freq.ir(100)*[4,0.854]).mean.tanh !2 *Env([0,1,1,0],[\atk.ir(0.005),\sus.ir(0.1), \rel.ir(0.02)], -5).ar(2)*\amp.ir(0.1) };
~f.play; ~f.awake_(false);
~f = {HPF.ar(WhiteNoise.ar([1,1]), 8000)* Env([0,1,1,0],[\atk.ir(0.05),\sus.ir(0.1), \rel.ir(0.02)], -5).ar(2)* \amp.kr(0.1)};
)


~mix = {~a }
~mix.pause
~mix.resume

(
~a1[0] =
Tdef(\pulse, {
loop{
~a.spawn([\amp, 0.3]);
4.wait;
};
});
)

~a1.play;
~a1.resume;
~a1.pause;


(
~b1[0] =
Tdef(\seq,{
loop{
~b.spawn([\sus, 0.5,\freq,160, \amp, 0.07]);1.75.wait;
2.do{~b.spawn([\freq, 6500,\amp,0.05, \sus,0.02])};0.125.wait;
~b.spawn([\sus,0.5,\freq, 1000, \amp, 0.01]); 1.25.wait;
   ~c.spawn;[2.5,3.5].choose.wait;
   ~b.spawn([\freq, 4500, \amp, 0.05,\sus,0.02]); 0.25.wait;
   ~e.spawn([\freq, 6500, \amp, 0.1,\sus,0.02]); 0.75.wait;
   ~b.spawn([\freq, 6500, \amp, 0.02,\sus,2]); 0.25.wait;
~f.spawn([\freq, 500]);[2.5,3.5].choose.wait;
}
})
)
~b1.play




(
~b2[0] =
Tdef(\seq2,{
4.do{
~d.spawn([\freq, 36,\atk, 0.15,\rel,2.5 ]);
4.wait;
};
});
)

(
~p[0] = Pbind(
\instrument, \FMRhodes1,
\scale,Scale.chromatic,
\degree, Pseq([[1,4,7,11],[1,4,7,11]+7],inf),
\octave, 3,
\dur, 2,//Pseq([1/3,1/3,1],inf),
\amp,0.2

)
)
~p.play

~mix = {~b1+~b2+ ~c1}




d["china"].stop


(
~c1[0] = Pbind(
	\instrument, \bufseg1,
	\bufnum,d["set-sounds"][1], //Prand(d["set-sounds"],inf),
	\rate, Pxrand([0.5,0.8,1,1.4,2.0],inf),
	\dur, 1/2,
	\amp, 1
)
)

~c1.play
~a1.pause;
~c1.pause;
~c1.resume;
(
~off = Tdef(\off, {
	~b1.pause;
	4.wait;
	~b2.pause;
	4.wait;
	~p.pause;
	4.wait;
	~c1.pause


});
)

(
~on = Tdef(\n, {
	~b1.resume;
	4.wait;
	~b2.resume;
	4.wait;
	~p.resume;
	4.wait;

});
)
