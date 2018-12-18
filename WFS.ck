// WFS.ck

public class WFS {
    Speaker speakers[0];
    Line referenceLine;
    0.0 => float lineArrayLength;
    0 => int speakerNumber;
    340 => float C;

    public void setC (float c) {
        c => C;
    }

    public void setSpeakerNumber (int number) {
        for (0 => int i; i < number; i++) {
            Speaker s;
            speakers << s;
            speakers[i].setReferenceLine(referenceLine);
        }
        number => speakerNumber;
    }

    public void setLineArrayLength(float cm) {
        cm => lineArrayLength;
    }

    public void setSpeakerPoint(int index, float x, float y) {
        speakers[index].setSpeakerPoint(x, y);
    }

    public void setReferenceLine(float x1, float y1, float x2, float y2) {
        referenceLine.set(x1, y1, x2, y2);

        for (0 => int i; i < speakerNumber; i++) {
            speakers[i].setReferenceLine(referenceLine);
        }
    }

    public void setSpeakerNormal(int index, float angle) {
        speakers[index].setSpeakerNormal(angle);
    }

    // in m
    public void setLineArrayLength(float length) {
        length => lineArrayLength;
    }

    // in m
    public void update(Point sourcePoint) {
        for (0 => int i; i < speakerNumber; i++) {
            speakers[i].update(sourcePoint);
        }
    }
}
