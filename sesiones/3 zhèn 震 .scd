// tempo
t = p.clock.tempo_(90/60);

t = TempoClock.default.tempo_(90/60); // Ajusta el tempo si es necesario

////////
("../Setup/Setup.scd").loadRelative;

// 震  震  震  震  震  震 QUINTA PIEZA: zhèn 震  震  震  震  震  震 //


////////////////  1 //////////////////
Synth(\FMRhodes1)

~a = Pbind(
	\instrument, \FMRhodes1,
	\scale, Scale.majorPentatonic,
	 //\degree, Pseq((0..7) ++ (6..0) ++ [\rest], 1),
	\degree, Pseq([0,3,5,7]+2,inf),
	\dur, 0.25
)
~a.play


~b.play
~b = Pbind(
	\instrument, \FMRhodes1,
	\scale, Scale.majorPentatonic,
	 //\degree, Pseq((0..7) ++ (6..0) ++ [\rest], 1),
	\degree, Pseq([0,3,5,7],inf),
	\dur, 0.25
)



~c.play
~c = Pbind(
	\instrument, \FMRhodes1,
	\scale, Scale.majorPentatonic,
	 //\degree, Pseq((0..7) ++ (6..0) ++ [\rest], 1),
	\degree, Pseq([0,3,5,7]-5,inf),
	\dur, 0.25
)


~d.play
~d= Pbind(
	\instrument, \FMRhodes1,
	\scale, Scale.majorPentatonic,
	 //\degree, Pseq((0..7) ++ (6..0) ++ [\rest], 1),
	\degree, Pseq([0,3,5,7,10,7,5]-10,inf),
	\dur, 1/2,
	\amp, 0.4
)



(
l = Prewrite(0.25,
	(
		0.25: #[0.25,0.25,0.25,0.5],
		0.5: #[0.25,0.5,0.125,0.125,0.125,0.125],
		0.125: #[0.375,0.125],
		0.375: #[0.375,0.375],
		1: #[1,0.25]
),10);

~e= Pbind(
	\instrument, \FMRhodes1,
	\scale, Scale.majorPentatonic,
	 //\degree, Pseq((0..7) ++ (6..0) ++ [\rest], 1),
	\degree, Pseq([0,3,5,7],inf),
	\dur, l,
	\amp,0.3
)
)

~e.play
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


///////////////////////////////////////////////////////////
~a +~b+ ~c+~d+~e
~mix = { ~a +~b +~c +~d+~e}

/////////////////////////////////////////////////////////
~a.play;
~b.play;
~c.play;
~d.play;
~e.play;

~a.pause;
~b.pause;
~c.pause;
~d.pause;
~e.pause;

~a.resume;
~b.resume;
~c.resume;
~d.resume;
~e.resume;





////////////////////////// Final //////////////////////////
~off.play;
(
~off = Tdef(\off,{
	~a.stop;
	6.wait;
	~b.stop;
	5.wait;
	~c.stop;
	4.wait;
	~d.stop;
	10.stop;
		~e.stop;
	10.stop

})
)

~mix= {}



