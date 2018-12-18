// main.ck

WFS wfs;
Point sourcePoint;
sourcePoint.set(0.5, 0.025);

setup();
wfs.update(sourcePoint);

fun void setup() {
    8 => int speakerNumber;
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
