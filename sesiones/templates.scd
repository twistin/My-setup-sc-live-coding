Decimator


/////////////////////////////////////////////////
/////////////////////////////////////////////////
/// Plantilla para hacer sesiones Live Coding ////
//////////////////////////////////////////////////
/////////////////////////////////////////////////


/////////// Cargar el setup predifinido de la sesion

("Setup/Setup.scd").loadRelative;

m.noteOn(0,60,64); // chequear que se conecta con Logic
m.noteOff(0,60,64);

///////// Bufferes

(
b = ();
b.voces = PathName("/Users/sdcarr/Desktop/My-setup-sc-live-coding/samples/set1/voces/").entries.collect({|n|
	Buffer.readChannel(s,n.fullPath, channels:[0]);
});
)



///////////   Ritmo  //////////////////








/////////////// pads ////////////////





///////////// melodía ///////////////










