("Setup/Setup.scd").loadRelative;



Routine{
	var frequencies;
	frequencies = 40 * (1..8).nthPrime;
	loop{
		Routine{
			var synth;
			synth = Synth(padHO, [freq:frequencies.choose]);
			rrand(8.0,16.0).wait;
			synth.set(gate, 0);
		}.play;
		rrand(0.3,0.1).wait;
	};
}.play




 (

	b = Buffer.read(s,"/Users/sdcarr/Desktop/samples /set1/etnico/melodia2.wav" );
	~p = Pbind(
		\instrument,\tgrains,
		\dur, 0.256,
		\buf, b
	)
)

Synth(\tgrains,[\buf,b])
b.play;


d["piano"][1].play

(
~piano1 = Pbind(\instrument,\sinte,\buf,d["piano"][1],\dur,16,\amp,1);
~piano2 = Pbind(\instrument,\sinte,\buf,d["piano"][1],\dur,32,\amp,1,\rate,0.5);
)

d.keys
d["k"][0].play

Synth(\setPerc2,[\buf,d["orquesta"][0]])
(

~z = Pbind(
	\instrument,\setPerc2,
	\dur, 10,
	\buf,d["orquesta"][0..9].choose,
	\amp,10000,
	\rate, Pwhite(0.4,0.8,inf)
)
)



~z.play

~z.stop



