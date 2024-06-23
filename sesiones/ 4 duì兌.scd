

// tempo
t = p.clock.tempo_(90/60);
////////
("../Setup/Setup.scd").loadRelative;

// 兌 兌 兌 兌 兌 兌 兌 CUARTA PIEZA:  duì 兌 兌 兌 兌 兌 兌 //

(
////////////////  1 //////////////////

~a[0] = Pbind(
	\instrument, "hihat",
	\dur, Pseq([Rest(1/4), 1/4], inf),
	\att, 0.01,
	\rel, 0.1,
	\ffreq, 11000,
	\pan, 0,
	\amp, 0.3
);
////////////////  2 //////////////////


~b[0] = Pbind(
	\instrument, "snare",
	\dur, Pseq([Rest(1/2), 1/2], inf),
	\att, 0.01,
	\rel, 0.1,
	\sinfreq, 180,
	\ffreq, 2000,
	\amp, 0.25

);


////////////////  3 //////////////////

~c[0] = Pbind(
	\instrument, "kick",
	\dur, 1/2,
	\att, 0.01,
	\rel, 0.22,
	\sinfreq, 60,
	\glissf, 0.9,
	\amp, 1,
);


////////////////  4  //////////////////

~d[0] = Pbind(
    \instrument, "sawSynth",
    \midinote, Pseq([
        [50, 53, 55, 57],
        [53, 56, 58, 60],
		Prand([
			[56, 59, 61, 63],
            [49, 52, 54, 56],
		], 1)
		],
        inf
    ),
    \dur, Prand([1, 3, 4, 4.5], inf),
	\att, 0.1,
	\rel, Pkey(\dur) + 1,
	\hifreq, 5000,
    \amp, 0.2
);

//////////////////////// 5 /////////////////

~e[0] = Pbind(
	\instrument, "sawSynth",
	\midinote, Pseq([36, 32, 32, 37], inf),
	\dur, Pseq([1/4, 1/4, 1/2, Rest(3), 1/4], inf),
	\ctranspose, [0, -12],
	\att, 0.01,
	\rel, 0.2,
	\amp, 0.4,
	\lofreq, 100,
	\hifreq, 1000
);








//////////////////////// controles /////////////////////

            ///////////  reverb ///////////

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
);

)
///////////////////////////////////////////////////////////

~mix = {~a + ~b ~c+~d}

/////////////////////////////////////////////////////////

//hh
~a.quant_(1).fadeTime_(0).play;
~a.stop;
~a.resume;
~a.pause;

~a.clear;

///snare

~b.quant_(1).fadeTime_(0).play
~b.stop
~b.resume
~b.pause



// bass
~c.quant_(1).fadeTime_(0).play
~c.stop
~c.resume
~c.pause


~d.quant_(1).fadeTime_(0).play
~d.play
~d.resume
~d.stop



~e.quant_(1).fadeTime_(0).play
~e.pause
~e.resume
~e.stop




~on = Tdef(\on, {
	~a.play;
	4.wait;
	~b.play;
	4.wait;
	~c.play;
	4.wait;
	~d.play;
	4.wait;
	~e.play;
	2.wait


});


~off = Tdef(\off, {
	~a.stop;
	4.wait;
	~b.stop;
	4.wait;
	~c.stop;
	4.wait;
	~d.stop;
	4.wait;
	~e.stop;
	2.wait


});




~off.play;

~mix={};

~e.release(2);
~d.release(2);






//////////////// 4










