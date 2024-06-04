
if(currentEnvironment.isKindOf(ProxySpace).not) {
	p = ProxySpace.new.push;
};

q = ();  // Event i.e. a dictionary

q.buffers = List.new;

Dialog.getPaths({ arg paths;
    paths.do({ |soundPath|
        soundPath.postln;
        q.buffers.add(Buffer.read(s, soundPath));
	});  // btw: please close brackets at the same level
});

q.buffers[7].play
q.buffers






("Setup/Setup.scd").loadRelative;

Pan2.ar(Synth(\grainBuf,[\freq,400]))


d["etnico"][0]

Synth(\BUFSynth),[\sndbuf, b.orquesta[4], \amp, 1])!2;

(
b = ();
b.orquesta = PathName("/Users/sdcarr/Documents/GitHub/My-setup-sc-live-coding/samples/set1/orquesta/").entries.collect({|n|
	Buffer.readChannel(s,n.fullPath, channels:[0]);
});
)
{b.orquesta[3]!2}.play

b.orquesta[2].play




b = Buffer.readChannel(s, "/Users/sdcarr/Documents/GitHub/My-setup-sc-live-coding/samples/set1/orquesta/debussy_98.mp3");


(
l = Prewrite(1, // start with 1
        (    1: [0.25,2],
            0.25: [3,3,2]/4,
        3/4: [0.25,1,0.125,0.125],
        ), 4);

~a = Pbind(
	\instrument, \grainbuf,
	\buf, b.orquesta[0],
	\dur,l,
	\amp, 1000000,
	\rate, 0.5

)
)
~a.pause

~a.play








SCLOrkSynths.gui

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



