// Line.ck

public class Line {
    float a, b, c;
    float x1, y1, x2, y2;

    public void set(float _x1, float _y1, float _x2, float _y2) {
        _x1 => x1;
        _y1 => y1;
        _x2 => x2;
        _y2 => y2;

        // set our equation for a line
        (y2 - y1)/(x2 - x1) => a;
        y1 - a * x1 => c;
        1.0 => b;
    }

    public void set(float _a, float _b, float _c) {
        _a => a;
        _b => b;
        _c => c;
    }
}
