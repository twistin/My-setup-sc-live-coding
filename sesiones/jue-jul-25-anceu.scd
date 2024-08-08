("../Setup/Setup.scd").loadRelative;


MIDIClient.init;

MIDIIn.connectAll;


MIDIFunc.trace(true);
MIDIFunc.trace(false);

{SinOsc.ar(80)!2 * Env.linen(0.5,2,0.5).ar(2)* 0.5}.play

(
MIDIdef.noteOn(\simpleNotes, {
|val, num, chan, src| // chan & src declared but not used
{
var sig, freq, amp;
freq = num.midicps;
amp = val.linexp(1, 127, 0.01, 0.25);
sig = SinOsc.ar(freq * [0, 0.1].midiratio) * amp;
sig = sig * Env.perc.kr(2);
}.play;
});
 )

(
~filtCutoff = 200;
MIDIdef.cc(\filtControl,
{
|val, num, chan, src|
~filtCutoff = val.linexp(1, 127, 200, 10000);
}, ccNum: 1 // only respond to CC#1 messages
);
MIDIdef.noteOn(\simpleNotes,
{
|val, num, chan, src|
{arg cf = 200;
var sig, freq, amp;
freq = num.midicps;
amp = val.linexp(1, 127, 0.01, 0.25);
sig = Saw.ar(freq * [0, 0.1].midiratio) * amp;
sig = RLPF.ar(sig, cf, 0.1);
sig = sig * Env.perc.kr(2);
}.play(args: [\cf, ~filtCutoff]);
}
);
 )

b.play
(
b = Buffer.read(s, Platform.resourceDir ++ "/sounds/a11wlk01.wav");
MIDIdef.freeAll;
MIDIdef.noteOn(\sampler, {
|val, num, chan, src|
{
var sig, rate, amp;
rate = (num - 60).midiratio;
amp = val.linexp(1, 127, 0.1, 0.7);
sig = PlayBuf.ar(
1, b, BufRateScale.ir(b) * rate, startPos: 85000
);
sig = sig * Env.perc.kr(2) * amp ! 2;
}.play;
});
 )

(
MIDIdef.freeAll;
MIDIdef.noteOn(\weird, {
|val, num, chan, src|
case
{num == 60} {exprand(1, 100).postln}
{num == 61} {
{PinkNoise.ar(0.1 ! 2) * Line.kr(1, 1, 0.1, doneAction:2)}.play
}
{num == 62} {s.quit};
}, noteNum: [60, 61, 62]
);
 )

(
(
type: \midi,
midiout: m,
midicmd: \noteOn,
chan: 0,
midinote: 60,
amp: 0.5,
sustain: 2 // note-off sent 2 beats later
).play;
 )

(

t = TempoClock.new(108/60);
p = Pbind(
\type, \midi,
\dur, 1/2,
\midiout, m,
\midicmd, \noteOn,
\chan, 0,
\midinote, Pseq([60, 72, 75],inf),
\amp, 0.5,
\sustain, 1/8,
);
~seq = p.play(t);
)
 ~seq.pause;
~p.clear
