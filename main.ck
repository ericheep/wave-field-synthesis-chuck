// main.ck

fun void main() {
    "laptop" => string type;
    float referenceLineOffset;
    float xSize;
    int NUM_SPEAKERS;
    float speakerArrayLength;

    // all units are meters
    if (type == "speakerArray") {
        1.5   => referenceLineOffset;
        1.0   => xSize;

        16    => NUM_SPEAKERS;
        0.88  => speakerArrayLength;
    } else if (type == "laptop") {
        0.6   => referenceLineOffset;
        0.6   => xSize;

        2     => NUM_SPEAKERS;
        0.315 => speakerArrayLength;
    }

    WFS wfs;
    wfsSetup(wfs, NUM_SPEAKERS, referenceLineOffset, xSize, speakerArrayLength);

    // sound chain
    Gain g[NUM_SPEAKERS];
    Delay d[NUM_SPEAKERS];

    for (0 => int i; i < NUM_SPEAKERS; i++) {
        g[i] => d[i] => dac.chan(i);
    }

    Point sourcePoint;
    /* movingPinkNoise(wfs, sourcePoint, NUM_SPEAKERS, g, d); */
    voicePositions(wfs, sourcePoint, NUM_SPEAKERS, g, d);
}

fun void movingPinkNoise (WFS wfs, Point sourcePoint, int numSpeakers, Delay d[], Gain g[]) {
    CNoise pink;
    pink.gain(0.2);

    // spatial sines
    SinOsc xSine => blackhole;
    SinOsc ySine => blackhole;

    xSine.freq(0.25);
    ySine.freq(0.25);
    ySine.phase(0.25);

    for (0 => int i; i < numSpeakers; i++) {
        pink => g[i];;
    }

    while (true) {
        xSine.last() + 0.5 => float x;
        ySine.last() * 2.5 + 3.0 => float y;

        sourcePoint.set(x, 2.0);
        wfsUpdate(wfs, numSpeakers, sourcePoint, g, d);

        0.25::ms => now;
    }
}

fun void voicePositions (WFS wfs, Point sourcePoint, int numSpeakers, Gain g[], Delay d[]) {
    SndBuf voice;

    ["left-front.aiff",  "middle-front.aiff",  "right-front.aiff",
     "left-center.aiff", "middle-center.aiff", "right-center.aiff",
     "left-back.aiff",   "middle-back.aiff",   "right-back.aiff"]
     @=> string voiceFiles[];

    [[0.0, 1.0], [0.5, 1.0], [1.0, 1.0],
     [0.0, 1.5], [0.5, 1.5], [1.0, 1.5],
     [0.0, 2.5], [0.5, 2.5], [1.0, 2.5]]
     @=> float voiceCoordinates[][];

    for (0 => int i; i < numSpeakers; i++) {
        voice => g[i];;
    }

    0 => int which;
    while (true) {
        voice.read(me.dir() + "voice-positions/" + voiceFiles[which]);
        voice.pos(0);

        sourcePoint.set(voiceCoordinates[which][0], voiceCoordinates[which][1]);
        wfsUpdate(wfs, numSpeakers, sourcePoint, g, d);

        (voice.samples() * 2)::samp => now;
        (which + 1) % voiceFiles.size() => which;
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
