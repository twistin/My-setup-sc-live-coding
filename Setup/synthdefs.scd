    /////// ////// SynthDefs ////// ///////


/// SynthDef creados por Eli Fieldsteel.

// Sintesis Granular


// Audio estereo convertido en mono para la sintesis granular, es mejor leer un sólo canal

b = Buffer.readChannel(s,"/Users/sdcarr/Desktop/samples /set1/etnico/perc1.wav", channels:[0]);
c = Buffer.readChannel(s,"/Users/sdcarr/Desktop/samples /set1/etnico/melodia1.wav",channels:[0]);

(
SynthDef(\grainbuf, {
	var sig, env;

	env = Env([0,1,1,0], [\atk.ir(1),\sus.ir(4),\rel.ir(1)], [1,0,-1]).kr(2);

	sig = GrainBuf.ar(
		numChannels:2,
		trigger:Dust.kr(40), // 40 granos por segundo
		dur:0.1,
		sndbuf:\buf.kr(0),
		rate:BufRateScale.kr(\buf.kr(0)) * \rate.kr(1),
		pos: Line.kr(0,1,BufDur.kr(\buf.kr(0))* \timescale.kr(5)),
		interp:2,
		pan:0,
		envbufnum:-1
	);
	sig = sig * env * \amp.kr(0.5);

	Out.ar(\out.kr(0), sig);

}).add;
)

// calcular duracion de  "~buffers"
d = c.numFrames / c.sampleRate;




(
SynthDef(\tgrains, {
	var sig, env;

	env = Env([0,1,1,0], [\atk.ir(1),\sus.ir(4),\rel.ir(1)], [1,0,-1]).kr(2);

	sig = TGrains.ar(
		numChannels:2,
		trigger:Dust.kr(40), // 40 granos por segundo
		bufnum:\buf.kr(0),
		dur:0.05,
		rate: \rate.kr(1),
		centerPos:\pos.kr(0.5),
		pan:0,
		amp:0.5,
		interp:2
	);
	sig = sig * env * \amp.kr(0.9);

	Out.ar(\out.kr(0), sig);

}).add;
)







///////////////////////////////////

d = Buffer.alloc(s, s.sampleRate * 3);// Crea un buffer vacio

(
SynthDef(\tgrains_live, {
	var sig, env;

	env = Env.asr(\atk.ir(0.1), \sus.ir(1), \rel.ir(1)).kr(2, \gate.kr(1));

	sig = TGrains.ar(
		numChannels:2,
		trigger:Dust.kr(40), // 40 granos por segundo
		bufnum:\buf.kr(0),
		dur:0.05,
		rate: \rate.kr(1),
		centerPos:\pos.kr(0.5),
		pan:0,
		amp:0.5,
		interp:2
	);
	sig = sig * env * \amp.kr(0.9);

	Out.ar(\out.kr(0), sig);

}).add;
)



///////////////////////


(
SynthDef(\tgrains_live, {
	var sig, ptr, env,pos, mic, buf = \buf.kr(0);

	env = Env.asr(\atk.ir(0.1), \sus.ir(1), \rel.ir(1)).kr(2,\gate.kr(1));
	mic = SoundIn.ar(0);
	ptr = Phasor.ar(0,1,0,BufFrames.kr(\buf.kr(0)));
    BufWr.ar(mic, \buf.kr(0), ptr);

	pos = (ptr/SampleRate.ir) - 0.25;
	pos = pos + LFNoise1.kr(100).bipolar(0.2);
	sig = TGrains.ar(
		numChannels:2,
		trigger:Dust.kr(40), // 40 granos por segundo
		bufnum:buf,
		dur:0.05,
		rate: \rate.kr(1),
		centerPos:(ptr/SampleRate.ir)-1,
		pan:0,
		amp:1,
		interp:2
	);
	sig = sig * env * \amp.kr(0.9);

	Out.ar(\out.kr(0), sig);

}).add;
)
///////////   Synthdef complejos ///////

(

// Filter functions organized in a dictionary (Event)
// The signal of our synth will be passed in as the first argument
f = (
    hpf: { |in, cutoff=1000, rq=1|
        RHPF.ar(in, cutoff, rq)
    },
    bpf: { |in, cutoff=1000, rq=1|
        BPF.ar(in, cutoff, rq)
    },
    lpf: { |in, cutoff=1000, rq=1|
        RLPF.ar(in, cutoff, rq)
    }
);

// Iterate over all the filters we defined above and use them in a SynthDef
f.keysValuesDo{|filtername, filterfunction|
    var synthdefname = "saw" ++ filtername.asString;

    SynthDef.new(synthdefname, { |freq=220, out=0|
        var sig = Saw.ar(freq, mul:0.1);

        sig = SynthDef.wrap(
            filterfunction,
            prependArgs: [sig] // Pass signal in to the filter
            // NOTE: prependArgs HAVE to be inside of []
        );

        Out.ar(out, sig)
    }).add;
};
)


////////////////////////////////////////
////////// Synthdef Buffplayer ///////////
////cortesía Mads Kjeldgaard//////////7 //////////////////////////////////////

(

~bufplayerfunc = {|numchans=1|
   {|rate=1, buffer, trigger=1, start=0, loop=0, amp=1, out=0|

      // Buffer player
      var sig = PlayBuf.ar(
         numchans, // Number of channels passed into the function from the outer function
         buffer,
         rate * BufRateScale.kr(buffer),
         trigger,
         start * BufDur.kr(buffer),
         loop
         );

      // Output
      Out.ar(out, sig * amp);
   }
};

(1..64).do{|chanNum|
   var name = "bufplayer" ++ chanNum;
   SynthDef.new(name, ~bufplayerfunc.value(chanNum)).add;
};

)

/*
Con este synthdef, se puede llamarlo por su nombre base (“bufplayer” en este caso) más el número de canales. Por ejemplo: un reproductor de búfer de 33 canales se vería así
Synth(\bufplayer33, [\buffer, b])
Uno mono:
Synth(\bufplayer1, [\buffer, b])
Uno estereo:
Synth(\bufplayer2, [\buffer,b])
*/





