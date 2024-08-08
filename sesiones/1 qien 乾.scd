// tempo
t = p.clock.tempo_(120/60);
////////
("../Setup/Setup.scd").loadRelative;

// 乾 乾 乾 乾 PRIMERA PIEZA: QIAN  乾 乾 乾 乾 //

(
////////////////  1 //////////////////

~a[0] = Pbind(
	\instrument, \bpfsaw,
	\dur, 5,
	\midinote, Pxrand([
		[72.0, 78.999999999972, 84.0, 88.99999999998, 96.0 ],
		[72.0, 78.999999999972, 84.0, 88.99999999998, 96.0 ]+9,
		[72.0, 78.999999999972, 84.0, 88.99999999998, 96.0 ]+4,
		[72.0, 78.999999999972, 84.0, 88.99999999998, 96.0 ],
	]-12,inf),
	\detune, 0.08,
	\cfmin,100,
	\cfmax, 1500,
	\atk,2,
	\rel,8,
	\ldb, 6,
	\amp,0.1,
	\out,0
);
////////////////  2 //////////////////


~b[0] = Pbind(
	\instrument, \bufseg1,
	\bufnum, d["china"][2],
	\startSec,0,// Pwhite(0, d["china"][1].duration * 0.6, inf),
	\rate, Pxrand([1,0.6,5],inf),
	\dur, 10,//Pexprand(0.2, 0.9, inf),
	\legato, 1,
	// 70% chance of being a rest
    //\dummy, Pwrand([Rest(), 1], [0.2, 0.6].normalizeSum, inf),
	\amp,0.5
);


////////////////  3 //////////////////

~c[0] = Pbind(
	\instrument, \superSaw,
	\dur, 1,
	\midinote, Pseq([30],inf)+ Prand([0],inf),
	\db, Pseq([0,-1,-1,-1,-1,-1,-1,-1,],inf)*24 - 15,
	\sleve,1,
	\rel, 0.2,
	\cr,-12,
	\atk, 0,
	\dec,0,
	\lpf,200,
	\lrq,0.5,
	\pan,0,

);

////////////////  4  //////////////////

~d[0] = Pbind(
	\instrument,\buf,
\buf, d["china"][7],//Pxrand(d["set-sounds"], inf),
	\dur, 4,
	\rate, Pwhite(0.5,1.5,inf),
	\amp, 0.9,//Pwhite(0.4,1.0,inf),
	\atk, 0.5,
	\sus, 3.4,
	\rel, 0.05
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

~mix = {~a +~b + ~c+~d}
~a+~b + ~c+~d
~a+~d+ ~b
/////////////////////////////////////////////////////////


~a.quant_(1).fadeTime_(0).play;
~a.stop
~a.resume

~a.pause

~a.clear



~b.quant_(1).fadeTime_(0).play;
~a.stop
~b.play
~a.pause
~b.pause


// bass
~c.quant_(1).fadeTime_(0).play
~c.pause
~a.stop
~a.resume
~a.pause


~d.quant_(1).fadeTime_(0).play
~d.play
~d.stop


~d.pause


~off = Tdef(\off, {
	~a.stop;
	4.wait;
	~b.stop;
	4.wait;
	~c.stop;
	4.wait;
	~d.stop;
	4.wait;


});

~on = Tdef(\on, {
	~a.play;
	4.wait;
	~b.play;
	4.wait;
	~c.play;
	4.wait;
	~d.play;
	4.wait;


});
~on.play;

~mix={};






