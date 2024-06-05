
("Setup/Setup.scd").loadRelative;

//Cargar los Buffers

(
b = ();
b.etnico = PathName("/Users/sdcarr/Desktop/My-setup-sc-live-coding/samples/set1/etnico/").entries.collect({|n|
	Buffer.readChannel(s,n.fullPath, channels:[0]);
});
)

(
c = ();
c.k = PathName("/Users/sdcarr/Desktop/My-setup-sc-live-coding/samples/set1/k/").entries.collect({|n|
	Buffer.readChannel(s,n.fullPath, channels:[0]);
});
)

c.k[6].play




(
l = Prewrite(1, // start with 1
        (    1: [0.25,2],
            0.25: [3,3,2]/4,
        3/4: [0.25,1,0.125,0.125],
        ), 4);

~a = Pbind(
	\instrument, \BUFSynth,
	\buf, c.k[6],
	\dur,l,
	\amp, 1,
	\rate, 0.4

)
)
~a.stop

~a.play


Synth(\BUFSynth, [\buf, ])

SynthDef(\BUFSynth, {
	var sig, env;
	env = Env.perc(\atk.ir(0.001),\rel.ir(0.1)).ar(2);
	sig = PlayBuf.ar(1, \buf.ir(0), \rate.ir(1));
	sig = Pan2.ar(sig, \pos.ir(0),\amp.ir(0.5));
	sig = sig * env;

	Out.ar(\out.ir(0), sig);
};
)





(
	~p = Pbind(
		\instrument,\tgrains,
		\dur, 0.256,
		\buf, b.orquesta[0], inf)
	)


Synth(\tgrains,[\buf,b])
b.play;


d["piano"][1].play

(
~piano1 = Pbind(\instrument,\sinte,\buf,d["piano"][1],\dur,16,\amp,1);
~piano2 = Pbind(\instrument,\sinte,\buf,d["piano"][1],\dur,32,\amp,1,\rate,0.5);
)
(
c = ();
c.orquesta = PathName("/Users/sdcarr/Documents/GitHub/My-setup-sc-live-coding/samples/set1/techno/").entries.collect({|n|
	Buffer.readChannel(s,n.fullPath, channels:[0]);
});
)
 c.techno[0].play
c.techno[0].play

// Cargar buffers de audio en una lista
~buffers = [
	Buffer.read(s, "d["etnico"]"),
    Buffer.read(s, "path/to/your/sample2.wav"),
    // Añadir más buffers según sea necesario
];






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



