// main.ck

16 => int NUM_SPEAKERS;;

WFS wfs;
WFSsetup(NUM_SPEAKERS);
Point sourcePoint;

SinOsc xSine => blackhole;
SinOsc ySine => blackhole;
xSine.freq(0.25);
ySine.freq(0.25);
ySine.phase(pi/2);

CNoise nois;
nois.gain(0.4);
Gain g[NUM_SPEAKERS];
Delay d[NUM_SPEAKERS];

for (0 => int i; i < NUM_SPEAKERS; i++) {
    nois => g[i] => dac.chan(i);
}

while (true) {
    (xSine.last() * 1.0) + 0.5  => float x;
    (ySine.last() * 1.0) + 2.0 => float y;
    sourcePoint.set(x, y);
    2::ms => now;

    wfs.update(sourcePoint);
    wfs.getAmplitudes() @=> float amplitudes[];
    wfs.getDelayTimes() @=> float delayTimes[];

    for (0 => int i; i < NUM_SPEAKERS; i++) {
        g[i].gain(amplitudes[i]);
        d[i].delay(delayTimes[i]::second);
    }

    printValues(amplitudes, delayTimes);
}

fun void printValues(float amplitudes[], float delayTimes[]) {
    string amplitudeString;
    string delayString;

    for (0 => int i; i < amplitudes.size(); i++) {
        amplitudes[i] + "" => string amp;
        delayTimes[i] + "" => string del;
        amp.substring(0, 4) + " " +  amplitudeString => amplitudeString;
        del.substring(0, 6) + " " +  delayString => delayString;
    }

    <<< amplitudeString + " | " + delayString, "" >>>;
}

fun void WFSsetup(int speakerNumber) {
    // in meters
    1.0 => float xSize;
    2.0 => float ySize;
    0.41 => float speakerArrayLength;

    // required before any other funcction call
    wfs.setSpeakerNumber(speakerNumber);

    wfs.setReferenceLine(0.0, 2.0, 1.0, 2.0);

    speakerArrayLength / (speakerNumber - 1) => float speakerSpacing;
    xSize * 0.5 - speakerArrayLength * 0.5 => float speakerStartingPoint;
    for (0 => int i; i < speakerNumber; i++) {
        speakerStartingPoint + speakerSpacing * i => float x;
        0.0 => float y;

        wfs.setSpeakerPoint(i, x, y);
        wfs.setSpeakerNormal(i, 270);
    }
}
