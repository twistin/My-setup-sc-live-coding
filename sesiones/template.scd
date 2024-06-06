// --------------------------
// Plantilla SuperCollider
// --------------------------

// Configuración Inicial
("../Setup/Setup.scd").loadRelative;// Arranca el servidor

// Opcional: Configuración de parámetros de audio
s.options.numOutputBusChannels = 2; // Estéreo

// --------------------------
// Definición de SynthDefs
// --------------------------








SynthDef(\simpleSynth, {

    var sig, env;
	sig = SinOsc.ar(\freq.ir(440), 0, \amp.ir(0.1));
	env = Env.perc(\atk.ir(1),\rel.kr(1)).ar(2);
    sig = Pan2.ar(sig, \pan.ir(0));
    sig = sig *env;
	Out.ar(\out.ir(0), sig );
}).add;

// Añade tus SynthDefs personalizados aquí
// SynthDef(\yourSynth, { ... }).add;

// --------------------------
// Buffers y Samples
// --------------------------
// Carga de muestras si es necesario
p.quant_(4)
(
b = ();
b.etnico = PathName("/Users/sdcarr/Documents/GitHub/My-setup-sc-live-coding/samples/set1/etnico/").entries.collect({|n|
	Buffer.readChannel(s,n.fullPath, channels:[0]);
});
)

(
c = ();
c.k = PathName("/Users/sdcarr/Documents/GitHub/My-setup-sc-live-coding/samples/set1/etnico/").entries.collect({|n|
	Buffer.readChannel(s,n.fullPath, channels:[0]);
});
)
prewrite
// --------------------------
// Patrones y Pbinds
// --------------------------
~pattern1 = Pbind(
    \instrument, \harpsichord2,
    //\freq, Pseq([440, 660, 880], inf),
    \amp, 0.9,
    \dur, Pseq([0.25, 0.5, 0.75, 0.5], inf),
	\midinote, Pwhite(35,100,inf),
	\atk, 0.02
);

~pattern2 = Pbind(
    \instrument, \distortedGuitar,
    \freq, Pseq([330, 550, 770], inf),
    \amp, 0.15,
    \dur, Pseq([0.25, 0.5, 0.75, 0.5], inf)
);

~pattern3 = Pbind(
	\instrument, \kickBlocks

)

(
l = Prewrite(1, // start with 1
        (    1: [0.25,2],
            0.25: [3,3,2]/4,
		3/4: [0.25,1,0.125,0.125],
        ), 4);
~k = Pbind(\instrument,\kickBlocks,\buf,d["k"][0],\dur,l,\amp,1);
~k.play;
~sn = Pbind(\instrument,\snareElectro,\buf,d["s"][0],\dur,2,\amp,1);
~k.play
~sn.play

~sn = Pbind(\instrument,\hihatElectro,\buf,d["s"][0],\dur,l,\amp,1);


)
// --------------------------
// Controladores y Funciones Útiles
// --------------------------

~pattern1.play
~pattern2.play

~pattern1.pause
~pattern2.stop
~startPattern = { |pattern| pattern.play };
~stopPattern = { |patternPlayer| patternPlayer.stop };

~fadeOutAndStop = { |patternPlayer, fadeTime = 5|
    var volume = 1.0;
    Routine({
        while { volume > 0.0 } {
            volume = volume - (1.0 / (fadeTime * 10)); // Reducción del volumen
            volume = max(volume, 0.0); // Asegurarse de que el volumen no sea negativo
            patternPlayer.set(\amp, volume);
            (0.1).wait; // Esperar 0.1 segundos entre cada paso del fade out
        };
        patternPlayer.stop;
    }).play;
};

// --------------------------
// Ejecución Inicial
// --------------------------
// Inicia patrones
~pattern1Player = ~startPattern.(~pattern1);
~pattern2Player = ~startPattern.(~pattern2);

// --------------------------
// Espacio para Live Coding
// --------------------------
// Aquí puedes añadir, modificar y ejecutar código en tiempo real
