// Speaker.ck

public class Speaker {
    float normal;
    Point speakerPoint;

    public void setSpeakerPoint(float x, float y) {
        speakerPoint.set(x, y);
    }

    public void setSpeakerNormal(float angle) {
        // radian conversion
        angle * pi/180.0 => normal;
    }

    public void update(Point sourcePoint) {
        /* <<< speakerPoint.distanceFrom(sourcePoint) >>>; */
        /* <<< speakerPoint.angleFrom(sourcePoint) >>>; */
        <<< "radians:", sourcePoint.angleFrom(speakerPoint), "" >>>;
    }
}
