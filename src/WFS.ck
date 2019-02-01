// WFS.ck

public class WFS {
    float amplitudes[0];
    float taperAmplitudes[0];
    float delayTimes[0];
    float length, width, speakerArrayLength;
    false => int isTapered;
    0.2   => float taperWindow;
    1.05  => float taperLength;

    Speaker speakers[0];
    Line referenceLine;
    Point memoSourcePoint;

    0   => int numSpeakers;
    340 => float C;

    // in meters
    public void setBounds(float l, float w) {
        l => length;
        w => width;
    }

    public void setC(float c) {
        c => C;
    }

    public void setSpeakerArrayLength(float cm) {
        cm => speakerArrayLength;

        if (taperLength == 0) {
            cm => taperLength;
        }
    }

    public void taperSpeakers(int taper) {
        taper => isTapered;
    }

    public void setTaper(float taperWin) {
        true => isTapered;
        taperWin => taperWindow;

        speakerArrayLength / (numSpeakers - 1) => float speakerSpacing;
        speakerArrayLength + speakerSpacing * 2 => taperLength;
        setTaperAttenuations();
    }

    public void setTaper(float taperWin, float taperLen) {
        taperLen => taperLength;
        taperWin => taperWindow;
        setTaperAttenuations();
    }

    private void setTaperAttenuations() {
        speakerArrayLength / (numSpeakers - 1) => float speakerSpacing;
        taperLength * 0.5 - speakerArrayLength * 0.5 => float speakerStartingPoint;

        for (0 => int i; i < numSpeakers/2; i++) {
            speakerStartingPoint + speakerSpacing * i => float x;
            if (x < taperWindow) {
                Math.sin(pi * 0.5 * (x/taperWindow)) => float w;
                w => taperAmplitudes[i];
                w => taperAmplitudes[numSpeakers - (i + 1)];
            }
            else {
                1.0 => taperAmplitudes[i];
            }
        }
    }

    public void setSpeakerNumber(int number) {
        for (0 => int i; i < number; i++) {
            Speaker s;
            speakers << s;
            speakers[i].setReferenceLine(referenceLine);

            amplitudes << 0.0;
            taperAmplitudes << 1.0;
            delayTimes << 0.0;
        }
        number => numSpeakers;
    }

    public void setSpeakerPoint(int index, float x, float y) {
        speakers[index].setSpeakerPoint(x, y);
    }

    public void setReferenceLine(float r) {
        referenceLine.set(0.0, r, 1.0, r);

        for (0 => int i; i < numSpeakers; i++) {
            speakers[i].setReferenceLine(referenceLine);
        }
    }

    public void setReferenceLine(float x1, float y1, float x2, float y2) {
        referenceLine.set(x1, y1, x2, y2);

        for (0 => int i; i < numSpeakers; i++) {
            speakers[i].setReferenceLine(referenceLine);
        }
    }

    public void setSpeakerNormal(int index, float angle) {
        speakers[index].setSpeakerNormal(angle);
    }

    public float[] getDelayTimes() {
        return delayTimes;
    }

    public float[] getAmplitudes() {
        return amplitudes;
    }

    public float[] reverseDelaysByMax(float delayTimes[], float maxDelay) {
        for (0 => int i; i < delayTimes.size(); i++) {
            maxDelay - delayTimes[i] => delayTimes[i];
        }
        return delayTimes;
    }

    public float getMaxDelay(float delayTimes[]) {
        0.0 => float maxDelay;
        for (0 => int i; i < delayTimes.size(); i++) {
            if (delayTimes[i] > maxDelay) {
                delayTimes[i] => maxDelay;
            }
        }
        return maxDelay;
    }

    // in m
    public void update(Point sourcePoint) {
        for (0 => int i; i < numSpeakers; i++) {
            if (!memoSourcePoint.isEqual(sourcePoint)) {
                speakers[i].calculateAmplitude(sourcePoint) => amplitudes[i];
                speakers[i].calculateDelayTime(sourcePoint, C) => delayTimes[i];
                if (isTapered) taperAmplitudes[i] *=> amplitudes[i];
            } else {
                speakers[i].getAmplitude() => amplitudes[i];
                speakers[i].getDelayTime() => delayTimes[i];
            }
        }

        if (sourcePoint.y > 0.0) {
            reverseDelaysByMax(delayTimes, getMaxDelay(delayTimes)) @=> delayTimes;
        }

        memoSourcePoint.set(sourcePoint);
    }
}
