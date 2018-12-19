// main.ck

fun void main() {
    2    => int NUM_SPEAKERS;;
    1.5  => float referenceLineOffset;
    1.0  => float xSize;
    0.41 => float speakerArrayLength;

    WFS wfs;
    wfsSetup(wfs, NUM_SPEAKERS, referenceLineOffset, xSize, speakerArrayLength);

    // sound chain
    CNoise pink;
    pink.gain(0.2);
    Gain g[NUM_SPEAKERS];
    Delay d[NUM_SPEAKERS];

    for (0 => int i; i < NUM_SPEAKERS; i++) {
        pink => g[i] => d[i] => dac.chan(i);
    }

    Point sourcePoint;

    // spatial sines
    SinOsc xSine => blackhole;
    SinOsc ySine => blackhole;

    xSine.freq(0.25);
    ySine.freq(0.25);
    ySine.phase(0.25);

    while (true) {
        xSine.last() + 0.5 => float x;
        ySine.last() * 2.5 + 3.0 => float y;

        sourcePoint.set(x, 2.0);
        wfsUpdate(wfs, NUM_SPEAKERS, sourcePoint, g, d);

        0.25::ms => now;
    }
}

fun void wfsUpdate(WFS wfs, int numSpeakers, Point sourcePoint, Gain g[], Delay d[]) {
    wfs.update(sourcePoint);
    wfs.getAmplitudes() @=> float amplitudes[];
    wfs.getDelayTimes() @=> float delayTimes[];

    for (0 => int i; i < numSpeakers; i++) {
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
        amp.substring(0, 4) + " " +  amplitudeString => amplitudeString;
        delayTimes[i] + "" => string del;
        del.substring(0, 6) + " " +  delayString => delayString;
    }

    <<< amplitudeString + " | " + delayString, "" >>>;
}

fun void wfsSetup(WFS wfs, int numSpeakers, float referenceLine, float xSize, float speakerArrayLength) {
    wfs.setSpeakerNumber(numSpeakers);
    wfs.setReferenceLine(referenceLine);

    speakerArrayLength / (numSpeakers - 1) => float speakerSpacing;
    xSize * 0.5 - speakerArrayLength * 0.5 => float speakerStartingPoint;
    for (0 => int i; i < numSpeakers; i++) {
        speakerStartingPoint + speakerSpacing * i => float x;
        0.0 => float y;

        wfs.setSpeakerPoint(i, x, y);
        wfs.setSpeakerNormal(i, 270);
    }
}

main();
