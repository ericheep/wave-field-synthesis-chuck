// Speaker.ck

public class Speaker {
    float normal, radiusRef, amplitude;
    Point speakerPoint;
    Line referenceLine;


    public void setSpeakerPoint(float x, float y) {
        speakerPoint.set(x, y);
        speakerPoint.distanceFromLine(referenceLine) => radiusRef;
    }

    public void setReferenceLine(Line l) {
        l @=> referenceLine;
        speakerPoint.distanceFromLine(referenceLine) => radiusRef;
    }

    public void setSpeakerNormal(float angle) {
        // radian conversion
        angle * pi/180.0 => normal;
    }

    public float getAmplitude() {
        return amplitude;
    }

    public float calculateAmplitude(Point sourcePoint) {
        speakerPoint.distanceFromPoint(sourcePoint) => float radiusSource;

        Math.sqrt(
            Math.fabs(radiusRef)/
            (Math.fabs(radiusSource) + Math.fabs(radiusRef))
        ) => float firstTerm;;

        Math.cos(sourcePoint.angleFromPoint(speakerPoint)) => float secondTerm;

        Math.sqrt(
            Math.fabs(radiusRef)
        ) => float thirdTerm;

        firstTerm * secondTerm * thirdTerm => amplitude;
        return amplitude;
    }
}
