

// arrancamos el servidor

(
p =  ProxySpace(
	server:s.boot,
	clock: t =TempoClock(90/60).permanent_(true)
).push;

)





// Cargamos los buferes
(
b = ();
Buffer.freeAll;
b.glitch = PathName("../samples/glitch/").entries.collect({|n|
	Buffer.readChannel(s, n.fullPath, channels:[0]);
})
)
b.breaks.play
(
c = ();
Buffer.freeAll;
b.breaks = PathName("..samples/set1/breaks175/").entries.collect({|n|
	Buffer.readChannel(s, n.fullPath, channels:[0]);
})
)




~a.play; ~a.awake;
~a = {}




