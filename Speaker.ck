// Speaker.ck

public class Speaker {
    float normal;
    Point speakerPoint;
    Point memoSourcePoint;
    Line referenceLine;

    public void setSpeakerPoint(float x, float y) {
        speakerPoint.set(x, y);
    }

    public void setReferenceLine(Line l) {
        l @=> referenceLine;
    }

    public void setSpeakerNormal(float angle) {
        // radian conversion
        angle * pi/180.0 => normal;
    }

    public void update(Point sourcePoint) {
        if (memoSourcePoint.isEqual(sourcePoint)) {
            return;
        }

        /* <<< speakerPoint.distanceFromPoint(sourcePoint) >>>; */
        /* <<< speakerPoint.angleFromPoint(sourcePoint) >>>; */
        /* <<< speakerPoint.distanceFromLine(referenceLine), "" >>>; */

        sourcePoint @=> memoSourcePoint;
    }
}
