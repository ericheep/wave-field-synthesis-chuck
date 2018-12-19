// main.ck

fun void main() {
    2 => int NUM_SPEAKERS;;
    WFS wfs;
    wfsSetup(wfs, NUM_SPEAKERS);

    // sound chain
    CNoise nois;
    nois.gain(0.4);
    Gain g[NUM_SPEAKERS];
    Delay d[NUM_SPEAKERS];

    for (0 => int i; i < NUM_SPEAKERS; i++) {
        nois => g[i] => d[i] => dac.chan(i);
    }

    Point sourcePoint;

    // spatial sines
    SinOsc xSine => blackhole;
    SinOsc ySine => blackhole;

    xSine.freq(0.25);
    ySine.freq(0.25);
    ySine.phase(0.25);

    while (true) {
        xSine.last() + 0.5  => float x;
        ySine.last() + 2.0 => float y;
        sourcePoint.set(x, y);

        wfs.update(sourcePoint);
        wfs.getAmplitudes() @=> float amplitudes[];
        wfs.getDelayTimes() @=> float delayTimes[];

        for (0 => int i; i < NUM_SPEAKERS; i++) {
            g[i].gain(amplitudes[i]);
            d[i].delay(delayTimes[i]::second);
        }

        printValues(amplitudes, delayTimes);

        1::ms => now;
    }
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

fun void wfsSetup(WFS wfs, int numSpeakers) {
    // in meters
    1.0 => float xSize;
    2.0 => float ySize;
    0.41 => float speakerArrayLength;

    // required before any other funcction call
    wfs.setSpeakerNumber(numSpeakers);

    wfs.setReferenceLine(0.0, 2.0, 1.0, 2.0);

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
