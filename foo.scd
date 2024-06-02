("Setup/Setup.scd").loadRelative;

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

