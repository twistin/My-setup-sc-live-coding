("../Setup/Setup.scd").loadRelative;


~a.play; ~a.awake_(false);
~a = { Pan2.ar(PlayBuf.ar(1, d["china"][1], \rate.ir(1), 1, \spos.ir(0),0, 0),\pos.ir(0),\level.ir(1))* Env.linen(\atk.ir(0.08), \sus.ir(1), \rel.ir(0.5)).ar(2)};


~b.play; ~b.awake_(false);
~b =  {RLPF.ar(Mix(LFSaw.ar([120, 180],\iphase.ir(0), 0.2)), LinExp.kr(LFCub.kr(0.1,0,\amp.ir(0.2) ),-1, \srchi.ir( 1), \dstlo.ir(280), \dsthi.ir(1500)), 0.2).dup * Env.perc(0.06,0.3).ar(2)};

~c.play; ~c.awake_(false);
~c = { Pan2.ar(Crackle.ar(Line.kr(\start.ir(1), \end.ir(2), \dur.ir(3)), \chaosP.ir(1.0),\end.ir(2.0))*0.6* Env.perc(\atk.ir(0.01), \rel.ir(0.5),0.5, -2).ar(2)) };
~c.spawn

(
~seq1 = Tdef(\seq1, {
	loop{
	~a.spawn([\rate,0.5, \spos, 0.8, \atk, 0.06]);
	0.5.wait;
	~b.spawn([\srchi,0.5, \iphase, pi, \dsthi, [2000,1000].choose]);
	0.75.wait;
	~c.spawn([\chaosP,[2,1].choose]);
	1.wait
}});
)

Tdef(\seq1).play(t)

~off = Tdef(\off,{
	4.wait;
	~seq1.pause;
	2.wait;
	~seq1.resume;
	4.wait;
	~seq1.pause;


})