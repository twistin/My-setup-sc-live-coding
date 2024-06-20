// See http://c4dm.eecs.qmul.ac.uk/papers/2011/Stowell2011icmc.pdf

// use any shortish 4/4 drum loop
b = Buffer.read(s, "/samples/set1/breaks175/bpm.wav");
b.free;
b.numChannels

(
SynthDef(\risset, {
    |out = 0, buf, megabardur = 3.0, bufdur = 3.0, level = 0, bandwidth = 1, centerrate = 1, dir = 1|
    var t, rate, snd, power;
    t = Sweep.kr * dir;
    rate = bufdur * 2.log / megabardur * pow(2, t / megabardur + level);
    power = (pi * bandwidth * 0.5 * log2(rate / centerrate)).clip2(pi).cos + 1 / 2;
    snd = PlayBuf.ar(1, b, BufRateScale.kr(b) * rate, loop: 1) * power;
    EnvGen.kr(Env([0, 0], [megabardur]), doneAction: 2);
    Out.ar(out, Pan2.ar(snd));
}).add;
)

(
// amount of time it takes for the audio to speed up or slow down 2x
// the rhythm repeats seamlessly every megabar
var megabardur = 20.0;
Pbind(
    \instrument, \risset,
    \buf, b,
    \megabardur, megabardur,
    \dur, megabardur,
    \bufdur, b.duration,
    \level, (0..5),
    \bandwidth, 0.8, // adjust this if the illusion isn't very convincing
    \centerrate, 1.0,
    \dir, 1 // 1 for accel, -1 for decel
).play;
)