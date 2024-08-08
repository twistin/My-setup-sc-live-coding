SuperClean.implClass

SuperClean.buffers
(
~a = Pdef(0,
	Pbind(*[
		type:\cln,
		snd:\mmd,
		num:Pseq([1,7,9,3,2,4,5],inf),
		dur: 1/4,
		amp: Plprand(0.25,1.0),
		pan: Pmeanrand(0.0,1.0),
		jpr:0.1,
		jps:0.3

	])
).play
)



(
~b =Pdef(1,
	Pbind(*[
		type: \cln,
		snd: \fmx,
		dur: 1/4,
		pan: Pwhite(0.0, 1.0),
		degree: Pxrand([0,3,5,7,9],inf),//Pseq((0 .. 7), inf),
		stepsPerOctave: Pwhite(1, 12),
		jpr:0.1,
		jps:0.5,
		amp: 0.8
	])
).play
)
Pdef(0).pause;
Pdef(1).pause;


~a  = \filter -> {|in| GVerb.ar(in, roomsize:100, maxroomsize:1000)};

Pdef(0).pause;
Pdef(0).resume;
Pdef(0).play;




TempoClock.default.tempo = 60/60;
Quarks.install("CuePlayer");
a = CuePlayer.new
~clean.soundLibrary.postln
a.gui
a.put(1, {"this is cue 1".postln});
a.put(2, {"this is cue 2".postln});

a.put(3,{ Synth(\add,[\note,60]) });
a.put(4,{ Synth(\oneNote,[\note,63]) });
a.put(5,{ Synth(\oneNote,[\note,67]) });
a.put(6,{ Synth(\oneNote,[\note,72]) });

~clean.loadSoundFiles("/Users/sdcarr/Desktop/My-setup-sc-live-coding/samples/set1/");
~clean["china"][0].play