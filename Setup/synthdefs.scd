



             //////// Biblioteca SynthDef ////////

                      ////// Drums //////////
                      ////// KICKS /////

// 808
(
SynthDef("kick808", {arg out = 0, freq1 = 240, freq2 = 60, amp = 1, ringTime = 10, att = 0.001, rel = 1, dist = 0.5, pan = 0;
	var snd, env;
	snd = Ringz.ar(
		in: Impulse.ar(0), // single impulse
		freq: XLine.ar(freq1, freq2, 0.1),
		decaytime: ringTime);
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	snd = (1.0 - dist) * snd + (dist * (snd.distort));
	snd = snd * env;
	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "unknown",
	category: \drums,
	tags: [\percussion, \kick, \808]
)
).add;

//kickBlocks
/*
This SynthDef combines three kick SynthDefs by Nathan Ho that use very similar building blocks.
It should be very easy to add more of the same blocks for even more layers!

Originals use Hasher.ar(Sweep.ar) as a quick way to generate deterministic white noise,
to get exactly the same kick each time for a precise digital sampler effect.
WhiteNoise.ar should work too.

Some of the attacks are so fast that Env:kr doesn't correctly handle them.

Modified and combined into one SynthDef by Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef("kickBlocks", {
	arg
	//Standard Values
	out = 0, pan = 2, amp = 0.4, curve = -4,
	//tone1 arguments
	t1freq = 400, t1harmonic = 2, t1glide = 0.01,
	t1att = 0.0005, t1rel = 0.01, t1curve = -4, t1del = 0, t1amp = 1,
	//tone2 arguments
	t2freq = 50, t2harmonic = 3.44, t2glide = 0.01,
	t2att = 0.0001, t2rel = 0.3, t2curve = \lin, t2del = 0.005, t2amp = 1,
	//hit1 arguments
	h1freq = 100, h1harmonic = 8, h1glide = 0.01, h1rq = 0.6,
	h1att = 0.001, h1rel = 0.02, h1curve = -4, h1del = 0.001, h1amp = 1,
	//hit2 arguments
	h2freq = 1320, h2harmonic = 1, h2glide = 0,
	h2att = 0.003, h2rel = 0.03, h2curve = -4, h2del = 0, h2amp = 0.5,
	//click arguments
	cfreq = 6100, crq = 1, camp = 1.41;

    var snd, noise, tone1, tone2, hit1, hit2, click;

	noise = Hasher.ar(Sweep.ar); //deterministic white noise

    tone1 = SinOsc.ar(
		freq: XLine.ar(start: t1freq * t1harmonic, end: t1freq, dur: t1glide),
		mul: Env.perc(attackTime: t1att, releaseTime: t1rel, level: t1amp, curve: t1curve).delay(t1del).ar);

	tone2 = SinOsc.ar(
		freq: XLine.ar(start: t2freq * t2harmonic, end: t2freq, dur: t2glide),
		mul: Env.perc(attackTime: t2att, releaseTime: t2rel, level: t2amp, curve: t2curve).delay(t2del).ar);

    hit1 = BPF.ar(
		in: noise,
		freq: XLine.ar(start: h1freq * h1harmonic, end: h1freq, dur: h1glide),
		rq: h1rq,
		mul: Env.perc(attackTime: h1att, releaseTime: h1rel, level: h1amp, curve: h1curve).delay(h1del).ar);

	hit2 = HPF.ar(
		in: noise,
		freq: XLine.ar(start: h2freq * h2harmonic, end: h2freq, dur: h2glide),
		mul: Env.perc(attackTime: h2att, releaseTime: h2rel, level: h2amp, curve: h2curve).delay(h2del).ar);

	click = BPF.ar(
		in: Impulse.ar(0) * SampleRate.ir / 48000,
		freq:  cfreq,
		rq: crq,
		mul: camp);

	snd = Mix.ar(tone1 + tone2 + hit1 + hit2 + click).tanh * amp;

	DetectSilence.ar(in: snd, doneAction: 2);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "originals by Nathan Ho aka snapizz",
	category: \drums,
	tags: [\bass]
	)
).add;

);

//"kick_oto309"

/* Received from
https://github.com/supercollider-quarks/SynthDefPool/blob/master/pool/kick_oto309.scd

A wide variety of sounds can be achieved through changing the "Other Controls" section.
A siren sound is also available if you extend the attack and release.

Modified by Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef("kick_oto309", {
	arg
	//Standard Values:
	out = 0, amp = 0.1, pan = 0, att = 0.005, rel = 0.29, curve = -4,
	//Other Controls:
	filterHarmonic = 1.5, preamp = 1.25, pulseAmp = 0.5, noiseAmp = 1, sineAmp = 1;

	var env, envp, snd;

	env = Env.new(levels: [0.5, 1, 0.5, 0], times: [att, rel * 0.2, rel * 0.9], curve: [curve, curve/2, curve]).kr(doneAction:2);
	envp = Env.new(levels: [110, 59, 29], times: [att, rel], curve: [curve, curve * 1.25]).kr.midicps;

	snd = LFPulse.ar(freq: envp).range(-1 * pulseAmp, pulseAmp);
	snd = snd + WhiteNoise.ar(mul: noiseAmp);
	snd = LPF.ar(in: snd, freq: envp * filterHarmonic, mul: env);
	snd = snd + SinOsc.ar(freq: envp, phase: 0.5, mul: env * sineAmp);

	snd = Mix.ar(snd) * preamp;
	snd = snd.clip2(1) * amp;

	Out.ar(out, Pan2.ar(snd));
},
metadata: (
	credit: "Originally from 08091500Acid309 by_otophilia",
	category: \drums,
	tags: [\kick, \drum, \percussion]
	)
).add;




////// SNARES
//oneclapThor

/* Received from
https://github.com/supercollider-quarks/SynthDefPool/blob/master/pool/oneclap_thor.scd

published on the sc-users list 2009-01-08 by thor

Modified by Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef("oneclapThor", {
	arg
	//Standard Values
	out = 0, amp = 0.1, att = 0.003, rel = 0.00035, freq = 100, rq = 0.1, pan = 0,
	//Other Controls
	echohz1 = 33.333, echohz2 = 33.156, curve = -4, decay = 0.06, shelfFreq = 7000, rs = 0.5, db = -3,
	// Controls Ranging from 0 to 1
	size = 0.15, tone = 0.4, mix = 0.23, damp = 0.5;

	var env, snd, noise1, noise2, hpf1, hpf2, delay1, delay2;

	noise1 = GrayNoise.ar(1 - tone) + WhiteNoise.ar(tone);

	noise1 = noise1 + SinOsc.ar(freq: [freq / 2, freq / 2 + 4 ]);

	noise2 = PinkNoise.ar;

	noise2 = noise2 + SinOsc.ar(freq: [freq, (freq * 1.04)] * XLine.kr(start: 1, end: 0.01, dur: 3));

	hpf1 = RLPF.ar(in: noise1, freq: freq, rq: rq);

	hpf2 = RHPF.ar(in: noise1, freq: freq/2, rq: rq/4);

	env = Env.perc(attackTime: att, releaseTime: rel, curve: curve).kr;

	snd = Mix.ar(hpf1 + hpf2) * env;

	delay1 = CombN.ar(in: snd, maxdelaytime: 1.1/echohz1, delaytime: 1/echohz1, decaytime: decay / 2);

	delay2 = CombN.ar(in: snd, maxdelaytime: 1.1/echohz2, delaytime: 1/echohz2, decaytime: decay);

	snd = FreeVerb.ar(in: Mix.ar(delay1 + delay2), mix: mix, room: size, damp: damp, mul: amp);

	snd = BHiShelf.ar(in: snd, freq: shelfFreq, rs: rs, db: db);

	DetectSilence.ar(snd, doneAction: 2);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "original by thor",
	tags: [\clap, \handclap]
	)
).add;

// SNARE1

(
SynthDef("snare1", {arg out = 0, amp = 0.1, sinfreq = 180, att = 0.01, rel = 0.2, ffreq = 2000, pan = 0;
	var snd1 = WhiteNoise.ar(amp);
	var snd2 = SinOsc.ar(sinfreq,0,amp);
	var env = Env.perc(att, rel).kr(doneAction: 2);
	var mix = HPF.ar(snd1, ffreq) + snd2;
	mix = mix * env;
	Out.ar(out, Pan2.ar(mix, pan));
},
metadata: (
	credit: "Bruno Tucunduva Ruviaro",
	category: \drums,
	tags: [\percussion, \snare]
)
).add;

);


//snareElectro

/* Retrieved from
http://sccode.org/1-5aD

Original by Nathan Ho aka Snappizz
http://sccode.org/1-523

Modified by Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef("snareElectro", {
    arg
	//Standard Values
	out = 0, pan = 0, amp = 0.4, att = 0.001, rel = 0.15, curve = -4,
	//Other Controls, blend ranges from 0 to 1
	popfreq = 160, sweep = 0.01, noisefreq = 810, rq = 1.6, blend = 0.41;

    var pop, popEnv, popSweep, noise, noiseEnv, snd;

    // pop makes a click coming from very high frequencies
    // slowing down a little and stopping in mid-to-low
    popSweep = Env.new(levels: [20.4, 2.6, 1] * popfreq, times: [sweep / 2, sweep], curve: \exp).ar;

    popEnv = Env.perc(attackTime: att, releaseTime: 0.73 * rel, level: blend, curve: curve).kr;

	pop = SinOsc.ar(freq: popSweep, mul: popEnv);

    // bandpass-filtered white noise
    noiseEnv = Env.perc(attackTime: att, releaseTime: rel, level: 1 - blend, curve: curve).kr(doneAction: 2);

	noise = BPF.ar(in: WhiteNoise.ar, freq: noisefreq, rq: rq, mul: noiseEnv);

    snd = Mix.ar(pop + noise) * amp;

    Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Nathan Ho aka Snappizz",
	category: \organ,
	tags: [\pitched]
	)
).add;


////// TOMS

/* Retrieved from
http://sccode.org/1-5aD

DrumSynths SC Example - SOS Drums by Renick Bell, renick_at_gmail.com
recipes from Gordon Reid in his Sound on Sound articles
SOStom -------
http://www.soundonsound.com/sos/Mar02/articles/synthsecrets0302.asp

Modified by Bruno Ruviaro and Josh Mitchell 8/19.
*/

// sosTom
SynthDef("sosTom", {
	arg out = 0, pan = 0, drumRel = 0.4, stickRel = 0.01, drumModeAmp = 0.25, freq = 250, timbreIndex = 0.77, amp = 1, att = 0.005, curve = -6;

	var drumMode, drumModeEnv, stick, stickEnv, snd;

	drumModeEnv = Env.perc(
		            attackTime: att,
		            releaseTime: drumRel,
		            level: 0.5,
		            curve: curve).kr(doneAction: 2);

	drumMode = PMOsc.ar(
		            carfreq: Saw.ar(freq: freq * 0.9),
					modfreq: freq * 0.85,
					pmindex: timbreIndex,
					mul: drumModeEnv * 10);

	drumMode = drumMode + SinOsc.ar(freq: [freq, freq * 0.8], mul: drumModeEnv);

	drumMode = Mix.ar(drumMode) * drumModeAmp;

	stick = Crackle.ar(chaosParam: 2.01);

	stickEnv = Env.perc(attackTime: att, releaseTime: stickRel, level: 3, curve: curve).kr;

	snd = Mix.ar(drumMode + stickEnv) * amp;

	snd = LeakDC.ar(snd);

    Out.ar(out, Pan2.ar(snd, pan));

},
metadata: (
	credit: "Renick Bell",
	category: \drums,
	tags: [\pitched, \tom, \sos]
	)
).add;



////// CLAPS

//clapElectro


/* Retrieved from
http://sccode.org/1-5aD

Original by Nathan Ho aka Snappizz, http://sccode.org/1-523

**Note: Cool reverse-snare type sounds can be achieved with a slightly longer attack**

Modified By Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef("clapElectro", {
    arg
	//Standard Arguments
	out = 0, amp = 0.5, pan = 0, att = 0.02, rel = 0.2, curve = -4,
	//Other Controls: mix is 0 - 1, fadeTime is a fraction of noise1's length.
	mix = 0.6, fadeFreq = 4000, fadeTime = 0.52;

    var env1, env2, snd, noise1, noise2;

    // noise 1: four short repeats
    env1 = Env.new(
            levels: [0, 1, 0, 0.9, 0, 0.7, 0, 0.5, 0],
            times: [att / 20, 0.009, 0, 0.008, 0, 0.01, 0, 0.03],
            curve: [0, curve, 0, curve, 0, curve, 0, curve]
        ).kr;

    noise1 = WhiteNoise.ar(env1);
	noise1 = HPF.ar(in: noise1, freq: 600);
    noise1 = LPF.ar(
		    in: noise1,
		    freq: XLine.kr(start: 7200, end: fadeFreq, dur: fadeTime * 0.058)
	    );
    noise1 = BPF.ar(in: noise1, freq: 1620, rq: 3);

    // noise 2: one longer single burst
	env2 = Env.perc(attackTime: att, releaseTime: rel, curve: [0, curve]).kr;

    noise2 = WhiteNoise.ar(env2);
    noise2 = HPF.ar(in: noise2, freq: 1000);
    noise2 = LPF.ar(in: noise2, freq: 7600);
    noise2 = BPF.ar(in: noise2, freq: 1230, rq: 0.7);

	//Mixing
	snd = Mix.ar((mix * noise1) + ((1 - mix) * noise2));
	snd = (snd * 2).softclip;
	snd = snd * amp;

	DetectSilence.ar(in: snd, doneAction: 2);

    Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Nathan Ho aka Snappizz, http://sccode.org/1-523",
	category: \drums,
	tags: [\unpitched, \clap, \electronic, \percussion]
	)
).add;


/// clapOto309


/*Retrieved from
https://github.com/supercollider-quarks/SynthDefPool/blob/master/pool/clap_oto309.scd
*/

SynthDef("clapOto309", {
	arg out = 0, amp = 0.1, pan = 0;
	var env1, env2, snd, noise1, noise2;

	env1 = Env.new(
		levels: [0, 1, 0, 1, 0, 1, 0, 1, 0],
		times: [0.001, 0.013, 0, 0.01, 0, 0.01, 0, 0.03],
		curve: [0, -3, 0, -3, 0, -3, 0, -4]
	).ar;
	env2 = Env.new(
		levels: [0, 1, 0],
		times: [0.02, 0.3],
		curve: [0, -4]
	).ar(doneAction: 2);

	noise1 = WhiteNoise.ar(env1);
	noise1 = HPF.ar(noise1, 600);
	noise1 = BPF.ar(noise1, 2000, 3);

	noise2 = WhiteNoise.ar(env2);
	noise2 = HPF.ar(noise2, 1000);
	noise2 = BPF.ar(noise2, 1200, 0.7, 0.7);

	snd = noise1 + noise2;
	snd = snd * 2;
	snd = snd.softclip * amp;

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "08091500Acid309 by otophilia",
	category: \drums,
	tags: [\clap, \percussion]
	)
).add;



////// CYMBALS

//cymbalicMCLD


/*
Recieved from
https://github.com/supercollider-quarks/SynthDefPool/blob/master/pool/cymbalic_mcld.scd

Based on the example at
http://www.mcld.co.uk/cymbalsynthesis/
published 2008 by Dan Stowell
Synth(\cymbalic_mcld)

Modified by Bruno Ruviaro and Josh Mitchell 8/19
*/

SynthDef(\cymbalicMCLD, {

	arg
	//Standard Values
	out = 0, pan = 0, amp = 0.5, att = 0.001, rel = 0.5, curve = -4,
	//Filter Frequencies
	lodriverMax = 20000, lodriverMin = 10, hidriverMax = 10001, hidriverMin = 1, hiAtt = 1, hiRel = 3, loAtt = 0.5, loRel = 5;

	var lodriver, locutoffenv, hidriver, hicutoffenv, freqs, snd, thwack, env;

	locutoffenv = Env.perc(attackTime: loAtt, releaseTime: loRel, level: (lodriverMax - lodriverMin), curve: curve).kr;

	lodriver = LPF.ar(WhiteNoise.ar(0.1), (locutoffenv + lodriverMin));

	hicutoffenv = Env.perc(attackTime: hiAtt, releaseTime: hiRel, level: (hidriverMax - hidriverMin), curve: curve).kr;

	hidriver = HPF.ar(WhiteNoise.ar(0.1), (hidriverMax - hicutoffenv));
	hidriver = hidriver * Env.perc(attackTime: hiAtt, releaseTime: 2/3 * hiRel, level: 0.25).kr;

	thwack = Env.perc(attackTime: att, releaseTime: att).kr;

	// This bit will regenerate new freqs every time you evaluate the SynthDef!
	freqs = {exprand(300, 20000)}.dup(100);

	env = Env.new(levels: [0, amp, amp, 0], times: [att, (loRel + hiRel), rel]).kr(doneAction: 2);

	snd = Ringz.ar(in: lodriver + hidriver + thwack, freq: freqs).mean;
	snd = Mix.ar([(snd * 1), (lodriver * 2), thwack]);
	snd = snd * env;
	snd = Limiter.ar(snd, amp);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Dan Stowell",
	category: \drums,
	tags: [\percussion, \cymbal, \gong, \inharmonic, \additive, \subtractive]
	)
).add;



// cymbal808

/*
Retrieved from
https://github.com/supercollider-quarks/SynthDefPool/blob/master/pool/cymbal808_ryan.scd

Published on sc-users 2007-08-25 by Ryan Brown

alternate freqs values found in original:
	[78.6, 140.44, 123.87, 219.4, 787.5, 531.3];
	[300, 402.6, 369.36, 495.96, 585.69, 645.69];
	[205.35, 254.29, 294.03, 304.41, 369.64, 522.71];

Modified by Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef(\cymbal808, {
	arg
	//Standard Values:
	out = 0, pan = 0, att = 0.002, dec = 0.25, rel = 0.05, amp = 0.1,
	//Other Controls:
	freqMultiplier = 4.09, decLevel = 0.4, reverb = 0.33, size = 0.5, damp = 0.5;

	var snda, sndb, snd, env, pulseEnv, freqs;

	freqs = [205.35, 304.41, 369.64, 522.71, 540.54, 812.21];

	env = Env.new(
		levels: [0, 1, decLevel, 0],
		times: [att, dec, rel],
		curve: [0, -0.5, 0]
	).kr;

	pulseEnv = Env.new(
		levels: [1.0, 0.6],
		times: dec,
		curve: -0.5
	).kr;

	snd = Mix.ar(LFPulse.ar(freq: freqs * 4.09));

	snd = (BinaryOpUGen('==', snd, 6.0) * 0.6) + (BinaryOpUGen('==', snd, 2.0) * 0.2) + (BinaryOpUGen('==', snd, 1.0) * 0.9);

	snd = (snd * pulseEnv) + Mix.ar(LFPulse.ar(freq: freqs, width: 0.55, mul: 0.9));

	snd = RLPF.ar(in: snd, freq: 7000, rq: 0.6);
 	snd = RHPF.ar(in: snd, freq: 6800, rq: 1.5);
	snd = RHPF.ar(in: snd, freq: 6800, rq: 1.5);
	snd = RHPF.ar(in: snd, freq: 1200, rq: 1.5);

	snd = snd + FreeVerb.ar(in: snd, mix: reverb, room: size, damp: damp);
	snd = Mix.ar(snd);
	snd = snd * env * amp;

	DetectSilence.ar(in: snd, doneAction: 2);

	OffsetOut.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Published on sc-users 2007-08-25 by Ryan Brown",
	category: \drums,
	tags: [\808, \hihat, \percussion, \cymbal, \unpitched]
	)
).add;


// hashercymbal

/*
Here's yet another cymbal synthdef. This one's kind of cool in that it uses a
hash function to generate a really small chunk of sampled noise, which repeats
with a frequency set by looprate. Then, this just gets sampled at a lower rate
than supercollider's internal sample rate (see the decimator SynthDef for more
on that), and sent through a high pass filter with a fairly smooth slope across
most of the audible range of the sound.

The samplerate control seems to affect the pitch of the signal more directly than
the looprate control, but they do interact a lot, so it's probably easiest to just
play around with both of these controls.

The timbre control just alters the values the hash function sees, causing a slight
change in timbre. If it's changed continually during a note, you can get some
interesting noises.

By Josh Mitchell June 2020
*/

SynthDef("hashercymbal", {
    arg
	//Standard Values
	out = 0, pan = 0, amp = 0.1, att = 0.001, rel = 0.25, crv = -6,
    //Other controls
	timbre = 0, looprate = 10000, samplerate = 18500;

	var env, snd;

	// Envelope
	env = Env.perc(
		attackTime: att,
		releaseTime: rel,
		level: amp,
		curve: crv).ar(doneAction: 2);

	// Generating a loop of the same scrambled values to use as a noise source
	snd = Impulse.ar(freq: looprate, mul: 2, add: -1);
	snd = Sweep.ar(snd) + timbre;
	snd = Hasher.ar(in: snd);

	// Aliasing the noise and filtering out low frequencies
	snd = Latch.ar(
		in: snd,
		trig: Impulse.ar(
			freq: samplerate.clip(20, SampleRate.ir/2),
			mul: 2,
			add: -1));
	snd = HPF.ar(
		in: snd,
		freq: [62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000],
		mul: [1/9, 2/9, 3/9, 4/9, 5/9, 6/9, 7/9, 8/9, 9/9]);

	// Output stuff
	snd = Mix.ar(snd) * env;
	snd = Limiter.ar(snd);

	Out.ar(out, Pan2.ar(snd, pan));

},
metadata: (
	credit: "Josh Mitchell",
	category: \drums,
	tags: [\unpitched, \cymbal, \noisy]
	)
).add;



////// HIHAT

//hihat1

(
SynthDef("hihat1", {arg out = 0, amp = 0.5, att = 0.01, rel = 0.2, ffreq = 6000, pan = 0;
	var snd = WhiteNoise.ar(amp);
	var env = Env.perc(att, rel).kr(doneAction: 2);
	snd = HPF.ar(snd * env, ffreq);
	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Bruno Tucunduva Ruviaro",
	category: \drums,
	tags: [\percussion, \hihat]
)
).add;





// hihatElectro

/* Retrieved from
http://sccode.org/1-5aD

By Nathan Ho aka Snappizz
http://sccode.org/1-523

Modified by Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef("hihatElectro", {
    arg out = 0, pan = 0, amp = 0.3, att = 0.001, rel = 0.3, curve = -8, filterFreq = 4010, rq = 0.56;

    var env, snd;

    // noise -> resonance -> exponential dec envelope
    env = Env.perc(attackTime: att, releaseTime: rel, curve: curve).kr(doneAction: 2);

	snd = ClipNoise.ar(amp);
	snd = BPF.ar(
		in: snd,
		freq: [1, 1.035] * filterFreq,
		rq: [0.27, 1] * rq,
		mul: [1.0, 0.6]
	);
	snd = Mix(snd) * env;

    Out.ar(out, Pan2.ar(snd, pan));

	},
metadata: (
	credit: "By Nathan Ho aka Snappizz",
	category: \drums,
	tags: [\clap, \percussion, \hihat]
	)
).add;




////// BASS

//doubleBass


/*
This Double Bass SynthDef, (originally called "~bass") was made by Matias Monteagudo on
his Generative Jazz Project "MM – Coltrane’s Giant Steps," which can be found here:
https://patchstorage.com/mm-giant-steps-with-visuals/

First, a percussive envelope is defined in order to mimic the distinctive pluck of a double bass.
Frequency modualation synthesis is used such that the sine oscillators "op1", "op2", "op3", and "op4" are
operators with phase modulation. "op1", "op2", and "op3" share harmonic overtones while "op4" shares the fundamental
frequency. "op4" utilizes slight frequency deviation, which can be altered through the "freqDev" argument. This frequency deviation alters the level of precision in the intonation of each note, such that a value of zero would create perfect intonation on each note. The "mul" arguments for each operator linearly increase or decrease the amplitude for their
respective sine oscillators. Then, "op4" is passed through a delay line with multi-channel expansion. A high pass filter
removes frequencies below human perception. The array of channels is then spread across the stereo field,
and the "pan" and "sprd" argument can be used to alter this. A sub-bass is added which is correspondingly
panned, and the "subAmp" argument linearly increases or decreases its amplitude. Lastly, a limiter provides protection
in the event that extreme values are passed into the Synth.

Modifications Made:
- argument/variable names, formatting, and syntax were altered to better fit the SCLOrkSynth guidlines and conventions
- documentation was added in the form of comments outlining processes throughout the SynthDef
- a percussive envelope was substitutued over an ADSR envelope for the sake of optimization
- a sub-bass was added to build a deeper double bass sound
- the "pan", "sprd", "subAmp", and "freqDev" arguments were added and appropriatley substituted
- the "maxdelaytime" argument in the DelayN UGen was altered to 0.06 to fit the maximum of the established "delaytime" range
- constants in mul arguments throghout processes were multiplied together and reduced to simplify the SynthDef
- a limiter was added to provide protection against large amplitudes

By Matias Monteagudo, Prof. Composer, Salzburg Austria
Description by Suhel Keswani
SynthDef and Pattern modified by Suhel Keswani and Josh Mitchell, September 2020
*/

SynthDef("doubleBass", {
	arg
	// Standard Values
	out = 0, pan = 0, amp = 1.0, freq = 440, att = 0.01, rel = 1.0 , crv = -30, vel = 1.0,
	// Other Controls
	freqDev = 2, op1mul = 0.1, op2mul = 0.1, op3mul = 0.1, sprd = 0.5, subAmp = 0.1;

	var env, op1, op2, op3, op4, snd, sub;

	// Percussive Envelope
	env = Env.perc(
		attackTime: att,
		releaseTime: rel,
		curve: crv
	).ar(doneAction: 2);

	// Overtones
	op1 = SinOsc.ar(
		freq: freq * 4,
		mul: vel / 2 + op1mul);

	op2 = SinOsc.ar(
		freq: freq * 3,
		phase: op1,
		mul: vel / 2 + op2mul);

	op3 = SinOsc.ar(
		freq: freq * 2,
		phase: op2,
		mul: vel / 2 + op3mul);

	// Fundamental Frequency
	op4 = SinOsc.ar(
		freq: freq + NRand(-1 * freqDev, freqDev, 3),
		phase: op3,
		mul: vel);

	// Delay Line with Multi-Channel Expansion
	snd = {
		DelayN.ar(
			in: op4,
			maxdelaytime: 0.06,
			delaytime: Rand(0.03, 0.06)
		)} !8;

	// High Pass Filter
	snd = LeakDC.ar(snd);

	// Stereo Spread
	snd = Splay.ar(
		inArray: snd,
		spread: sprd,
		level: 0.6,
		center: pan);

	// Add a sub
	sub = SinOsc.ar(
		freq: freq/2,
		mul: env * subAmp);
	sub = Pan2.ar(sub, pan);
	snd = snd + sub;

	//Ouput Stuff
	snd = snd * env;
	snd = snd * amp;
	snd = Limiter.ar(snd);
	Out.ar(out, snd);
},
metadata: (
	credit: "Matias Monteagudo",
	category: \bass,
	tags: [\pitched, \bass]
)
).add;



//ksBass




/*
This is a synthDef based on Karplus-Strong synthesis (just like Pluck.ar).

Karplus-Strong synthesis involves an initial impulse being sent through a delay,
which then, through a feedback loop, creates a sound with a frequency given by
1/(the delay time), which often sounds like a string pluck. There's usually a
filter in the feedback loop of the delay, which is the coef argument of Pluck.
It's pretty important to the string sound. However, it takes math to get the
pitch right when there's any filter in the feedback loop, and I don't really
like the typical Pluck.ar sound anyways.

So, I rebuilt a simpler version of Pluck! The biggest difference aside from the
filter being after the delay line, instead of in a feedback loop, is the initial
pulse I used. Using a sharp impulse produces a saw-like sound, but the initial
shape I made looks a bit like a trapezoid, for a less "buzzy" sound. The shape
of it varies with the impulse Att, Sus, Dec, and Hold parameters; if one is
bigger, that section of the shape lasts for a longer percentage of the waveform.

Stethoscope.new is helpful when playing around with the shape.

I also added a simple compressor, because of the apparent volume level changes
different impulse shapes can cause. If you don't want it, just set ratio to 1.

By Josh Mitchell June 2020
*/

SynthDef("ksBass", {
    arg
	// Standard Values
	out = 0, pan = 0, freq = 100, amp = 1, rel = 1.5,
    // Parameters for the impulse shape
	impulseAtt = 0.5, impulseSus = 1, impulseDec = 0.5, impulseHold = 1,
	// Filter and compressor parameters, thresh goes from 0 to 1.
	filtermin = 250, filtermax = 5000, rq = 0.35, thresh = 0.4, ratio = 2.5;

	var total, exciter, snd;

	// Rescale impulse values for the frequency of the note
	total = (impulseAtt + impulseSus + impulseDec + impulseHold) * freq;

	// Initial impulse
	exciter = Env.new(
		levels: [0, 1, 1, 0, 0],
		times: [impulseAtt, impulseSus, impulseDec, impulseHold]/total).ar;

	// Delay line
	snd = CombN.ar(
		in: exciter,
		maxdelaytime: 0.06,
		delaytime: 1/freq,
		decaytime: rel);

	// LPF
	snd = RLPF.ar(
		in: snd,
		freq: LinExp.ar(Amplitude.ar(in: snd), 0, 1, filtermin, filtermax),
		rq: rq);

	// Compressor for fun
	snd = CompanderD.ar(
		in: snd,
		thresh: thresh,
		slopeBelow: 1,
		slopeAbove: 1/ratio);

	// Output stuff
	snd = Mix.ar(snd) * amp;
	snd = Limiter.ar(snd);

	DetectSilence.ar(in: snd, doneAction: 2);

    Out.ar(out, Pan2.ar(snd, pan));

},
metadata: (
	credit: "Josh Mitchell",
	category: \bass,
	tags: [\pitched, \bass]
	)
).add;

// noQuarterBass


/*
By Eric Sluyter
Retrieved from https://sccode.org/1-4YY and
https://sound.stackexchange.com/questions/35138/help-me-make-a-patch-for-this-bass-stab-pluck

Slightly reformatted by Bruno Ruviaro November 2019.

from Eric:
"You could definitely use any number of hardware synths or plugins to do the same thing. General method I used, create a "pluck" sound with Karplus-Strong synthesis, and combine with a triangle wave, sine wave, and sub sine (sine wave at 1/2 the frequency). I also added a "click" at the beginning to give a little more punch. Then used enveloped resonant low pass filters to give it that synthy twang, and applied a little distortion to give it some color."
*/

SynthDef("noQuarter", {
	arg
	// Standard Arguments
	out = 0, freq = 440, amp = 0.1, pan = 0, att = 0, rel = 1, curve = -4;

	var subfreq = freq / 2;

	// Envelopes
	var subenv = Env.perc(attackTime: att, releaseTime: rel, level: amp, curve: curve).kr(doneAction: 2);
	var env = Env.perc(att, rel/2, amp, curve).kr;

	// Component synthesis
	var pluck = Pluck.ar(
		in: PinkNoise.ar,
		trig: 1,
		maxdelaytime: 0.2,
		delaytime: subfreq.reciprocal
	) * subenv * 2;
	var tri = VarSaw.ar(freq) * env;
	var sin = SinOsc.ar(freq) * env;
	var sub = (SinOsc.ar([subfreq, subfreq - 2, subfreq + 2]).sum * subenv).tanh;
	var click = RLPF.ar(
		in: Impulse.ar(0),
		freq: [2000, 8000],
		rq: 1
	).sum * 1000;

	// Initial signal
	var snd = pluck + tri + sub + click;

	// Resonant LPFs
	snd = RLPF.ar(
		in: snd,
		freq: XLine.ar(freq * 100, freq * 10, 0.15)
	);
	snd = snd + (MoogFF.ar(in: snd, freq:  freq * 20, gain: 2.5) * 0.1);

	// EQ resulting signal
	snd = BPeakEQ.ar(snd, 400, 0.5, -9);
	snd = BPeakEQ.ar(snd, 2000, 0.5, 6);
	snd = BHiShelf.ar(snd, 8000, 1, 3);
	snd = BPeakEQ.ar(snd, 200, 1, 3);

	// Apply another envelope to dampen a bit more
	snd = snd * XLine.kr(1, 0.6, 0.1);

	// Tanh distortion / limiting
	snd = (snd * 1).tanh;

	// Another round of signal coloring, using another RLPF
	// and sine components
	snd = snd +
	RLPF.ar(
		in: snd,
		freq: XLine.ar(freq * 100, freq * 10, 0.15)
	) + sin + sub;

	// Another round of tanh distortion / limiting
	snd = (snd / 2.3).tanh;

	// Another resonant LPF
	snd = MoogFF.ar(
		in: snd,
		freq: XLine.ar(freq*150, freq*30, 0.1),
		gain:  0.1
	);

	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
},
metadata: (
	credit: "by Eric Sluyter",
	category: \bass,
	tags: [\pitched, \bass, \karplus]
	)
).add;



// rubberBandBass

/*
A silly little sound from my ongoing quest to make Pluck sound a little bit
less like Pluck. Here, the sound going in isn't a normal short impulse, but
a sine wave that gets quickly swept from one frequency down (or up!) to
another one. The idea comes from some percussion and modal synthesis
experiments I've done, and I wondered what this same technique would do to
Pluck. Turns out, it sounds kinda like a cartoony rubber band! So, I added a
little bit of pitch bend at the beginning of the note, controlled by bendTime
and bendMultiple, and called it a day.

By Josh Mitchell July 2020.
*/

SynthDef(\rubberBand, {
	arg
	// Standard Values
	out = 0, amp = 1, freq = 75, pan = 0, att = 0, rel = 1,
	// Impulse arguments (onFraction goes from 0 to 1, coef from -1 to 1)
	bendMultiple = 0.25, bendTime = 0.075, impulseStartFreq = 800,
	impulseStopFreq = 120, onFraction = 1, coef = 0.125;

	var impulse, freqline, snd;

	// Stuff that gets sent into Pluck
	freqline = Line.ar(
		start: freq * bendMultiple,
		end: freq,
		dur: bendTime);

	impulse = SinOsc.ar(
		freq: Line.ar(
			start: impulseStartFreq,
			end: impulseStopFreq,
			dur: 1/freq * onFraction));

	// Pluck
    snd = Pluck.ar(
	    in: impulse,
	    trig: Impulse.ar(0),
	    maxdelaytime: 1/(freq * bendMultiple),
	    delaytime: 1/freqline,
	    decaytime: rel,
	    coef: coef,
		mul: amp);

	// Output Stuff
    DetectSilence.ar(in: snd, doneAction: 2);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Josh Mitchell",
	category: \bass,
	tags: [\pitched]
	)
).add;

// subBass2


/*
A sub Bass based on octave-down guitar/bass effects from the 80s or so.
This version changes where on the input wave switching happens,
meaning the sub octave is more distorted and gritty than subBass1.

Josh Mitchell, 8/19.
*/

SynthDef(\subBass2, {
    arg
	//Blend goes from 0 to 1
	out = 0, amp = 0.5, pan = 0, freq = 440, att = 0.001, rel = 1, curve = 8, blend = 0.5;

    var env, in, ina, synca, octa, inb, syncb, octb, octave, snd;

	//A slightly rounded percussive envelope
	env = Env.perc(att, rel, amp, [curve, -1 * curve]).kr(doneAction: 2);

	/*  Input wave +/- 90 degrees - To use SinOsc.ar, replace:
	        -"iphase:  0" with "phase: pi/2"
	        -"iphase:  1" with "phase: 0"
	        -"iphase: -1" with "phase: pi"   */
	in = LFPar.ar(freq: freq * 2, iphase: 0);
	ina = LFPar.ar(freq: freq * 2, iphase: 1);
	inb = LFPar.ar(freq: freq * 2, iphase: -1);

	//Two square waves exactly out of phase and an octave below the input wave
	synca = LFPulse.ar(freq: freq, iphase: 0);
	syncb = LFPulse.ar(freq: freq, iphase: 0.5);

	//This smoothly swaps between outputting the +90 degree wave and -90 degree wave
	octa = ina * synca;
	octb = inb * syncb;
	octave = Mix.ar([octa, octb]);

	//Mixer stage, volume adjustments, envelope, and output
	snd = Mix.ar([octave * blend, in * (blend - 1)]);
    snd = LeakDC.ar(snd);
	snd = Limiter.ar(in: snd, level: 1);
	snd = snd * env;


	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Josh Mitchell, 2019",
	category: \bass,
	tags: [\pitched, \sub]
	)
).add;

);


////// KEYBOARDS


// FMRhodes1

/*
Retrieved from: http://sccode.org/1-522

FM Rhodes Synthesizer

by Nathan Ho (snappizz)

Native SuperCollider port of STK's Rhodey. This should be preferred over the StkInst version because:

- It uses much less CPU.
- It is easier to modify.
- It doesn't require sc3-plugins or a correct setting of StkGlobals.
- It's beginner-friendly because it uses only basic UGens: SinOsc, EnvGen, Mix, Pan2, Out.

Modified by Josh Mitchell and Bruno Ruviaro in July 2019.

*/

SynthDef(\FMRhodes1, {
    arg
    // standard meanings
    out = 0, freq = 440, gate = 1, pan = 0, amp = 0.1, att = 0.001, rel = 1, lfoSpeed = 4.8, inputLevel = 0.2,
    // all of these range from 0 to 1
    modIndex = 0.2, mix = 0.2, lfoDepth = 0.1;

    var env1, env2, env3, env4;
    var osc1, osc2, osc3, osc4, snd;

    env1 = Env.perc(att, rel * 1.25, inputLevel, curve: \lin).kr;
    env2 = Env.perc(att, rel, inputLevel, curve: \lin).kr;
    env3 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;
    env4 = Env.perc(att, rel * 1.5, inputLevel, curve: \lin).kr;

    osc4 = SinOsc.ar(freq) * 6.7341546494171 * modIndex * env4;
    osc3 = SinOsc.ar(freq * 2, osc4) * env3;
    osc2 = SinOsc.ar(freq * 30) * 0.683729941 * env2;
    osc1 = SinOsc.ar(freq * 2, osc2) * env1;
    snd = Mix((osc3 * (1 - mix)) + (osc1 * mix));
  	snd = snd * (SinOsc.ar(lfoSpeed).range((1 - lfoDepth), 1));

    snd = snd * Env.asr(0, 1, 0.1).kr(gate: gate, doneAction: 2);
    snd = Pan2.ar(snd, pan, amp);

    Out.ar(out, snd);
},
metadata: (
	credit: "Nathan Ho",
	category: \keyboards,
	tags: [\pitched, \piano, \fm]
)
).add;


// cs80leadMH

/* Recieved from
https://github.com/supercollider-quarks/SynthDefPool/blob/master/pool/cs80lead_mh.scd

Vangelis/Blade Runner lead sound, based on tutorial by meastempo @ http://www.youtube.com/watch?v=Fne0oIEv-WI

Original by Mike Hairston

Pbindef notes copied from https://alijamieson.co.uk/2016/01/08/replicating-blade-runner-soundtrack

Modified by Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef("cs80leadMH", {
	arg
	//Standard Values
	freq = 440, amp = 0.5, gate = 1.0, pan = 0, out = 0,
	//Amplitude Controls
	att = 0.75, dec = 0.5, sus = 0.8, rel = 1.0,
	//Filter Controls
	fatt = 0.75, fdec = 0.5, fsus = 0.8, frel = 1.0, cutoff = 200,
	//Pitch Controls
	dtune = 0.002, vibspeed = 4, vibdepth = 0.015, ratio = 0.8, glide = 0.15;

	var env, fenv, vib, ffreq, snd;


	//Envelopes for amplitude and frequency:
	env = Env.adsr(att, dec, sus, rel).kr(gate: gate, doneAction: 2);
	fenv = Env.adsr(fatt, fdec, fsus, frel, curve:2).kr(gate: gate);

	//Giving the input freq vibrato:
	vib = SinOsc.kr(vibspeed).range(1 / (1 + vibdepth), (1 + vibdepth));
	freq = Line.kr(start: freq * ratio, end: freq, dur: glide);
	freq = freq * vib;

	//See beatings.scd for help with dtune
	snd = Saw.ar([freq, freq * (1 + dtune)], mul: env * amp);
	snd = Mix.ar(snd);

	//Sending it through an LPF: (Keep ffreq below nyquist!!)
	ffreq = max(fenv * freq * 12, cutoff) + 100;
	snd = LPF.ar(snd, ffreq);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Mike Hairston",
	category: \keyboards,
	tags: [\lead, \modulation, \analog, \cs80, \vangelis, \bladerunner]
	)
).add;


// Harpsichord2

/* Retrieved from
http://sccode.org/1-5aD

Harpsichord based on Pluck Ugen
Original by Zé Craum

Modified by Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef(\harpsichord2, {
	arg
	//Standard Values
	out = 0, amp = 0.1, freq = 440, pan = 0, rel = 5,
	//Pluck arguments (blend goes from 0 to 1)
	trig = 1, coef = 0.1, blend = 0.6;

	var exciter, root, octave, snd;

        // You can use white noise here, but Pink is more realistic
	exciter = PinkNoise.ar(amp);

	// Fundamental
        root = Pluck.ar(
	        in: exciter,
	        trig: trig,
	        maxdelaytime: 1/freq,
	        delaytime: 1/freq,
	        decaytime: rel,
	        coef: coef,
	        mul: blend
        );

	// Octave Above
	octave = Pluck.ar(
	        in: exciter,
	        trig: trig,
	        maxdelaytime: 1/(2 * freq),
	        delaytime: 1/(2 * freq),
	        decaytime: rel,
	        coef: coef,
	        mul: (1 - blend)
        );

	// Output Stuff
	snd = Mix.ar(root + octave);
	snd = Limiter.ar(snd);

    DetectSilence.ar(in: snd, doneAction: 2);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Zé Craum",
	category: \keyboards,
	tags: [\pitched]
	)
).add;


/////////////// MISCELANIA

// Ping

/* Received from
https://github.com/supercollider-quarks/SynthDefPool/blob/master/pool/ping_mh.scd

Note from the author:

Your basic percussive synth instrument, a good default sound for testing patterns, etc.

Modified By Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef(\ping_mh,{

	arg freq = 440, amp = 0.2, dur = 1, att = 0.001, curve = -4, pan = 0, out = 0, rate = 4, depth = 0.03;

	var snd, lfo, env;

	lfo = LFNoise2.ar(rate).range(1 / (1 + depth), (1 + depth));

	env = Env.perc(attackTime: att, releaseTime: dur, level: amp, curve: curve).kr(doneAction:2);

	snd = SinOsc.ar(freq: [freq, freq * lfo], mul: env);

	Out.ar(out, Pan2.ar(snd, pan))
},
metadata: (
	credit: "Author Unknown",
	category: \misc,
	tags: [\percussive, \ping, \default, \simple, \stereo, \detuned, \tuned]
	)
).add;

// vintage synth

/* Retrieved from
http://sccode.org/1-5aD
Original by Zé Craum

Crude simulation of old sinusoidal generators - with random vibrato and a high noise floor.

50hz mains hum emulation and slightly distorted sine (a clipped triangle wave) added by Josh Mitchell.

Modified by Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef(\vintageSine, {
	arg
	//Standard Definitions
	amp = 0.2, freq = 440, pan = 0, att = 0.001, sus = 1, rel = 0.5, gate = 1, out = 0,
	//Noise Arguments (mainsDepth is 0 to 1)
	noiseAmp = 0.06, mainsDepth = 0.1, mainsHz = 50,
	//Sine Arguments
	vrate = 2, vdepth = 0.005, sineClip = 0.825;

	var noise, env, snd, vibrato;

	env = Env.asr(att, amp, rel, curve: \lin).kr(gate: gate, doneAction: 2);

	noise = PinkNoise.ar(noiseAmp * LFPar.ar(mainsHz * 2).range((1 - mainsDepth), 1));
	noise = noise + LFPar.ar(freq: mainsHz, mul: noiseAmp/8);

	vibrato = freq * LFNoise2.ar(vrate).range(1/(1 + vdepth), (1 + vdepth));

	snd = Clip.ar(LFTri.ar(vibrato), -1 * sineClip, sineClip).softclip;
	snd = ((snd * amp) + noise) * env;
	Out.ar(out, Pan2.ar(snd, pan));

},
metadata: (
	credit: "Zé Craum; Josh Mitchell",
	category: \misc,
	tags: [\vintage, \pitched]
	)
).add;

// noysy


SynthDef("noisy", {arg out = 0, freq = 440, amp = 0.2, pan = 0.5;
	var snd, env;
	env = Env.perc(0.02, 0.1).kr(doneAction: 2);
	snd = Mix(LFPulse.ar(
		freq: freq * [1, 5/2],
		iphase: 0.0,
		width: 0.5,
		mul: amp));
	snd = snd * env ;
	Out.ar(out, Pan2.ar(snd, pan));
}).add;

// Decimator
/*
This is a synthDef that's inspired by (and tries to replicate) the Decimator quark.

The decimator quark allows you to change the sample rate and bit depth of a signal,
independently of the sample rate and bit depth supercollider is currently running at.
These changes are done in this SynthDef through Latch.ar (a sample-and-hold) and .round,
respectively.

I've also added a pair of low pass filters at the beginning and end of these sections,
as a very basic simulation of an analog-to-digital-to-analog converter. The filters can
be switched on or off (listen to the demo), and they're currently set to half of the new
sample rate (the nyquist frequency). This is because, looking at the frequency domain,
sounds above the nyquist frequency get mirrored around it. Therefore, filtering out the
stuff above the nyquist frequency makes the resulting sound a bit cleaner.

Funnily enough, because of the weird things that happen above the nyquist frequency, my
sample rate clock is only able to go up to the nyquist frequency related to supercollider's
sampling rate without itself being aliased. I set a limit on my decimator's sample rate
because of this, but you can remove it if you want.

Lastly, the preamp control pushes the input signal above a hard clipping threshold to
simulate a signal that's too loud going into an adc. If you don't want this effect, set
the preamp control to 1.

By Josh Mitchell June 2020
*/

SynthDef("decimator", {
    arg
	//Standard Values
	out = 0, pan = 0, freq = 440, amp = 0.1, gate = 1,
	att = 0.001, dec = 0.1, sus = 0.9, rel = 1, crv = -2,
        //Other controls, filterswitch is 0 or 1
	preamp = 1, bitdepth = 16, samplerate = 10000, filterswitch = 0, filtermult = 0.5;

	var rate, env, snd, clock, remainder;

	//Set up the sample rate (Weird things happen above half of supercollider's sample rate)
    rate = samplerate.clip(20, SampleRate.ir/2);

	//Simple adsr envelope
	env = Env.adsr(
		attackTime: att,
		decayTime: dec,
		sustainLevel: sus,
		releaseTime: rel,
		curve: crv).ar(gate: gate, doneAction: 2);

	// Fix the input signal range
	snd = SinOsc.ar(freq: freq, mul: 0.5 * preamp, add: 0.5);
	snd = snd * env;

	//Input filtering to simulate a very cheap adc
	snd = Select.ar(
		which: filterswitch,
		array: [snd, LPF.ar(in: snd, freq: rate * filtermult)]);

	//Sampe Rate Reduction
	clock = LFPulse.ar(freq: rate, width: 0.001) - 0.5;
	snd = Latch.ar(snd, clock);

	//Bit Depth Reduction
	remainder = 2.pow(bitdepth).mod(1);
	snd = Clip.ar(
		in: snd,
		lo: 0,
		hi: 1);
	snd = XFade2.ar(
		inA: snd.round(1/(2.pow(bitdepth).floor)),
		inB: snd.round(1/(2.pow(bitdepth).ceil)),
		pan: (remainder * 2) - 1);

	//Output filtering to simulate a very cheap dac (and other output stuff)
	snd = Mix.ar(((snd * 2) - 1)) * amp;
	snd = Select.ar(
		which: filterswitch,
		array: [snd, LPF.ar(in: snd, freq: rate * filtermult)]);
	snd = LeakDC.ar(snd);
	snd = Limiter.ar(snd);

	Out.ar(out, Pan2.ar(snd, pan));

},
metadata: (
	credit: "Josh Mitchell",
	category: \misc,
	tags: [\pitched, \noisy]
	)
).add;

// Blip

(
SynthDef("blip1", {arg out = 0, freq = 25, numharm = 10, att = 0.01, rel = 1, amp = 0.1, pan = 0;
	var snd, env;
	env = Env.perc(att, rel, amp).kr(doneAction: 2);
	snd = Blip.ar(
		freq: freq * [1, 1.01],
		numharm: numharm,
		mul: env
	);
	snd = LeakDC.ar(snd);
	snd = Mix.ar(snd);
	snd = Pan2.ar(snd, pan);
	Out.ar(out, snd);
},

metadata: (
	credit: "unknown",
	category: \pads,
	tags: [\pitched]
)
).add;



/////////////////// sintesis granular ///////////////////

SynthDef(\grainbuf, {
	var sig, env;

	env = Env([0,1,1,0], [\atk.ir(1),\sus.ir(4),\rel.ir(1)], [1,0,-1]).kr(2);

	sig = GrainBuf.ar(
		numChannels:2,
		trigger:Dust.kr(40), // 40 granos por segundo
		dur:0.05,
		sndbuf: \buf.kr(0),
		rate:BufRateScale.kr(\buf.kr(0)) * \rate.kr(1),
		pos: Line.kr(0,1,BufDur.kr(\buf.kr(0))* \timescale.kr(5)),
		interp:2,
		pan:0,
		envbufnum:-1,
		maxGrains:\mgra.kr(512),

	);
	sig = sig * env ;


	Out.ar(\out.kr(0), sig);

}).add;

/////////////////////////  BUFSynth //////////

SynthDef(\BUFSynth, {
	var sig, env;
	env = Env.perc(\atk.ir(0.001),\rel.ir(0.1)).ar(2);
	sig = PlayBuf.ar(1, \buf.ir(0), \rate.ir(1));
	sig = Pan2.ar(sig, \pan.ir(0),\amp.ir(0.5));
	sig = sig * env;

	Out.ar(\out.ir(0), sig);
}).add;



///////////////////////// Drones /////////// ///////////////////////////////////////////



// FUENTE: https://recarteblog.wordpress.com/
//droneFM01


SynthDef(\droneFM, {
	arg f1Freq=0.1, f2Freq=1.1, f3Freq=2.2, nFreq=440, m1Ratio=1, m2Ratio=2, m3Ratio=3,
	amp=0.1, dur=55, ampM=0.84 , pan=0;
	var sig, car1, mod1, car2, mod2, car3, mod3, env, index;
	index = LFNoise1.kr(0.2).range(2, 12);
	env = EnvGen.kr(Env.new([0, 0.70, 0.70, 0], [dur*0.333, dur*0.333, dur*0.333]), doneAction:2);
	mod1 = SinOsc.ar([nFreq * m1Ratio, nFreq+0.7 * m1Ratio], mul:nFreq * m1Ratio * index) * ampM;
	car1 = SinOsc.ar(f1Freq + mod1);

	mod2 = SinOsc.ar([nFreq * m2Ratio, nFreq+1.4 * m2Ratio], mul:nFreq * m2Ratio * index) * ampM;
	car2 = SinOsc.ar(f2Freq + mod2);

	mod3 = SinOsc.ar([nFreq * m3Ratio, nFreq+0.35 * m3Ratio], mul:nFreq * m3Ratio * index) * ampM;
	car3 = SinOsc.ar(f3Freq + mod3) * 0.4;
	sig = car1 + car2 + car3 * env * amp;
	sig = Pan2.ar(sig, pan);
	Out.ar(0, sig);
}).add;




// \droneFMPulse

SynthDef(\droneFMPulse, {
    var sig, sig1, sig2, sig3, mod1, mod2, mod3, env, index;
    index = LFNoise1.kr(0.5).range(2,12);

    env = Env.new([0,0.70,0.70,0], [\dur.ir(55)*0.333,\dur.ir*0.333,\dur.ir*0.333]).ar(2);


    mod1 = SinOsc.ar([\nfreq.kr(440)*\m1Ratio.kr(1), \nfreq.kr +1.4* \m1Ratio.kr], 0.0,\amp.kr(440)* \m1Ratio.kr * index) * \ampM.kr(0.84);
    sig1 = LFPulse.ar(\f1freq.kr(0.1) + mod1);

      mod2 = SinOsc.ar([\nfreq.kr(440)*\m2Ratio.kr(2), \nfreq.kr +0.7* \m2Ratio.kr], 0.0,\amp.kr* \m2Ratio.kr * index) * \ampM.kr(0.84);
    sig2 = LFPulse.ar(\f2freq.kr(1.1) + mod2);



         mod3 = SinOsc.ar([\nfreq.kr(440)*\m3Ratio.kr(3), \nfreq.kr +0.35* \m3Ratio.kr], 0.0,\amp.kr* \m3Ratio.kr * index) * \ampM.kr(0.84);
    sig3 = LFPulse.ar(\f3freq.kr(2.2) + mod3);

    sig = sig1 * sig2 *sig3 *env * 0.3;
    sig = Pan2.ar(sig, \pan.kr(0));

    Out.ar(\out.kr(0), sig1);
}).add;


//simpledron

SynthDef(\simpledron, {
    | freq = 440, amp = 0.5, dur = 60 |
    var sig, mod, env;
    mod = SinOsc.ar(5 , 0, 0.5,1);
     sig = Resonz.ar( Saw.ar(freq, amp),1000,\rq.ir(1));

    sig = sig + mod;
     env = EnvGen.kr(Env.linen(2, dur, 2), doneAction: 2);
    sig = sig * env;
    //sig = FreeVerb.ar(sig, 0.5, 3, 1);
    Out.ar(0, sig ! 2); // Salida estéreo
}).add;

// Para reproducir el dron
//Synth(\dron, [\freq, 80,\rq, 2]);




// Establece la frecuencia fundamental
~freqFundamental = 80;

// Crea un dron con DFM1
SynthDef(\dronDFM1, {
    var sig, filtro, env;
    // Genera una onda senoidal como fuente de sonido
    sig = SinOsc.ar([~freqFundamental, ~freqFundamental * 1.01], 0, 0.1);
    // Modula la resonancia del filtro para que entre y salga de la auto-oscilación
    filtro = DFM1.ar(
        sig,
        ~freqFundamental * 2, // Frecuencia de corte del filtro
        SinOsc.kr(0.05).range(0.9, 1.1), // Resonancia modulada
        1, // Ganancia de entrada
        0, // Tipo de filtro: 0 para paso bajo
        0.0003, // Nivel de ruido
        0.5 // Escala la salida
    );
    // Usa una envolvente para controlar la duración del dron
    env = EnvGen.kr(Env.linen(10, 60, 10), doneAction: 2);
    filtro = filtro * env;
    // Salida estéreo
    Out.ar(0, filtro ! 2);
}).add;



////////////////////// pad /////////////////////////////////////


//pad


SynthDef(\pad, {
    var sig, env;

    env = Env.asr(1.0,1,1.0).ar(Done.freeSelf, \gate.kr(1));

    sig = Saw.ar(\freq.kr(440)* (LFNoise2.kr(3!8)*0.2).midiratio* [1,2,1,2,2,1,2,1]);
    sig = BPF.ar(sig, {ExpRand(200,900)}!sig.size,0.2)*9.dbamp;
    sig = Splay.ar(sig, 0.3);
    sig = (sig * 10.dbamp).tanh;
    sig = Pan2.ar(sig , \pan.kr(0));
    sig = sig * env;
    sig = sig * -18.dbamp;
    Out.ar(\out.kr(0), sig)
}).add;



// pad ho
SynthDef(\pad_ho, {
	var sig;
	sig = Saw.ar(\freq.kr(440)*({LFNoise2.kr(8) } ! 16 * 0.1).midiratio);
	sig = DelayC.ar(sig, 0.01, {Rand(0,0.01) } ! sig.size);
	sig = Splay.ar(sig);
	sig = sig * Env.asr(3,1,3).ar(Done.freeSelf, \gate.kr(1));
	sig = sig *\amp.kr(-20.dbamp);
	sig = sig!2;
	Out.ar(\out.kr(0), sig);
}).add;



// apadMH


/*Retrieved from
https://github.com/supercollider-quarks/SynthDefPool/blob/master/pool/apad_mh.scd

"A simple sustained sound with vibrato" --Mike Hairston

FreeVerb.ar added by Josh Mitchell.

Modified by Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef(\apadMH, {
	arg
	//Standard Values:
	out = 0, pan = 0, freq = 880, amp = 0.5, att = 0.4, dec = 0.5, sus = 0.8, rel = 1.0, gate = 1,
	//Other Controls:
	vibratoRate = 4, vibratoDepth = 0.015, tremoloRate = 5,
	//These controls go from 0 to 1:
	tremoloDepth = 0.5, reverbMix = 0.5, roomSize = 1, damp = 0.5;

	var env, snd, vibrato, tremolo, mod2, mod3;

	env = Env.adsr(att, dec, sus, rel).kr(gate: gate);
	vibrato = SinOsc.kr(vibratoRate).range(freq * (1 - vibratoDepth), freq * (1 + vibratoDepth));
	tremolo = LFNoise2.kr(1).range(0.2, 1) * SinOsc.kr(tremoloRate).range((1 - tremoloDepth), 1);

	snd = SinOsc.ar(freq: [freq, vibrato], mul:(env * tremolo * amp)).distort;
	snd = Mix.ar([snd]);
	snd = FreeVerb.ar(snd, reverbMix, roomSize, damp);

	DetectSilence.ar(snd, 0.0001, 0.2, doneAction: 2);
	Out.ar(out, Pan2.ar(snd, pan));
},
metadata:(
	credit: "Mike Hairston",
	tags: [\pad, \vibrato, \sustained]
	)
).add;


// feedbackPad1

/*
A pad SynthDef that generates tons of dense harmonic content simply by feeding a
sine wave's output back into its phase input. It's almost exactly what SinOscFB does,
only with a user-controlled delay time between when the output of the sine wave is
measured and when that gets fed back into the phase argument.

By Josh Mitchell July 2020.
*/

SynthDef(\feedbackPad1, {
	arg out = 0, amp = 1, gate = 1, freq = 75, pan = 0,
	// Controls for ampEnv
	att = 2, dec = 1, sus = 1, rel = 4, crv = 0,
	// Controls for fbEnv
	fbStartStop = 0, fbAtt = 3, fbPeak = 0.8, fbDec = 2, fbSus = 0.67, fbRel = 5,
	// Confrols for delEnv
	delStartStop = 0.55, delAtt = 1, delPeak = 0, delDec = 2, delSus = 0.25, delRel = 3.5;

	var snd, fbIn, fbOut, ampEnv, fbEnv, delEnv;

	// Set up the Envelopes
	ampEnv = Env.adsr(
		attackTime: att,
		decayTime: dec,
		sustainLevel: sus,
		releaseTime: rel,
		curve: crv).ar(gate: gate);

	fbEnv = Env.adsr(
		attackTime: fbAtt,
		decayTime: fbDec,
		sustainLevel: fbSus,
		releaseTime: fbRel,
		peakLevel: fbPeak,
		curve: \lin,
		bias: fbStartStop).ar(gate: gate);

	delEnv = Env.adsr(
		attackTime: delAtt,
		decayTime: delDec,
		sustainLevel: delSus,
		releaseTime: delRel,
		peakLevel: delPeak,
		curve: \lin,
		bias: delStartStop).ar(gate: gate);

	// Receive the feedback
	fbIn = LocalIn.ar;

	// The Sound (yup, that's all it is)
	snd = SinOsc.ar(
		freq: freq,
		phase: fbIn * pi);

	// Delay the feedback
	fbOut = DelayC.ar(
		in: snd,
		maxdelaytime: delStartStop.max(delPeak.max(delSus)),
		delaytime: delEnv,
		mul: fbEnv);

	// Send the feedback
	LocalOut.ar(fbOut);

	// Output Stuff
	snd = Mix.ar(snd) * ampEnv * amp;
	snd = Limiter.ar(snd);

    DetectSilence.ar(in: snd, doneAction: 2);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Josh Mitchell",
	category: \pads,
	tags: [\pitched]
	)
).add;


// feedbackPad3

/*
There's an inherent delay that's large enough to matter any time you use LocalIn
and LocalOut for feedback, which I've forgotten about and then been reminded of
by unexpected noises quite a few times. Rather than get annoyed by this, I tried
gaining inspiration from it. For this SynthDef, I leaned into the discrete nature
of digital audio that causes those effects a bit more. This time,the feedback is
first downsampled by Latch.ar, at a frequency of sampleRate, then scaled and
rounded to a number of notes, all a specific number of semitones apart. This gets
put back into the frequency argument of the initial triangle wave, so that it's
generating an arpeggio from itself.   Whoa, that's deep.

The notes control is the number of notes in the arpeggio aside from the fundamental,
and if it's negative or not a whole number, it gets rounded into a positive whole
number. Interval is the equal distance between each note in semitones, but this
doesn't need to be a whole number.

After the feedback loop, the sound goes through some reverb to blend things together,
then a bit of filtering. First there's an HPF fixed at the fundamental frequency to
cut low frequency noise and slightly emphasise the fundamental. If you turn up the
resonance much more than where it's at, it can get ugly. Next, there's a few LPFs
that make a constant-enough dB/oct slope to take out some more high frequencies from
the sound.

By Josh Mitchell July 2020.
*/

SynthDef(\feedbackPad3, {
	arg
	// Standard Values
	out = 0, amp = 0.15, gate = 1, freq = 100, pan = 0,
	// Envelope Controls
	att = 3, dec = 1, sus = 1, rel = 5, crv = 0,
	// Reverb Controls (all go from 0 to 1)
	reverbMix = 0.75, roomSize = 0.9, damp = 0.5,
	// Other Controls (interval is in semitones)
	sampleRate = 20, notes = 6, interval = 7;

	var env, fbIn, snd;

	// Set up the Envelopes
	env = Env.adsr(
		attackTime: att,
		decayTime: dec,
		sustainLevel: sus,
		releaseTime: rel,
		curve: crv).ar(gate: gate);

	// Receive and Sample the feedback
	fbIn = Latch.ar(
		in: (LocalIn.ar + 1)/2,
		trig: Impulse.ar(
			freq: sampleRate));
	fbIn = (fbIn * notes.abs * env).round(1);
	fbIn = (fbIn * interval).midiratio;

	// Make The Sound
	snd = LFTri.ar(
		freq: freq * fbIn,
		mul: env);

	// Feedback the Sound
	LocalOut.ar(snd);

	// Reverb the Sound
	snd = FreeVerb.ar(
		in:  snd,
		mix: reverbMix,
		room: roomSize,
		damp: damp);

	//Filter the Sound
	snd = RHPF.ar(
		in: snd,
		freq: freq,
		rq: 0.5);
	snd = LPF.ar(
		in: snd,
		freq: [62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000],
		mul: 1/9);

	// Output Stuff
	snd = Mix.ar(snd) * amp;
	snd = Limiter.ar(snd);

	DetectSilence.ar(in: snd, doneAction: 2);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Josh Mitchell",
	category: \pads,
	tags: [\pitched]
	)
).add;



// superSaw

/*
This SynthDef is loosely based on the famous "supersaw" from the Roland JP-80x0
synths. The supersaw sound is very common in 2000s-or-so EDM, and in the case of
the Roland supersaw, it's built around 7 detuned saw waves with (as far as I know)
randomly determined phases. Just like in most other supersaws, you can choose how
detuned the saws are, where abs(freq - (detuneRatio * freq)) is the max detuning
in hertz. Here, detuneRatio = 1 gives no detuning.

This SynthDef isn't an exact copy of the Roland supersaw, but it is arguably a lot
more flexible, a superdupersaw, if you will. First of all, it allows you to select
any number of saws from 1 to 100, not just 7, using numOscs. Second, it lets you
determine the stereo spread of these saws with the spread control, and third, it
replaces Roland's blend control between a fundamental saw and its six detuned copies
with a detuneFade control. When detuneFade is 0, all copies have the same volume,
and as it gets higher the most detuned saws fade out more and more, for a more
natural sound (in my opinion).

This SynthDef also has the same envelope filter as midSideSaw.scd, that makes the
sound just a bit grittier. The .softclip after the filter is to vaguely emulate
certain filter circuits that, by nature of their design, distort a signal a tiny
bit as they filter it. If you don't want this, just set the preamp to below 1 but
above 0, as the distortion kicks in at around preamp = 1.

By Josh Mitchell August 2020
*/

SynthDef(\superSaw, {
	arg
	//Standard Values
	out = 0, pan = 0, gate = 1, amp = 0.5, freq = 40,
	att = 0.1, dec = 0.2, sus = 0.9, rel = 5, crv = 0,
	// Detune Controls (spread goes from 0 to 1)
	detuneRatio = 1.025, numberOscs = 100, spread = 1, detuneFade = 0.25,
	// Filter Controls (preamp > 0)
	filterLo = 80, filterHi = 8000, rq = 0.8, preamp = 2,
	fAtt = 3, fDec = 3, fSus = 0.8, fRel = 5;

	var detuneHz, stepSize, faArray, freqArray, ampArray, phaseArray, env, fEnv, snd;

	// Scale detuneRatio and numberOscs
	detuneHz = (detuneRatio - 1) * freq;
	stepSize = (2 * detuneHz)/(numberOscs - 1);

	// An Array used for freqArray and ampArray
	faArray = Array.fill2D(100, 2, {
		arg i, j;
		if (j == 1)
		{ (numberOscs - i).tanh.clip(0, 1).sign }
		{ ((stepSize * i) + (freq - detuneHz)).clip(20, 20000) }
	});
	faArray = faArray.scramble.flop;

	// Generate the Frequencies of all the Saws
	freqArray = faArray[0];

	// Generate the Amplitudes of all the Saws
	ampArray = abs(freq - freqArray);
	ampArray = (detuneHz - ampArray)/detuneHz;
	ampArray = ampArray.pow(detuneFade) * 0.1;
	ampArray = ampArray * faArray[1];

	// Generate the Phases of all the Saws
	phaseArray = {TRand.ar(
		lo: 0.000,
		hi: 2.000,
		trig: Impulse.ar(0))}.dup(100);

	// Envelopes for Volume and LPF
	env = Env.adsr(
		attackTime: att,
		decayTime: dec,
		sustainLevel: sus,
		releaseTime: rel,
		curve: crv).ar(doneAction: 2, gate: gate);
	fEnv = Env.adsr(
		attackTime: fAtt,
		decayTime: fDec,
		sustainLevel: fSus,
		releaseTime: fRel,
		curve: crv).ar(gate: gate);

	// Make the Saws
	snd = LFSaw.ar(
		freq: freqArray,
		iphase: phaseArray,
		mul: ampArray);
	snd = HPF.ar(
		in: snd,
		freq: freqArray);

	//Mix the Saws down to Stereo
	snd = Splay.ar(inArray: snd, spread: spread);
	snd = Normalizer.ar(
		in: snd,
		level: 1,
		dur: 0.02);

	// Filter the Saws
	snd = RLPF.ar(
		in: snd,
		freq: LinExp.ar(
			in: fEnv,
			srclo: 0, srchi: 1,
			dstlo: filterLo, dsthi: filterHi),
		rq: rq,
		mul: (preamp/2).clip(0.0001, inf));
	snd = snd.softclip;
	snd = snd/((preamp/2).clip(0.0001, inf).softclip);

	// Output Stuff
	snd = snd * amp * env;
	snd = Limiter.ar(snd);
	snd = Balance2.ar(
		left: snd[0],
		right: snd[1],
		pos: pan);

	Out.ar(out, snd);
},
metadata: (
	credit: "Josh Mitchell",
	category: \pads,
	tags: [\pitched]
	)
).add;



/////////// PERCUSION

// abstractDrum


/*
This is a SynthDef cobbled together from some other modal percussion SynthDefs
I've worked on recently. The frequencies come from a model for a square-shaped
membrane clamped at the edges (see squareDrum for more on that). However, for
the amplitudes and decay times, some pieces of a model for a plucked string get
added in. That's why it's an abstract drum, it's a terrifying jumble of shapes
just like abstract art!

Position (where on the "string" from 0 to 1 at either end it's plucked) and
decCoef determine the timbre of each note, along with hiFreqSus, which makes
the sound's high frequencies sustain longer as it increases from 0. At really
high values, all the values in decArray are essentially the same. This makes
the sound seem more metallic in a way that reminds me of fm synthesis.

As you can see from the demo, there's tons of different sounds you can get out
of changing these three values!

By Josh Mitchell July 2020.
*/

SynthDef(\abstractDrum, {
	arg
	// Standard values
	out = 0, freq = 140, amp = 1, pan = 0, att = 0.001, dec = 0.01, rel = 1,
	// Other Controls (position goes from 0 to 1)
	position = 0.5, ampSlope = 3, decCoef = 0.15, hiFreqSus = 0;

	var freqarray, amparray, decarray, exciter, snd;

	// Setting up arrays for Klank
	freqarray = Array.fill(8, {
		arg i = 1;
		(
			Array.fill((i + 1), {
				arg j;
				(j + 1).pow(2)
			}) +
			(i + 1).pow(2)
		).sqrt

	});
	freqarray = freqarray.flatten/(2.sqrt);

	amparray = Array.fill(36, {
		arg i;
		if (freqarray[i] > 20000)
			{ 0 }
			{
			    sin(((i + 1) * pi) * position) *
		        (ampSlope * (freqarray[i]).log2).dbamp
		    }
	});
	amparray = amparray/ampSlope;

	decarray = Array.fill(36, {
		arg i;
		exp(-1 * i * decCoef) + hiFreqSus
	});
	decarray = decarray/decarray[0];

	// Exciter
	exciter = Decay2.ar(
		in: Impulse.ar(0),
		attackTime: att,
		decayTime: dec,
		mul: 0.005); // This keeps the volume at a sane level

	// The actual sound-makey part
	snd = Klank.ar(
		specificationsArrayRef:
		    Ref.new([freqarray, amparray, decarray]),
		input: exciter,
		freqscale: freq,
		decayscale: rel);

	// Output Stuff
	snd = Mix.ar(snd * amp * 2);
	snd = Limiter.ar(snd);

	DetectSilence.ar(in: snd, doneAction: 2);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "by Josh Mitchell",
	category: \percussion,
	tags: [\pitched, \modal]
)
).add;


// frameDrum

/*
Frame drums are one of the world's oldest instruments, if not THE oldest. Tons of
different kinds of frame drums show up around the world, and they're pretty simple
in terms of what they're made of. They consist of a (usually) circular membrane, held
tight by a thin frame. Sometimes they have jingly-janglies on them (like a tambourine,
which is a type of frame drum), but this one doesn't.

This SynthDef is literally just a modal model for a vibrating circular membrane, and it
gets very close to the sounds of some frame drums. The massive list of numbers in
freqArray just comes from MATLAB's solutions to bessel functions, which describe how fast
a circle wobbles when you hit it. It's harder to model the amplitudes of a circular
membrane, so I just made a rough estimate for those, based on the nodes for each mode,
where the amplitude of that mode will always be 0. The nodes look like a superposition
of a number of rings on the circle and a number of diameter-slices through the circle,
depending on the number of the mode.

Using that information, it's possible to get a rough estimate of how the timbre of the
drum changes depending on how far from the center of the circle you hit it. This is
controlled by position, where 0 is the center of the drum and 1 is the edge. This is
very key to making the drum sound more realistic in my demo.

On a real drum, the fundamental isn't usually the first frequency mode. This is because
the shape of the first mode causes it to decay faster than the others, so it's not as
noticeable. I've seen the sound from the first mode referred to as a "thump", so I added
thumpAmp and thumpDec to provide some control over this sound.

Another thing in this SynthDef is exBlend, which blends from an impulse at -1 to a short
burst of brown noise at 1. Mixing the two together sounds more like a hand hitting the
drum in my opinion, but that's pretty subjective. Play around with it!

By Josh Mitchell, July 2020
*/

SynthDef(\frameDrum, {
	arg
	// Standard values
	out = 0, pan = 0, freq = 170, amp = 0.5, att = 0.0025, dec = 0.0025, rel = 5, crv = 0,
	// Other controls (position goes from 0 to 1, blend from -1 to 1)
	decCoef = 0.225, position = 0.8, thumpAmp = 0.5, thumpDec = 0.2, exBlend = 0;

	var exciter, freqArray, ampRowArray, ampArray, decArray, snd;

	// An Array of bessel function solutions, normalized to 1 at the fundamental
	freqArray = [
		[ 0.6276, 1, 1.3403, 1.6651, 1.9804, 2.2892, 2.5931, 2.8933,
		  3.1905, 3.4852, 3.7778, 4.0686, 4.3579, 4.6458, 4.9325, 5.2182 ],
		[ 1.4406, 1.8309, 2.1967, 2.5474, 2.8877, 3.2201, 3.5465, 3.8681,
		  4.1855, 4.4996, 4.8108, 5.1194, 5.4258, 5.7301, 6.0328, 6.3338 ],
		[ 2.2585, 2.6551, 3.0326, 3.3967, 3.7509, 4.0974, 4.4377, 4.7727,
		  5.1033, 5.4302, 5.7538, 6.0745, 6.3927, 6.7085, 7.0223, 7.3342 ],
		[ 3.0774, 3.4772, 3.8615, 4.234, 4.5974, 4.9534, 5.3033, 5.648,
		  5.9882, 6.3246, 6.6575, 6.9873, 7.3144, 7.6391, 7.9615, 8.2818 ],
		[ 3.8967, 4.2985, 4.6872, 5.0655, 5.4354, 5.7984, 6.1555, 6.5075,
          6.8551, 7.1988, 7.539, 7.8761, 8.2104, 8.5422, 8.8716, 9.1988 ],
		[ 4.7162, 5.1194, 5.5111, 5.8936, 6.2685, 6.6368, 6.9995, 7.3573,
		  7.7108, 8.0605, 8.4067, 8.7497, 9.0899, 9.4276, 9.7628, 10.0958 ],
		[ 5.5358, 5.9399, 6.334, 6.7198, 7.0984, 7.471, 7.8382, 8.2007,
		  8.5591, 8.9136, 9.2648, 9.6128, 9.9581, 10.3007, 10.6409, 10.9789 ],
		[ 6.3555, 6.7603, 7.1562, 7.5445, 7.9262, 8.3022, 8.6732, 9.0396,
          9.402, 9.7607, 10.1161, 10.4684, 10.8179, 11.1649, 11.5094, 11.8517 ],
		[ 7.1753, 7.5807, 7.978, 8.3683, 8.7525, 9.1314, 9.5054, 9.8752,
		  10.241, 10.6033, 10.9623, 11.3183, 11.6715, 12.0222, 12.3706, 12.7167 ],
		[ 7.995, 8.4009, 8.7993, 9.1914, 9.5777, 9.959, 10.3357, 10.7082,
          11.077, 11.4424, 11.8046, 12.1638, 12.5203, 12.8744, 13.226, 13.5755 ],
		[ 8.8148, 9.221, 9.6205, 10.0139, 10.4021, 10.7854, 11.1643, 11.5394,
          11.9107, 12.2788, 12.6438, 13.0059, 13.3653, 13.7223, 14.0769, 14.4294 ],
		[ 9.6346, 10.0412, 10.4414, 10.8361, 11.2257, 11.6108, 11.9918, 12.3689,
		  12.7426, 13.113, 13.4805, 13.8451, 14.2072, 14.5668, 14.9241, 15.2793 ],
		[ 10.4545, 10.8612, 11.2622, 11.6579, 12.0489, 12.4356, 12.8183, 13.1973,
		  13.573, 13.9455, 14.3152, 14.6821, 15.0465, 15.4085, 15.7683, 16.1259 ],
		[ 11.2743, 11.6813, 12.0829, 12.4795, 12.8716, 13.2597, 13.6439, 14.0246,
		  14.4021, 14.7766, 15.1482, 15.5172, 15.8837, 16.2479, 16.6099, 16.9697 ],
		[ 12.0941, 12.5013, 12.9034, 13.3009, 13.694, 14.0833, 14.4689, 14.8512,
		  15.2303, 15.6064, 15.9799, 16.3507, 16.7192, 17.0853, 17.4493, 17.8112 ],
		[ 12.914, 13.3214, 13.7239, 14.1221, 14.5162, 14.9065, 15.2933, 15.677,
		  16.0575, 16.4353, 16.8103, 17.1829, 17.5531, 17.921, 18.2869, 18.6507 ],
	];

	// Amplitudes corresponding to nodes that look like slices
	ampRowArray = Array.fill(16, {
		arg i;
		if (i == 0)
			{ thumpAmp }
			{
			    (
				    ((3pi).pow(2) - (24pi * i * sin((pi/2)/i))) *
		            (
			        	((4 * i) * sin((pi/2)/i)).pow(2)/(3 * pi) -
		                ((4 * i) * sin((pi/2)/i))
		            ).pow(-2)
	            ) *
		        (
			        position.pow(3) - position +
			        (
			        	(position - position.pow(2)) *
					    ((16/3 * (i * sin((pi/2)/i)).pow(2)) - pi.pow(2))/
					    ((8pi/3 * i * sin((pi/2)/i)) - pi.pow(2))
			        )
		        )
		    }
	});

	// Amplitudes corresponding to nodes that have rings
	ampArray = Array.fill2D(16, 16, {
		arg i, j;
		(if (freqArray[i][j] > 20000)
	    	{ 0 }
		    {
				cos(position * ((i * pi) + pi/2)) * ampRowArray[j]
		    }
		)
	});

	// Decay times
	decArray = Array.fill2D(16, 16, {
		arg i, j;
		(
			if (j == 0)
		        { thumpDec }
		        { 1 }
		) *
		exp(-1 * (i + j) * decCoef)
	});

	// Exciter
	exciter = Env.perc(
		attackTime: att,
		releaseTime: dec,
		level: 0.05,
		curve: crv).ar;
	exciter = XFade2.ar(
		inA: exciter,
		inB: BrownNoise.ar(exciter),
		pan: exBlend);

	// Bank of resonators
	snd = Array.fill(16, {
		arg i;
			Klank.ar(
		        specificationsArrayRef:
		    	    Ref.new([freqArray[i], ampArray[i], decArray[i]]),
		        input: exciter,
		        freqscale: freq,
		        decayscale: rel
	        )
	});

	// Output stuff
	snd = Mix.ar(snd) * amp;
	snd = Limiter.ar(snd);

	DetectSilence.ar(in: snd, amp: 0.00025, doneAction: 2);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "by Josh Mitchell",
	category: \percussion,
	tags: [\unpitched, \modal]
)
).add;


// Marimba

/*
This SynthDef uses BPF in a manner similar to DynKlank.
BPF gets hit with an impulse (Saw.ar(0)), and outputs a sine wave
with a sharp attack, and a decay and amplitude both determined by rq.

Modified by Bruno Ruviaro and Josh Mitchell July 2019 and June 2020.
*/

SynthDef(\marimba1, {
	arg
	// Standard values
	freq = 440, out = 0, amp = 0.4, pan = 0, rq = 0.02,
        // Controls for BLowShelf
	shelffreq = 220, rs = 0.81, shelfamp = 2;

	var snd;

	snd = BPF.ar(
		in: Saw.ar(0),
		freq: freq,
		rq: rq);

	snd = BLowShelf.ar(
		in: snd,
		freq: shelffreq,
		rs: rs,
		db: shelfamp.ampdb);

	snd = Limiter.ar(snd) * amp;

	DetectSilence.ar(in: snd, doneAction: 2);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "unknown",
	category: \percussion,
	tags: [\percussion, \marimba, \pitched, \keyboard]
)
).add;


);

// metalPlate

/*
This SynthDef is a modal model for a rectangular plate held fixed at all edges,
or "clamped." I think it sounds very metallic in general, so it'd probably make
a nice strange cymbal.

The timbre of the plate is mostly determined by ratio and decCoef. A higher value
for decCoef makes the decay times of longer notes shorter, so you don't hear them
as well beyond the initial attack of the note. Meanwhile, ratio controlls the
relative shape of the rectangular plate, from narrow near 0 to square at 1. It's
called ratio because it's the ratio of the short side to the long one. Values of
ratio greater than 1 are probably okay, but they could be very out of tune or have
mangled low notes. Changing ratio from note to note gives an FM-like effect.

Where on the plate it's hit is determined by xpos and ypos, using the same 1d
"position" argument in two different dimensions. As far as I can tell, xpos is
along the short side and ypos is along the long side.

Finally, I added thumpDec to control the decay time of a harmonic we percieve to
be below the fundamental "pitch" of the plate, for a bit of controllable
percussive emphasis. Finally, there's a cheaply done filter with a roughly
constant, positive db/oct slope to emphasise higher harmonics a bit more, which
helps highlight some of the metallic parts of the SynthDef.

By Josh Mitchell August 2020.
*/

SynthDef(\metalPlate, {
	arg
	// Standard values
	out = 0, freq = 3000, amp = 0.5, rel = 2, pan = 0, crv = 0,
	// Other controls (ratio goes from >0 to 1)
	ratio = 1, decCoef = 0.31, xpos = 0.5, ypos = 0.5, thumpDec = 0.75;

	var exciter, freqArray, ampArray, decArray, snd;

	// Frequencies
	freqArray = Array.fill2D(16, 16, {
		arg i, j;
		(i + 1).pow(2) + (ratio * (j + 1)).pow(2)
	});
	freqArray = freqArray/(freqArray[0][1]);
	freqArray = freqArray * freq;

	// Amplitudes
	ampArray = Array.fill2D(16, 16, {
		arg i, j;
		((1 - ((freqArray[i][j] - 19000)/1000).tanh)/2) *
		sin(((i + 1) * pi) * xpos) *
		sin(((j + 1) * pi) * ypos)
	});

	// Decay Times
	decArray = Array.fill2D(16, 16, {
		arg i, j;
		(
			if (j == 0)
		        { thumpDec }
		        { 1 }
		) *
		exp(-1 * (i + j) * decCoef)
	});

	// Hit the plate
	exciter = Impulse.ar(0);

	// The Plate
	snd = Klank.ar(
		specificationsArrayRef:
		    Ref.new([freqArray.flatten, ampArray.flatten, decArray.flatten]),
		input: exciter,
		decayscale: rel);

	// Output Stuff
	snd = HPF.ar(
		in: snd,
		freq: [freq, freq * 2, freq * 4, freq * 8, freq * 16, freq * 32, freq * 64]);
	snd = Mix.ar(snd/7) * amp;
	snd = Limiter.ar(snd);

	DetectSilence.ar(in: snd, doneAction: 2);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "by Josh Mitchell",
	category: \percussion,
	tags: [\pitched, \modal]
)
).add;


// modalmarimba

/*
The work here is done through modal synthesis. The focus with modal synthesis is that any
object will vibrate at certain frequencies (modes), with certain amplitudes, and certain
decay times in a case where there's a damping force, for each of these modes. Here most of
the math for those modes is done in arrays, then plugged into Klank, along with a short
burst meant to simulate the object being hit.

The title of this synthdef says it's a marimba, but it can also be used to simulate a lot
of other idiophones, because it works on a very abstract model. Essentially, the harmonics
of the SynthDef have been determined by the harmonics of a vibrating beam (say, a long
rectangular prism), when it's hit by something. I find some of the math shortcuts pretty
funny; this particular beam is totally ignoring gravity, for example.

The decay coefficient (decCoef) does a lot to determine the timbre, position simulates
the position on the beam in which it's hit (0.5 is the middle), and slope is the db/oct
slope of a filter with a constant slope across the audio range.

The solutions to the dynamic beam equation (look up Euler-Bernoulli beam theory if you're
interested) were given by Nathan Ho, as well as some of the methods I used for amparray.

By Josh Mitchell June 2020.
*/

SynthDef(\modalMarimba, {
	arg
	// Standard values
	out = 0, freq = 440, amp = 0.1, att = 0.001, dec = 0.1, rel = 0.5, pan = 0,
	// Other controls, position goes from 0 to 1
	decCoef = 2, position = 0.414, ampSlope = 3;

	var freqarray, amparray, decarray, mallet, snd;

	// Array of frequencies, determined by solutions to the dynamic beam equation
	freqarray = Array.fill(30, { arg i; i + 1.5});
        freqarray[0] = 1.50561873;
	    freqarray[1] = 2.49975267;
	    freqarray = freqarray/1.50561873; // Normalize to freqarray[0] = 1

	// Array of amplitudes
	amparray = Array.fill(30, { arg i;
		if (freqarray[i] > 20000)
		    { 0 }
		    {
		        sin(((i + 1) * pi) * position) *
		        (ampSlope * (freqarray[i]).log2).dbamp
		    }
	});

	// Array of Decay times
	decarray = Array.fill(30, { arg i;
		exp(-1 * i * decCoef)
	}); // The decay times are dropping off exponentially

	// Hit the object
	mallet = Decay2.ar(
		in: Impulse.ar(0),
		attackTime: att,
		decayTime: dec,
		mul: 0.1);

	// Bank of resonators
	snd = Klank.ar(
		specificationsArrayRef: Ref.new([freqarray, amparray, decarray]),
		input: mallet,
		freqscale: freq,
		decayscale: rel);

	// Output stuff
	snd = Mix.ar(snd) * amp;
	snd = Limiter.ar(snd);

	DetectSilence.ar(in: snd, doneAction: 2);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "by Josh Mitchell",
	category: \percussion,
	tags: [\pitched, \modal]
)).add;

// crotales


/*
Author Unknown

Modified by Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef("pmCrotales", {
	arg out = 0, freq = 261, tone = 3, att = 0, rel = 2, curve = -6, amp = 0.8, pan = 0, modLo = 5.25, modHi = 5.5;

	var env, snd, mod;

	env = Env.perc(attackTime: 0, releaseTime: rel, curve: curve).kr(doneAction: 2);

	mod = Rand(modLo, modHi);

	snd = PMOsc.ar(
	    	carfreq: freq,
	    	modfreq: mod * freq,
	    	pmindex: env * tone,
	    	mul: env * amp
	    );

	snd = HPF.ar(snd, freq / 2);

	snd = Mix.ar(snd) * 0.1;

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Author Unknown",
	category: \percussion,
	tags: [\pitched, \bell]
	)
).add;

//////////////////////// FX /////////////////////////////////////


SynthDef(\fx, {
    var sig, fb;
    sig = In.ar(\out.kr(0),2);
    [0.2,0.3,0.35].do{ |windowSize|

        sig = sig + PitchShift.ar(sig * ToggleFF.ar(Dust.ar(4))* -123.dbamp, windowSize, 2);
    };

    sig = sig + LocalIn.ar(2);
    fb = sig;
    fb = DelayC.ar(fb, 3.0, [2.0,3.0]);
    fb = LPF.ar(fb, 3000);
    fb = HPF.ar(fb, 100);
    fb = fb* -2.dbamp;
    fb = Limiter.ar(fb);
    LocalOut.ar(fb);
    sig = LeakDC.ar(sig);
    sig = Limiter.ar(sig);
    ReplaceOut.ar(\out.kr(0), sig)
}).add;

SynthDef(\setPerc2,
    {arg out = 0, buf = 0, amp = 0.5, pan = 0, rel=15, dur = 8;
        var sig,env ;
        sig = Mix.ar(PlayBuf.ar(2,buf,\rate.ir(1),1,0,loop:0,doneAction:2));
        env = EnvGen.ar(Env.linen(0.0,rel,0),doneAction:2);
        sig = sig * env;
        sig = sig * amp;
        Out.ar(out,Pan2.ar(sig,pan));
}).add;



///////////// STRINGS


// strings

/* Retrieved from
http://sccode.org/1-5aD

Original from SC Examples Folder some small pieces, Julian Rohrhuber, 2007

Modified by Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef(\strings, {
	arg
	//Standard Definitions
	out = 0, freq = 440, amp = 1, gate = 1, pan = 0, freqLag = 0.2, att = 0.001, dec = 0.1, sus = 0.75, rel = 0.3,
	//Other Controls (mix ranges from 0 - 1)
	rq = 0.001, combHarmonic = 4, sawHarmonic = 1.5, mix = 0.33;

	var env, snd, combFreq;

	combFreq = 1 / (Lag.kr(in: freq, lagTime: freqLag / 2) * combHarmonic);

	env = Env.adsr(att, dec, sus, rel, amp).kr(gate: gate, doneAction: 2);

	snd = SyncSaw.ar(syncFreq: freq * WhiteNoise.kr().range(1/1.025, 1.025), sawFreq: freq * sawHarmonic, mul: 8);
	snd = (snd * (1 - mix)) + PinkNoise.ar(180 * mix);
	snd = CombL.ar(snd, combFreq, combFreq, -1); //Try positive 1 for decay time as well.
	snd = Resonz.ar(snd, Lag.kr(in: freq, lagTime: freqLag), rq).abs;
	snd = snd * env;
	snd = Limiter.ar(snd, amp);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Original from Julian Rohrhuber, 2007",
	category: \strings,
	tags: [\pitched]
	)
).add;

// violin


/* Retrieved from
http://sccode.org/1-5aD

by nicolaariutti
http://sccode.org/1-5as

Modifications from the original include:

-Added Vibrato.ar, to better simulate left hand movement alongside the pre-existing pwm.
-Changed ASR envelope to ADSR and "scratch" envelopes, to simulate the attack of a bow.
-Added filters, to simulate tone brightening from the bridge and back of the instrument.

Modified by Bruno Ruviaro and Josh Mitchell 8/19.
*/

SynthDef(\violin, {
	arg
	//Standard Definitions
	freq = 440, gate = 1, amp = 1, pan = 0, out = 0, att = 0.1, dec = 0.1, sus = 0.5, rel = 0.1,
	//Vibrato Controls
	vRate = 4.6, vDepth = 0.02, vAtt = 0.15, vRateVar = 0.25, vDepthVar = 0.05,
	//PWM Controls (pwmMax and pwmMin are 0 - 1)
	pwmVarRate = 2, pwmMin = 0.7, pwmMax = 0.8, pwmRate = 5,
	//Other Controls
	bridgeFreq = 2500, scratchDepth = 0.15;

	var scratch, env, pwm, snd;

	scratch = 1.015 + Env.perc(att, dec * 1.25, scratchDepth).kr;

	env = Env.adsr(att, dec, sus, rel).kr(gate: gate, doneAction: 2);

	freq = Vibrato.kr(
		            freq: freq,
		            rate: vRate,
		            depth: vDepth,
	            	delay: (att + dec),
		            onset: vAtt,
		            rateVariation: vRateVar,
		            depthVariation: vDepthVar
            	);

	pwm = SinOsc.kr(freq: pwmRate, phase: Rand(0.0, 1.0)).range(pwmMin, pwmMax);
	pwm = pwm * LFNoise2.kr(pwmVarRate).range(0.2, 0.8);

	snd = VarSaw.ar(
		freq: Lag.kr(freq) * LFPulse.ar(freq * 1.5).range(1/scratch, scratch),
		width: pwm,
		mul: amp
	);

	snd = (snd * 0.7) + BPF.ar(snd, bridgeFreq, 2, 2);
	snd = snd + HPF.ar(snd, bridgeFreq * 2);
	snd = snd * env;
	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Original by nicolaariutti, modified by Josh Mitchell",
	category: \strings,
	tags: [\bowed, \pitched, \violin]
	)
).add;

////////// WINDS


// Originally found at http://ecmc.rochester.edu/ecmc/docs/supercollider/scbook/Ch21_Interface_Investigations/ixi%20SC%20tutorial/ixi_SC_tutorial_10.html

// waveguideFlute

SynthDef("waveguideFlute", { arg scl = 0.2, freq = 440, ipress = 0.9, ibreath = 0.09, ifeedbk1 = 0.4, ifeedbk2 = 0.4, dur = 1, gate = 1, amp = 2;

	var kenv1, kenv2, kenvibr, kvibr, sr, cr, block;
	var poly, signalOut, ifqc;
	var aflow1, asum1, asum2, afqc, atemp1, ax, apoly, asum3, avalue, atemp2, aflute1;
	var fdbckArray;

	sr = SampleRate.ir;
	cr = ControlRate.ir;
	block = cr.reciprocal;

	ifqc = freq;

	// noise envelope
	kenv1 = EnvGen.kr(Env.new(
		[ 0.0, 1.1 * ipress, ipress, ipress, 0.0 ], [ 0.06, 0.2, dur - 0.46, 0.2 ], 'linear' )
	);
	// overall envelope
	kenv2 = EnvGen.kr(Env.new(
		[ 0.0, amp, amp, 0.0 ], [ 0.1, dur - 0.02, 0.1 ], 'linear' ), doneAction: 2
	);
	// vibrato envelope
	kenvibr = EnvGen.kr(Env.new( [ 0.0, 0.0, 1, 1, 0.0 ], [ 0.5, 0.5, dur - 1.5, 0.5 ], 'linear') );

	// create air flow and vibrato
	aflow1 = LFClipNoise.ar( sr, kenv1 );
	kvibr = SinOsc.ar( 5, 0, 0.1 * kenvibr );

	asum1 = ( ibreath * aflow1 ) + kenv1 + kvibr;
	afqc = ifqc.reciprocal - ( asum1/20000 ) - ( 9/sr ) + ( ifqc/12000000 ) - block;

	fdbckArray = LocalIn.ar( 1 );

	aflute1 = fdbckArray;
	asum2 = asum1 + ( aflute1 * ifeedbk1 );

	//ax = DelayL.ar( asum2, ifqc.reciprocal * 0.5, afqc * 0.5 );
	ax = DelayC.ar( asum2, ifqc.reciprocal - block * 0.5, afqc * 0.5 - ( asum1/ifqc/cr ) + 0.001 );

	apoly = ax - ( ax.cubed );
	asum3 = apoly + ( aflute1 * ifeedbk2 );
	avalue = LPF.ar( asum3, 2000 );

	aflute1 = DelayC.ar( avalue, ifqc.reciprocal - block, afqc );

	fdbckArray = [ aflute1 ];

	LocalOut.ar( fdbckArray );

	signalOut = avalue;

	OffsetOut.ar( 0, [ signalOut * kenv2, signalOut * kenv2 ] );

}).add;


///////// GUITARS


// pluck

// Originally found at http://ecmc.rochester.edu/ecmc/docs/supercollider/scbook/Ch21_Interface_Investigations/ixi%20SC%20tutorial/ixi_SC_tutorial_10.html

SynthDef("waveguideFlute", { arg scl = 0.2, freq = 440, ipress = 0.9, ibreath = 0.09, ifeedbk1 = 0.4, ifeedbk2 = 0.4, dur = 1, gate = 1, amp = 2;

	var kenv1, kenv2, kenvibr, kvibr, sr, cr, block;
	var poly, signalOut, ifqc;
	var aflow1, asum1, asum2, afqc, atemp1, ax, apoly, asum3, avalue, atemp2, aflute1;
	var fdbckArray;

	sr = SampleRate.ir;
	cr = ControlRate.ir;
	block = cr.reciprocal;

	ifqc = freq;

	// noise envelope
	kenv1 = EnvGen.kr(Env.new(
		[ 0.0, 1.1 * ipress, ipress, ipress, 0.0 ], [ 0.06, 0.2, dur - 0.46, 0.2 ], 'linear' )
	);
	// overall envelope
	kenv2 = EnvGen.kr(Env.new(
		[ 0.0, amp, amp, 0.0 ], [ 0.1, dur - 0.02, 0.1 ], 'linear' ), doneAction: 2
	);
	// vibrato envelope
	kenvibr = EnvGen.kr(Env.new( [ 0.0, 0.0, 1, 1, 0.0 ], [ 0.5, 0.5, dur - 1.5, 0.5 ], 'linear') );

	// create air flow and vibrato
	aflow1 = LFClipNoise.ar( sr, kenv1 );
	kvibr = SinOsc.ar( 5, 0, 0.1 * kenvibr );

	asum1 = ( ibreath * aflow1 ) + kenv1 + kvibr;
	afqc = ifqc.reciprocal - ( asum1/20000 ) - ( 9/sr ) + ( ifqc/12000000 ) - block;

	fdbckArray = LocalIn.ar( 1 );

	aflute1 = fdbckArray;
	asum2 = asum1 + ( aflute1 * ifeedbk1 );

	//ax = DelayL.ar( asum2, ifqc.reciprocal * 0.5, afqc * 0.5 );
	ax = DelayC.ar( asum2, ifqc.reciprocal - block * 0.5, afqc * 0.5 - ( asum1/ifqc/cr ) + 0.001 );

	apoly = ax - ( ax.cubed );
	asum3 = apoly + ( aflute1 * ifeedbk2 );
	avalue = LPF.ar( asum3, 2000 );

	aflute1 = DelayC.ar( avalue, ifqc.reciprocal - block, afqc );

	fdbckArray = [ aflute1 ];

	LocalOut.ar( fdbckArray );

	signalOut = avalue;

	OffsetOut.ar( 0, [ signalOut * kenv2, signalOut * kenv2 ] );

}).add;



// modalElectricGuitar

/*
This SynthDef is especially cool to me, because working on effects for guitars is what ended
up getting me into supercollider in the first place, and now in a continuation of that weird
chain of events, I've come full circle to making a clean guitar sound in supercollider!

This model can be broken into separate sections based on the parts of an electric guitar: It
starts with a plucked string made using modal synthesis, and that goes into a single pickup.
The pickup's position is modeled in the modal synthesis portion, and the electronic components
of the pickup (as well as the volume and tone controls) are modeled afterwards with filters.

The frequencies of each mode on the vibrating guitar string are determined by a standard stiff
string model in freqArray, where 0.00001 is a constant stretching these frequencies a tiny bit
from the harmonic series. Similarly, the decay times of each mode are found by decArray, where
decayCoef and dampCoef (which is best left low) control the apparent brightness of each note.

In ampArray, the first line works like an anti-aliasing filter, and the second line models the
string being plucked at different locations, from the bridge at pickPos = 0 to the nut at
pickPos = 1. Everything else inside ampArray, as well as the line after it, model a pickup
with a certain width (parallel to the string) and position, once again from the brigde at
pickupPos = 0 to the nut at pickupPos = 1. The pickup width is not, however, a ratio from 0 to
1, but pickupWidth is instead measured in inches. This gets turned into a ratio by dividing it
by the scale length of the guitar, which I set to 25.5 inches. This isn't a variable control
because the main effects it has on a real guitar are on the ratios for each of the parameters
I just mentioned, making it redundant to control. Lastly, the open frequency of a string (the
note it's tuned to, as in e-a-d-g-b-e) has some effect when it interacts with the position of
the pickup. Looking at the demo, you'll see I used that to write in what string a note is
being played on.

After all the complicated modal stuff, it's kind of interesting that the circuitry of a guitar
from the pickups to any passive controls to a cable and output load can all be modeled pretty
well with a resonant low pass filter. Rather than figure out a bunch of variables for the
number of turns in the pickup windings, the pickup's capacitance, and everything else inside a
guitar, all you get are the filter's resonant frequency and rq. There's another low pass filter
for you that I labeled tone after a guitar control. I set it a bit lower than the resonant
filter to roughly match an experimentally-determined filter curve I found.

After that is a quick way of approximating muting a vibrating string with one hand. You can
control when that happens with muteSus. If it's longer than rel, you'll let the string ring
out. You'll see in the demo that I mute a string just before playing a new note on it, which
helps with the realism, just like waving pickPos around slightly. What helps the most, however,
is starting the demo with an add9 chord, as every guitar demo should start.

By Josh Mitchell August 2020.
*/

SynthDef(\modalElectricGuitar, {
	arg
	// Standard values
	out = 0, pan = 0, freq = 440, amp = 0.3, rel = 5,
	// String controls (pickPos goes from 0 to 1)
	decayCoef = 0.125, dampCoef = 0.0002, pickPos = 0.414, openFreq = 82.5, muteSus = 5.5,
	// Pickup Controls (pickupPos goes from 0 to 1)
	pickupPos = 0.17, pickupWidth = 0.75, resFreq = 4000, rq = 0.5, toneFreq = 3250;

	var exciter, freqArray, ampArray, decArray, constant, mute, snd;

	// Make a Constant from pickupWidth for ampArray
	constant = pickupWidth/25.5; // The scale length is set to 25.5 inches
	constant = constant * pi/2;
	constant = constant/openFreq;

	// Stiff String Model for Frequencies
	freqArray = Array.fill(50, {
		arg i;
		(i + 1) * sqrt(1 + ((i + 1).pow(2) * 0.00001))
	});
	freqArray = freqArray/freqArray[0];

	// Decay Times
	decArray = Array.fill(50, {
		arg i;
		exp(
			(-1 * i)/
			(
				(1/decayCoef) +
				((dampCoef/10) * freq.pow(2)) +
				(dampCoef * freqArray[i].pow(2))
		    )
		)
	});
	decArray = decArray/decArray[0];

	// Rescale freqArray for ampArray and Klank
	freqArray = freqArray * freq;

	// Effects of Pick Position and Pickup Placement
	ampArray = Array.fill(50, {
		arg i;
		((1 - ((freqArray[i] - 19000)/1000).tanh)/2) *
		sin(((i + 1) * pi) * pickPos) *
		(
			sin(pi * pickupPos * freqArray[i]/openFreq) *
			(
			    (
					sin(constant * freqArray[i])/
					(constant * freqArray[i])
				) - cos(constant * freqArray[i])
			)
		)/(freqArray[i].pow(2))
	});
	ampArray = ampArray * 2/(constant.pow(2));

	// The Pick
	exciter = Impulse.ar(0) * 0.1;

	// The String
	snd = Klank.ar(
		specificationsArrayRef:
		    Ref.new([freqArray, ampArray, decArray]),
		input: exciter,
		decayscale: rel
	);

	snd = Mix.ar(snd);

	// The Pickup
	snd = RLPF.ar(
		in: snd,
		freq: resFreq,
		rq: rq);

	snd = LPF.ar(
		in: snd,
		freq: toneFreq);

	// An Envelope for Muting the String
	mute = Env.new(
		levels: [1, 1, 0, 0],
		times: [muteSus, 0.05, 0.01]).ar(doneAction: 2);

	// Mute the String
	snd = LPF.ar(
		in: snd,
		freq: LinExp.ar(
			in: mute,
			srclo: 0, srchi: 1,
			dstlo: 20, dsthi: 20000));

	// Output Stuff
	snd = snd * amp;
	snd = Limiter.ar(snd);

	DetectSilence.ar(in: snd, doneAction: 2);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "by Josh Mitchell",
	category: \guitar,
	tags: [\pitched, \modal]
)
).add;


// distiorted guitar

/*
This is an attempt at making an electric guitar sound using Pluck.ar, as well as a couple
delay-based comb filters which roughly simulate some of the effects of changing pickup
placement and where on the string it's plucked. It still sounds a lot like Pluck and not
very much like a guitar, so I stuck some distortion on it to hide my mistakes a bit. That's
how guitar pedals work, right? (jk I think effects pedals are instruments in their own right)

Starting with the pick, I used Hasher.ar to provide the same initial noise for each pick,
but replacing that line with WhiteNoise.ar works fine. This then goes through the first
comb filter, which mutes certain frequencies based on pickPos. This is the pick position
from the bridge at 0 to the fret of the note being played at 1.

Next up is Pluck.ar, which makes the string sound, as well as a way of "muting" that string.
This is just a simple sustain-release envelope with a user-determined sustain time and a very
short release time, controlling a low pass filter for a slightly more natural-sounding cutoff.
I found it helpful in the demo, because two notes can't be played on the same string at once.
Setting a note to mute just before the next on plays seems convincing enough.

After this comes the pickup section. This guitar has only one pickup, and you can add more
if you like. First is another comb filter to mimic how pickup placement cuts some frequencies
and emphasizes others. Instead of pickupPos going from the bridge at 0 to the fretted note at
1, it goes to the nut of the guitar at 1, meaning openStringFreq plays a very small role in
the timbre of a note. Next is a resonant HPF and a steeper resonant LPF to mimic the frequency
response of a generalized pickup.

Finally, there's the distortion I mentioned above. It's got an HPF before the distortion and
an LPF after it, as is generally common in a lot of guitar distortion pedals.

By Josh Mitchell August 2020
*/

SynthDef(\distortedGuitar, {
	arg
	//Standard Values
	out = 0, pan = 0, amp = 0.1, freq = 220, rel = 4, crv = -3,
	// String and Plucking Hand Controls
	coef = 0.75, openStringFreq = 110, pickPos = 0.5, muteSus = 0.5,
	// Pickup Controls
	pickupPos = 0.17, pickupResfreq = 8000, pickupResrq = 0.5, pickupHPF = 250, pickupHPFrq = 0.8,
	// Distortion Controls
	preDistHPF = 600, postDistLPF = 2000, gain = 75;

	var mute, snd;

	// The Pick
	snd = Hasher.ar(Sweep.ar(Impulse.ar(0)));
	snd = snd - DelayN.ar(
		in: snd,
		maxdelaytime: pickPos.clip(0, 1)/freq,
		delaytime: pickPos.clip(0, 1)/freq);

	// The String
	snd = Pluck.ar(
		in: snd,
		trig: Impulse.ar(0),
		maxdelaytime: 1/freq,
		delaytime: 1/freq,
		decaytime: rel,
		coef: coef.clip(-1, 1));
	snd = LeakDC.ar(snd);

	// An Envelope for Muting the String
	mute = Env.new(
		levels: [1, 1, 0, 0],
		times: [muteSus, 0.075, 0.025]).ar(doneAction: 2);

	// Mute the String
	snd = snd * mute;
	snd = HPF.ar(
		in: snd,
		freq: LinExp.ar(
			in: mute,
			srclo: 0, srchi: 1,
			dstlo: 100, dsthi: 20));
	snd = LPF.ar(
		in: snd,
		freq: LinExp.ar(
			in: mute,
			srclo: 0, srchi: 1,
			dstlo: 20, dsthi: 10000));

	// The Pickup
	snd = snd - DelayN.ar(
		in: snd,
		maxdelaytime: pickupPos.clip(0, 1)/openStringFreq,
		delaytime: pickupPos.clip(0, 1)/openStringFreq);
	snd = RHPF.ar(
		in: snd,
		freq: pickupHPF,
		rq: pickupHPFrq);
	snd = BLowPass4.ar(
		in: snd,
		freq: pickupResfreq,
		rq: pickupResrq);

	snd = LeakDC.ar(snd);

	// The Distortion
	snd = HPF.ar(
		in: snd,
		freq: preDistHPF);
	snd = snd * gain;
	snd = snd.tanh;
	snd = LPF.ar(
		in: snd,
		freq: postDistLPF);

	// Output Stuff
	snd = snd * amp;
	snd = Limiter.ar(snd);

	DetectSilence.ar(in: snd, doneAction: 2);

	Out.ar(out, Pan2.ar(snd, pan));
},
metadata: (
	credit: "Josh Mitchell",
	category: \guitar,
	tags: [\pitched]
	)
).add;


//  SIMPLE SYNTHDEF

// simpleSin

SynthDef(\simpleSin, {
	var sig, env;

	env = Env.perc(\atk.ir(0.05),\rel.ir(1),\level.ir(1), \curve.ir(-4)).ar(2);
	sig = SinOsc.ar(\freq.ir(220),\phase.ir(0),\amp.ir(1));

	sig = sig *env;
	sig = Pan2.ar(sig, \pos.ir(0));

	Out.ar(\out.kr(0), sig);
}).add;

// simpleSaw

SynthDef(\simpleSaw, {
	var sig, env;

	env = Env.perc(\atk.ir(0.05),\rel.ir(1),\level.ir(1), \curve.ir(-4)).ar(2);
	sig = Saw.ar(\freq.ir(220),\amp.ir(1));

	sig = sig *env;
	sig = Pan2.ar(sig,\pos.ir(0));

	Out.ar(\out.kr(0), sig);
}).add;

// simpleLftri

SynthDef(\simpleLftri, {
	var sig, env;

	env = Env.perc(\atk.ir(0.05),\rel.ir(1),\level.ir(1), \curve.ir(-4)).ar(2);
	sig = LFTri.ar(\freq.ir(220),\iphase.ir(0),\amp.ir(1));

	sig = sig *env;
	sig = Pan2.ar(sig, \pos.ir(0));

	Out.ar(\out.kr(0), sig);
}).add;


// simplePulse

SynthDef(\simplePulse, {
	var sig, env;

	env = Env.perc(\atk.ir(0.05),\rel.ir(1),\level.ir(1), \curve.ir(-4)).ar(2);
	sig = RLPF.ar(Pulse.ar([100,250],0.5,0.1), XLine.kr(8000,400,5), 0.05);

	sig = sig *env;
	sig = Pan2.ar(sig, \pos.ir(0));

	Out.ar(\out.kr(0), sig);

}).add;





