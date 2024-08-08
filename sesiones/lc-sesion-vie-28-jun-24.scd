
("../Setup/Setup.scd").loadRelative;
p.clock.tempo_(100/60);
p.fadeTime_(4)
//kick808
// arg out, freq1, freq2, amp,ringTime, att, rel , dist, pan
(
~a =  Pbind(
	\instrument,  \kick808,
	\dur, 1,
	\amp,0.6,
	\freq1, 200,
	\att, 0.001,
	\rel,0.5

);




~b =  Pbind(
	\instrument,  \snare1,
	\dur, 2,
	\amp,1,
	\freq, 100,
	\att, 0.001,
	\rel,0.05

);
)
~a.quant_(1).play

// \snare1,

~b.quant_(1).play

~b.resume

(
~c = Pbind(
	\instrument, \clapOto309,
	\dur, Pxrand([1/2,1/4,1],inf),
	\amp,0.3,

)
)

~c.quant_(1).play;
~a.resume;
~c.resume



(
~d = Pbind(
	\instrument,\hihatElectro,
	\dur,Pseq([1, 2, 1, 3, Rest(1), 2, Rest(3)], inf), //Pseq([1/4, Rest(1/4), 1/4,1/4], inf),
	\amp,0.4
);
)

~d.resume
~d.quant_(1).play;

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
~on = Tdef(\on, {
	~a.quant_(1).play;
	5.wait;
	~b.play.quant_(1);
	5.wait;
	~c.play.quant_(1);
	3.wait;
	~d.play.quant_(1);
	10.wait;
})
)


~resume = Tdef(\resume, {
	~a.resume;
	5.wait;
	~b.resume;
	5.wait;
	~c.resume;
	3.wait;
	~e.resume;
	4.wait;
	~d.resume;
	10.wait;
	~f.resume;
	10.wait;
})

~off = Tdef(\off, {
	~a.pause;
	5.wait;
	~b.pause;
	5.wait;
	~c.pause;
	3.wait;
	~e.pause;
	4.wait;
	~d.pause;
	10.wait;
	~f.pause;
	10.wait;
	~g.pause;
	6.wait;
})



~mix = {~h }
~f + ~g +~c + ~b + ~d
~mix = {}

~b + ~e + ~c
Rest


Scale.directory

///////  bass
// arg out=0, amp=0.1, gate=1, pan=0, spread=0.8, freq=200, doneAction=2;

(
~e = Pbind(
	\instrument, \bass,
	\scale, Scale.minorPentatonic,
	\octave,3,
	\degree, Pxrand([ 0, 3, 5, 7, 10 ], inf),
	\dur, Pseq([1/4, 1/4,Rest(1/2),1/2], inf),
	\spread, 1,
	\amp, -10.dbamp
)
)

~e.play.quant_(1);

~e.resume

//////// pad
//  Synthdef =  \pad_ho
//arg == \atk,\sus,\rel, \freq, \amp

(
~f = Pbind(
	\instrument, \apadMH,
	\scale, Scale.minorPentatonic,
	\octave, 4,
	\degree, Pseq([[0, 3, 5],[ 5, 7, 10],[3, 5, 7] ], inf),
	\amp, -20.dbamp,
	\dur, 4

)
)

~f.quant_(1).play;

// Supersaw synthdef

// arg out = 0, pan = 0, gate = 1, amp = 0.5, freq = 40,
//	att = 0.1, dec = 0.2, sus = 0.9, rel = 5, crv = 0,




~g.quant_(1).play;

~g.resume;

(
~g = Pbind(
	\instrument, \superSaw,
	\midinote, Pseq([69,72,79,82,89]-12,inf),
	\dur, 2,
	\pan, Pxrand([-0.3,-0.8,0, 0.3,0.8],inf),
	\amp, -20.dbamp
)
)


VarLag
//////////////

////////////// Drum
                    ///////////// \abstractDrum


// Standard values
//	out = 0, freq = 140, amp = 1, pan = 0, att = 0.001, dec = 0.01, rel = 1,
	// Other Controls (position goes from 0 to 1)
//	position = 0.5, ampSlope = 3, decCoef = 0.15, hiFreqSus = 0;


(
l = Prewrite(0.25,
    (
        0.25: #[0.25,0.25,0.25,0.5],
        0.5: #[0.25,0.5,0.125,0.125,0.125,0.125],
        0.125: #[0.375,0.125],
        0.375: #[0.375,0.375,1],
        1: #[0.75,0.25],
        0.75: #[16]
),60);


~h = Pbind(
	\instrument, \abstractDrum,
	\dur, l,
	\freq, Pxrand([100,80,150,200],inf),
	\pos , Pxrand([0.3,0.6,1],inf),
	\amp, 1


)

)

~h.quant_(1).play






