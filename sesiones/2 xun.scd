// tempo
t = p.clock.tempo_(90/60);

t = TempoClock.default.tempo_(90/60); // Ajusta el tempo si es necesario

////////
("../Setup/Setup.scd").loadRelative;




(
{
	arg hz=440,amp=0.5;
	var note=hz.cpsmidi;
	var snd,snd2,intro;

	// these notes are directly from Eno's Music for Airports
	// each phrase is one line, and played through
	var airports=[
		[5,7,4,2,0,12,7,5,7,4,2,0],
		[5,7,4,2,0,12,4,7,5,0],
		[-5,2,0,4,7,12,5,2,7,4,0,7,2,5,5,2,4,0],
		[7,7,2,4,4,4,2,0,7,0,0],
	];
	// these are some chords I made up that sound nice with it
	var planes=[
		[0,4,7,12],
		[4,7,11,16],
		[-3,0,4,7],
		[-3,0,5,9],
	];

	// setup the note change variables
	var seq,seqnote,notepulse,noterate;
	var planeseq,planenotes,planeenv,planenotechange;
	// piano stuff
	var noise, string, delaytime, lpf, noise_env,pianosnd,pianosnd2, damp_mul,pianohz,noise_hz;
	var noise_attack=0.002, noise_decay=0.06,
	tune_up = 1.0005, tune_down = 0.9996, string_decay=6.0,
	lpf_ratio=2.0, lpf_rq = 4.0, hpf_hz = 40, damp=0, damp_time=0.1;

	// chord and note changes (random)
	planenotechange=Dust.kr(1/30)+Impulse.kr(0);
	planeenv=1-EnvGen.kr(Env.perc(3,10,0.9),planenotechange);
	planenotes=Demand.kr(TDelay.kr(planenotechange,3),0,Dxrand(planes,inf));
	notepulse=1;
	noterate=TChoose.kr(Dust.kr(notepulse)+Impulse.kr(0),[0.02,0.05,1,2,0.5,0.25,2]/2)*Rand(0.78,1.32);
	notepulse=Impulse.kr(noterate);
	seq=Demand.kr(Dust.kr(0.1)+Impulse.kr(0),0,Dxrand(airports,inf));
	seqnote=Demand.kr(notepulse,0,Dseq(seq,inf));
	// bass note
	snd=SinOsc.ar((note-24).midicps,mul:SinOsc.kr(Rand(0.001,0.01)).range(0.05,0.15));
	snd=snd+SinOsc.ar((note-12).midicps,mul:SinOsc.kr(Rand(0.001,0.01)).range(0.001,0.05));
	// chords
	snd=snd+(planeenv*Mix.ar(Array.fill(8,{arg i;
		var snd;
		snd=SawDPW.ar((note+planenotes[i%4]+Select.kr(DC.kr(i%4)<1,[24.neg,36.neg])).midicps,mul:0.9);
		snd=LPF.ar(snd,LinExp.kr(SinOsc.kr(rrand(1/30,1/10),rrand(0,2*pi)),-1,1,hz,hz*5));
		snd=DelayC.ar(snd, rrand(0.01,0.03), LFNoise1.kr(Rand(5,10),0.01,0.02)/15 );
		Pan2.ar(snd,VarLag.kr(LFNoise0.kr(1/3),3,warp:\sine))/7
	})));
	snd=MoogLadder.ar(snd.tanh,LinExp.kr(VarLag.kr(LFNoise0.kr(1/6),6,warp:\sine),-1,1,hz*2,hz*60));
	snd=snd+(0.55*DynKlank.ar(`[[(note+planenotes[0]).midicps, (note+planenotes[1]).midicps, (note+planenotes[2]).midicps, (note+planenotes[3]).midicps], nil, [1, 1, 1, 1]], PinkNoise.ar([0.004, 0.004])));

	// piano sound from https://github.com/catfact/zebra/blob/master/lib/Engine_DreadMoon.sc#L20-L41
	noise_hz=VarLag.kr(LFNoise0.kr(1/10),10).range(2000,5000);
	pianohz=A2K.kr((note+seqnote-12).midicps);
	noise_env = Decay2.ar(Impulse.ar(noterate));
	noise = LFNoise2.ar(noise_hz) * noise_env;
	damp_mul = LagUD.ar(K2A.ar(1.0 - damp), 0, damp_time);
	delaytime = 1.0 / (pianohz * [tune_up, tune_down]);
	string = Mix.new(CombL.ar(noise, delaytime, delaytime, string_decay * damp_mul));
	pianosnd = RLPF.ar(string, lpf_ratio * pianohz, lpf_rq) * amp;
	pianosnd = HPF.ar(pianosnd, hpf_hz);

	// polyperc sound
	pianosnd2=(
		EnvGen.ar(Env.perc(release:4),notepulse)*
		MoogFF.ar(Pulse.ar((note+seqnote).midicps,mul:1.0),(note).midicps*1.5)
	);

	// mix between polyperc and piano sound randomly
	snd=snd+SelectX.ar(SinOsc.kr(LFNoise0.kr(0.1).range(0.01,0.1)).range(0.1,0.9),[pianosnd*0.3,pianosnd2]);
	snd=LPF.ar(snd,(note+36).midicps);
	snd=HPF.ar(snd,120);
	snd=snd*EnvGen.ar(Env.new([0,0,1],[0.5,3]));
	snd=FreeVerb.ar(snd,0.45,2.0,0.5);
	snd2=snd;

	// reverb
	snd2 = DelayN.ar(snd2, 0.03, 0.03);
	snd2 = CombN.ar(snd2, 0.1, {Rand(0.01,0.099)}!32, 4);
	snd2 = SplayAz.ar(2, snd2);
	snd2 = LPF.ar(snd2, 1500);
	5.do{snd2 = AllpassN.ar(snd2, 0.1, {Rand(0.01,0.099)}!2, 3)};

	// final output
	Out.ar(0,(snd2*0.1+snd)*amp);
}.play;
)