                            /////      Filter     //////


                           //////// Clase Abstracta ////////

////////////      MoogFF
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
       MoogFF  Una implementación digital del Moog VCF (filtro)
       MoogFF.ar(in, freq: 100, gain: 2, reset: 0, mul: 1, add: 0)


                 - - - - - - - - - - - - - - - - - -
                  Arguments:
                             |in|	the input signal.
                             |freq|	the cutoff frequency.
                             |gain|	the filter resonance gain, between zero and 4.
                             |reset| 	when greater than zero, this will reset the            state of the digital filters at the beginning of a computational block.
                             |mul|
                             |add|

                   - - - - - - - - - - - - - - - - - -

- - - - - - - - - - - - - - - - - - Ejemplos - - - - - - - - - - - - - - - - - -


p = ProxySpace.push(s.boot);



~fn.play; ~fn.awake_(false);
~fn = {
	|amp=1, freq=220,fcutoff=500, mgain=1, r=0, atk=0.05, rel=1 , sus=1,pos=0|
	var sig, env;
	freq = freq.lag(2);
	//env = Env.linen(atk,rel,sus,curve:-5).ar(2);
	sig = Saw.ar(freq,amp);
	sig = MoogFF.ar(sig ,fcutoff,mgain,r,amp);

	sig = Pan2.ar(sig,pos);

}
z = ~fn.play;
z.free
z.set(\freq,exprand(80,1300), \fcutoff,1000, \mgain,3)

z.release(5)

~a = Tdef(\0, {
	~fn.spawn([\freq,exprand(80,1300), \fcutoff,1000, \mgain,3]);
	1.25.wait;

})
~a.stop
~a.play




HPF.scopeResponse
BRF.scopeResponse
Median.scopeResponse