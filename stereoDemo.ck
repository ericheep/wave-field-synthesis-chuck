// stereoDemo.ck

fun void keyboardControl(WFS wfs[], Point point[], int numSpeakers, Gain g[][], Delay d[][]) {
    Hid key;
    HidMsg msg;
    0 => int device;
    if (me.args())me.arg(0) => Std.atoi => device;

    // if no keyboard is present, the program will exit
    if (!key.openKeyboard(device))me.exit();
    <<< "Keyboard '" + key.name() + "' is activated!","">>>;

    while (true) {
        key => now;
        while (key.recv(msg)) {
            // converts ascii value to a value between 0 and 24
            if (msg.isButtonDown() ) {
                // 87, 83, 65, 68
                if (msg.ascii == 87) {
                    0.05 -=> point[0].y;
                    0.05 -=> point[1].y;
                }
                if (msg.ascii == 83) {
                    0.05 +=> point[0].y;
                    0.05 +=> point[1].y;
                }
                if (msg.ascii == 65) {
                    0.05 -=> point[0].x;
                    0.05 +=> point[1].x;
                }
                if (msg.ascii == 68) {
                    0.05 +=> point[0].x;
                    0.05 -=> point[1].x;
                }

                wfsUpdate(wfs[0], numSpeakers, point[0], g[0], d[0]);
                wfsUpdate(wfs[1], numSpeakers, point[1], g[1], d[1]);
                <<< "[", point[0].x, point[0].y, "]",
                    "[", point[1].x, point[1].y, "]", "" >>>;
            }
        }
    }
}

fun void main() {
    "stereo12" => string type;
    float referenceLineOffset;
    float xSize;
    int NUM_SPEAKERS;
    float speakerArrayLength;

    // all units are meters
    if (type == "stereo8") {
        1.0   => referenceLineOffset;
        1.0   => xSize;
        8     => NUM_SPEAKERS;
        0.44  => speakerArrayLength;
    } else if (type == "stereo10") {
        1.0   => referenceLineOffset;
        1.0   => xSize;
        10    => NUM_SPEAKERS;
        0.55  => speakerArrayLength;
    } else if (type == "stereo12") {
        1.0   => referenceLineOffset;
        1.0   => xSize;
        12    => NUM_SPEAKERS;
        0.66  => speakerArrayLength;
    } else if (type == "stereo16") {
        1.0   => referenceLineOffset;
        1.0   => xSize;
        16    => NUM_SPEAKERS;
        0.88  => speakerArrayLength;
    } else if (type == "bypass") {
        16    => NUM_SPEAKERS;
    }

    WFS wfs[2];
    wfsSetup(wfs[0], NUM_SPEAKERS, referenceLineOffset, xSize, speakerArrayLength);
    wfsSetup(wfs[1], NUM_SPEAKERS, referenceLineOffset, xSize, speakerArrayLength);

    // sound chain
    Gain g[2][NUM_SPEAKERS];
    Delay d[2][NUM_SPEAKERS];
    SndBuf2 stereo;

    Point sourcePoint[2];
    sourcePoint[0].set(0.0, 2.0);
    sourcePoint[1].set(1.0, 2.0);

    if (type == "stereo8") {
        for (0 => int i; i < NUM_SPEAKERS; i++) {
            stereo.chan(0) => g[0][i] => d[0][i] => dac.chan(i);
            stereo.chan(1) => g[1][i] => d[1][i] => dac.chan(i + 8);
        }
    } else if (type == "stereo10") {
        for (0 => int i; i < NUM_SPEAKERS; i++) {
            stereo.chan(0) => g[0][i] => d[0][i] => dac.chan(i);
            stereo.chan(1) => g[1][i] => d[1][i] => dac.chan(i + 6);
        }
    } else if (type == "stereo12") {
        for (0 => int i; i < NUM_SPEAKERS; i++) {
            stereo.chan(0) => g[0][i] => d[0][i] => dac.chan(i);
            stereo.chan(1) => g[1][i] => d[1][i] => dac.chan(i + 4);
        }
    } else if (type == "stereo16") {
        for (0 => int i; i < NUM_SPEAKERS; i++) {
            stereo.chan(0) => g[0][i] => d[0][i] => dac.chan(i);
            stereo.chan(1) => g[1][i] => d[1][i] => dac.chan(i);
        }
    } else if (type == "bypass") {
        for (0 => int i; i < NUM_SPEAKERS/2; i++) {
            stereo.chan(0) => dac.chan(i);
            stereo.chan(1) => dac.chan(i + 8);
        }
    }

    stereo.read(me.dir() + "media/Money.wav");
    stereo.loop(1);

    if (type != "bypass") {
        wfsUpdate(wfs[0], NUM_SPEAKERS, sourcePoint[0], g[0], d[0]);
        wfsUpdate(wfs[1], NUM_SPEAKERS, sourcePoint[1], g[1], d[1]);
    }

    spork ~ keyboardControl(wfs, sourcePoint, NUM_SPEAKERS, g, d);

    stereo.pos(0);
    hour => now;
}

fun void wfsUpdate(WFS wfs, int numSpeakers, Point sourcePoint, Gain g[], Delay d[]) {
    wfs.update(sourcePoint);
    wfs.getAmplitudes() @=> float amplitudes[];
    wfs.getDelayTimes() @=> float delayTimes[];

    for (0 => int i; i < numSpeakers; i++) {
        g[i].gain(amplitudes[i]);
        d[i].delay(delayTimes[i]::second);
    }

    /* printValues(amplitudes, delayTimes); */
}

fun void printValues(float amplitudes[], float delayTimes[]) {
    string amplitudeString;
    string delayString;

    for (0 => int i; i < amplitudes.size(); i++) {
        amplitudes[i] + "" => string amp;
        amp.substring(0, 4) + " " +  amplitudeString => amplitudeString;
        /* delayTimes[i] + "" => string del; */
        /* del.substring(0, 6) + " " +  delayString => delayString; */
    }

    <<< amplitudeString + delayString, "" >>>;
}

fun void wfsSetup(WFS wfs, int numSpeakers, float referenceLine, float xSize, float speakerArrayLength) {
    wfs.setSpeakerNumber(numSpeakers);
    wfs.setReferenceLine(referenceLine);
    wfs.setSpeakerArrayLength(speakerArrayLength);
    wfs.setTaper(0.2);

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
