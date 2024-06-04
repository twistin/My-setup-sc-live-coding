
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




d["etnico"][0]

Synth(\grainbuf,[\sndbuf, q.buffers[8], \amp, 1])

(
~a = Pbind(
	\instrument, \grainbuf,
	\buf, q.buffers[1],
	\dur,1)


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





	~p = Pbind(
		\instrument,\tgrains,
		\dur, 0.256,
		\buf, Pseq(d[\foldernames].collect({ |folder| folder.collect(_.bufnum) }).flat, inf)
	)
)

Synth(\tgrains,[\buf,b])
b.play;


d["piano"][1].play

(
~piano1 = Pbind(\instrument,\sinte,\buf,d["piano"][1],\dur,16,\amp,1);
~piano2 = Pbind(\instrument,\sinte,\buf,d["piano"][1],\dur,32,\amp,1,\rate,0.5);
)


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



