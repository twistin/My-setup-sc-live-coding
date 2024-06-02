

                  ////////  SynthDef //////////////
L-system
(
Buffer.freeAll;
~path = PathName(thisProcess.nowExecutingPath).parentPath;
b =(
	coro1:Buffer.read(s,~path ++ "coro1.wav"),
	coro2:Buffer.read(s,~path ++"coro2.wav"),
	melodia1:Buffer.read(s,~path ++ "melodia1.wav"),
	melodia2:Buffer.read(s,~path ++"melodia2.wav"),
	melodia3:Buffer.read(s,~path ++"melodia3.wav"),
	perc1:Buffer.read(s,~path ++"perc1.wav"),
	perc2: Buffer.read(s,~path ++"perc2.wav"),
	perc3:Buffer.read(s,~path ++"perc3.wav")
		);


)
b[\coro1].numChannels
b.keys
b.class

b.perc1.play
ProxySpace.clearAll

b.play
b.set(\rate,0.3)

(
SynthDef(\setPerc,{

	var sig, env;
	env = Env(
		[0,1,0],
		[\atk.ir(0.001),\rel.ir(0.5)],
		[0,-4]
	).ar(2);
	sig = PlayBuf.ar(2,\buf.kr(0),BufRateScale.ir(\rate.ir(b)),\trihz.kr(6), \spos.kr(0),\loop.kr(1));
	sig = sig * env;
    sig = sig *\amp.kr(0.5);
	Out.ar(\out.kr(0), sig);
} ).add;
)

Synth(\setPerc, [\buf, 6])
(
4.do({
	x = Synth(
		\setPerc, [
			\buf, 6,
			\amp, 0.dbamp,
			\loop, 1,
			\rel,3,
			\spod, rrand(0,b.perc1.numFrames -1),
			\trighz:exprand(2,40)
		]
	);
});
)


(

z =Pbind(
	\instrument,\setPerc,
	\buf, 0,
	\dur, 0.50,
	\rate, 0.6,
	\amp, Pwhite(0.3,0.8,inf),

)
)
z.play