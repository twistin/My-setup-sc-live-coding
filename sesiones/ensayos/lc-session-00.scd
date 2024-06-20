
("../Setup/Setup.scd").loadRelative;
s.plotTree
{SawDPW.ar(120,XLine.kr(80,120,1))}.play
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

BenoitLib


//////// Buffers
s.options.sampleRate = 48000
s.options.sampleRate
SampleRate
(
b = ();
b.voces = PathName("/Users/sdcarr/Desktop/My-setup-sc-live-coding/samples/set1/voces/").entries.collect({|n|
	Buffer.readChannel(s,n.fullPath, channels:[0]);
});
)
b.voces[1].play
 Synth(\BUFSynth, [\buf, b.voces[0]])
~tempo = 60 / 144 * 4;
~clock = TempoClock(~tempo);

(

   ~v = Pbind(
        \instrument, \BUFSynth,
        \amp, 0.79,
        \dur, Pwhite(0.5,1.5,inf),
        \buf,  b.voces[1],
	    \rate, Pwhite(1,1.9,inf),
	    \sus, 6,
	    \atk, Pseq([0.04,0.4, 0.9],inf)

);
)
~v.play
~v.pause
~v.stop
~v.resume
~mix = {nil}
~mix.pause
~mix.resume
~b.fadeTime_(4)
(
~b = Pbind(
	\instrument, \ping_mh,
	\freq, Pseq([220,89,440,100]+24,inf),
	\amp, 0.8,
	\dur, 0.75,
	\rate,4,
	\depth,0.03,
	\att,0.001
	).play(t,quant:4);

m.control(0,20,rrand(0,122));


~a =Pbind(
	\type, \midi,
	\dur, 0.75,
	\midicmd,\noteOn,
	\midiout, m,
	\midinote, Pxrand(Scale.minorPentatonic.degrees+50,inf)+Prand([0,12,24], inf),
	\amp, 0.4,
	\sustein, 0.02

).play(t,quant:4);
)
~a.resume
~a.pause
~b.play
~b.stop
~b.play
~b.pause
~b.resume









