// main.ck

WFS wfs;
Point sourcePoint;
sourcePoint.set(0.5, 0.500);
SinOsc sourceSine => blackhole;
sourceSine.freq(0.4);

8 => int speakerNumber;

WFSsetup(speakerNumber);

Noise n;
Gain g[8];
n.gain(0.2);

for (0 => int i; i < speakerNumber; i++) {
    n => g[i] => dac.chan(i);
}

while (true) {
    (sourceSine.last() + 1.0) * 0.5 => float x;
    sourcePoint.set(x, 0.5);
    10::ms => now;

    wfs.update(sourcePoint);
    wfs.getAmplitudes() @=> float amplitudes[];

    for (0 => int i; i < speakerNumber; i++) {
        g[i].gain(amplitudes[i]);
    }
}

fun void WFSsetup(int speakerNumber) {
    48.26 => float speakerArrayLength;

    // required before any other funcction call
    wfs.setSpeakerNumber(speakerNumber);

    wfs.setReferenceLine(0.0, 0.5, 1.0, 0.5);
    wfs.setLineArrayLength(speakerArrayLength);

    1.0 / (speakerNumber - 1) => float speakerSpacing;
    for (0 => int i; i < speakerNumber; i++) {
        speakerSpacing * i => float x;
        0.0 => float y;
        wfs.setSpeakerPoint(i, x, y);
        wfs.setSpeakerNormal(i, 270);
    }
}
