s.boot;
/*
MIDIOut.new(0);
MIDIIn.connectAll;
MIDIIn.disconnectAll;
MIDIFunc.trace(true);
MIDIClient.destinations;
MIDIFunc.trace(false);// si no queremos ver los datos
MIDIClient.init;

MIDIIn.connectAll;
///// Fuentes de sonido
*/

MIDIFunc.trace(true);


//////         /////////      MIDI  //////// //////       ////////







(
SynthDef(\samp, {
    var sig, buf = \buf.ir(0);
    sig = PlayBuf.ar(2, buf, BufRateScale.ir(buf), doneAction:2);
    sig = sig * \amp.ir(0.5);
    Out.ar(\out.ir(0), sig);
}).add;





SynthDef(\saw, {
    var sig, env;
    env = Env([0,1,0],[0.001,\rel.ir(1)],[0,-10]).kr(2);
    sig = Saw.ar(\freq.ir(400))!2;
    sig = LPF.ar(sig, 1500);
    sig = sig * \amp.ir(0.2) * env;
    Out.ar(\out.ir(0), sig);
}).add;
)





// almacenar y gestionar archivos de audio

(
b = ();

PathName("/Users/sdcarr/Desktop/LiveCoding-2024/samples/set1/perc".resolveRelative).entries.collect({
    |path|
    b[path.fileNameWithoutExtension.asSymbol] = Buffer.read(s,path.fullPath);
})


)

b.keys
b.s.play
//  Conectar dispositivo a la máquina

/*
Dispositivo AKAI MPK25

cc k 1 ->  no funciona, k 2 -> no funcina.

desde k 3 hasta k 12 -> cc = 14, 15, 16, 17, 18, 19, 20, 21, 22,23




*/


(
MIDIdef.noteOn(\note,{
    //"hello!".postln;
    arg val, num, chan, src;
   // Synth(\saw, [\freq, 80])
    [val, num, chan, src].postln;

    Synth(\saw, [
        \freq, num.midicps,
        \amp, val.linlin(0,127,-40,-6).dbamp,
        rel:3
    ]);
});
)

s.scope

(
s.newBusAllocators;
~cfbus = Bus.control(s,1);
)

(
MIDIdef.cc(\cf, {
    arg val, num;
    ~cfbus.value_(val/10)
}, ccNum:15) // K12
)

s.scope;

(
MIDIdef.cc(\modwheel, {
    arg val, num, chan, src;
   if(val == 127) {MIDIdef(\note).enable; "enabled".postln};
   if(val == 0) {MIDIdef(\note).disable; "disable".postln};
    //[val, num, chan, src].postln;
},ccNum:1)

)
MIDIdef.cc(\modwheel).free
MIDIdef.freeAll;



/////  Asignar samples


(
MIDIdef.noteOn(\samp, {
    arg val,num;
    var buffer;
    if(num== 35) {buffer = b.k};
     if(num== 36) {buffer = b.s};
     if(num== 37) {buffer = b.r};
     if(num== 38) {buffer = b.b};
     if(num== 39) {buffer = b.c};
     if(num== 40) {buffer = b.s};

    Synth(\samp, [\buf:nil]);

})
)




(
MIDIdef.noteOn(\samp, {
    arg val,num;
    var buffer;
    switch(num)
    {25}{b.k}
    {40}{b.s}
    {true}{nil};
    buffer.postln;
    if(buffer.notNil){
    Synth(\samp, [\buf:buffer]);
    };
})
)





SynthDef(\saw, {
    var sig, env, cf;
    cf = In.kr(\in.kr(~cfbus), 1);
    cf = cf.linexp(0,1,20,15000);
    env = Env([0,1,0],[0.001,\rel.ir(1)],[0,-10]).kr(2);
    sig = Saw.ar(\freq.ir(100))!2;
    sig = LPF.ar(sig, cf);
    sig = sig * \amp.ir(0.2) * env;
    Out.ar(\out.ir(0), sig);
}).add;

Synth(\saw)
/// Para desactivar midi
MIDIdef(\note).enable;
MIDIdef(\note).disable;



p = Pbind(
    \instrument, \saw,
    \dur, Pseq([0.25,0.50,0.75],inf),
    \freq, Pseq([120,150,200,440], inf)
)

p.play

p.stop


~dirbus = Bus.control(s,1);

(
MIDIdef.cc(\dir, {
    arg val;
    if(val>=64) {~dirbus.value_(1)}{~dirbus.value_(-1)};

}, ccNum:14)
)

SynthDef(\samp, {
    var sig, buf = \buf.ir(0), rate = \rate.ir(1);
    sig = PlayBuf.ar(
        2,
        buf,
        BufRateScale.ir(buf)*rate,
        1,
        \spos.ir(0),
        doneAction:2

    );
    sig = sig * \amp.ir(0.5);
    Out.ar(\out.ir(0), sig);
}).add;



Synth(\samp,[buf:b.k, spos:b.k.numFrames -2,rate:-1]);












