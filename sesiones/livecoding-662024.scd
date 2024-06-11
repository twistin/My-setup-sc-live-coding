(
p = ProxySpace(
	server:s.boot,
	clock: t = TempoClock(90/60).permanent_(true)
).push;
)

p.fadeTime_(4);
~a.play;
~a.fadeTime;
~a.quant
~a.clear

p == currentEnvironment




(
b = ();
Buffer.freeAll;
b.glitch = PathName("/Users/sdcarr/Desktop/My-setup-sc-live-coding/samples/set1/glitch/").entries.collect({ |n|
Buffer.readChannel(s,n.fullPath, channels: [0]);
});
)

b.glitch[0].play

SynthDef(\a, {
	var sig, env;
	env = Env.perc(\atk.ir(0.001),\rel.ir(0.1), -4).ar(2);
	sig = Saw.ar(\freq.ir(400));
	sig = MoogFF.ar(sig, \cf.ir(200), \gain.ir(2));
	sig = Pan2.ar(sig, \pan.ir(0), \amp.ir(0.5));
	sig = sig * env;
	Out.ar(\out.ir(0), sig);
}).add;


SynthDef(\b, {
	var sig, env;
	env = Env.perc(\atk.ir(0.001),\rel.ir(0.1)).ar(2);
	sig = PlayBuf.ar(1, \buf.ir(0), \rate.ir(1));
	sig = Pan2.ar(sig , \pan.ir(0), \amp.ir(0.5));

	sig = sig * env;

	Out.ar(\out.ir(0), sig);
}).add;



///////////////////////////////
~pad.fadeTime = 2

~pad.play;

~pad.pause;

~pad.resume;

~pad.fadeTime_(4)
~pad.quant_(p.clock.beatDur * 4)

~padmod = { SinOsc.kr(1).range(0.3, 1)}

~padmod = { LFSaw.kr(2.neg).exprange(0.1,1)}



~padmod = { SinOsc.kr(1).range(0.3, 1)}

(
~pad ={
	var sig;
	sig = LFTri.ar([100,101] * 2) * 0.2;
	sig = sig *  ~padmod.kr(1);


};




~pad2 ={
	var sig;
	sig = Saw.ar([100,101] * 2 * -2.midiratio) * 0.1;

	sig = LPF.ar(sig,1000);
	sig = sig *  ~padmod.kr(1);


};

)
~pad.play;
~pad2.play;

~pad.stop;
~pad2.stop;

~rev.play
(
~rev = {
	var sig;
	sig = GVerb.ar(~pad.ar(2).sum + ~pad.ar(2).sum, 300, 5);
	sig = LPF.ar(sig,1500);
	sig = sig * 0.1;
}
)


~freq = {([72,74,65, 69] + .x [0,0.3]).midicps}

~pad ={
	var sig;
	sig = LFTri.ar(~freq.kr) * 0.2;
	sig = sig *  ~padmod.kr(1);

};
(
Atk.userKernelDir.openOS;
Atk.userMatrixDir.openOS;
Atk.userSoundsDir.openOS;
)
Quarks.install("https://github.com/JamesWenlock/AmbiVerbSC")
(
("The ATK quark component % installed!").format(
    Quarks.isInstalled("atk-sc3").if({
        "is"
    }, {
        "isn't"
    })
).postln
)
(Platform.userExtensionDir +/+ "SC3plugins/ATK").openOS
(Quarks.folder +/+ "atk-sc3").openOS

(
s.waitForBoot {
    var sound, encoded, binaural;
    // Generar una señal de prueba: un tono sinusoidal
    sound = SinOsc.ar(440, 0, 0.1);
    // Codificar la señal en Ambisonics de primer orden
    encoded = FoaEncode.ar(sound, azimuth: 0, elevation: 0);
    // Decodificar la señal para auriculares usando HRTF (Head-Related Transfer Function)
    binaural = FoaDecodeB2.ar(2, encoded);
    // Reproducir el sonido
    Out.ar(0, binaural);
};
)
Atk.downloadMatricesAtk.openUserSupportDir
Atk.downloadKernels

 Atk.openUserSupportDir

("../Setup/Setup.scd").loadRelative;

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
~drone = Pbind(
	\instrument, \droneFM,
	\dur,1,
	\amp, 0.01,
	\nFreq, 80,
	\f1Freq, 0.1,
	\f2Freq, 1.1,
	\f3Freq, 2.1,
)
)


~mix = {~drone + ~hodes+ ~bass}

~drone.pause


(
~rhodes = Pbind(
	\instrument, \FMRhodes1,
	\freq, Pseq([[80,85, 89], [445,455, 465],[555,565,575]],inf),
	\dur,2
)
)
~rhodes.play
Synth(\FMRhodes1)

~k = Pbind(\instrument,\BUFSynth,\buf,d["k"][1],\dur,1,\amp,0.2);

~k.play

~k.pause
~bass = Pbind(
	\insrument, \frameDrum,
	\dur, 0.25,
	\freq, Pseq([100,150,160,200],inf)
)


~bass.play
~bass.pause
~bass.resume

~bass2 = Pbind(
	\insrument, \frameDrum,
	\dur, 0.25,
	\freq, Pseq([200,250,260,300],inf)
)

~bass2.play
~bass2.pause
Ndef(\off,{
3.do({
	~rhodes.pause;
	2.wait;
	~bass.pause;
	2.wait


});
})