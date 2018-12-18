// Point.ck

public class Point {
    float x, y;

    public void set(float _x, float _y) {
        _x => x;
        _y => y;
    }

    public int isEqual(Point p) {
        if (p.x == x && p.y == y) {
            return true;
        } else {
            return false;
        }
    }

    public float distanceFromPoint(Point p) {
        return Math.sqrt( Math.pow(x - p.x, 2) + Math.pow(y - p.y, 2));
    }

    public float distanceFromLine(Line l) {
        Math.fabs(l.a * x + l.b * y + l.c) => float numerator;
        Math.sqrt(Math.pow(l.a, 2) + Math.pow(l.b, 2)) => float denominator;
        return numerator/denominator;
    }

    public float angleFromPoint(Point p) {
        return Math.atan2(x - p.x, y - p.y);
    }
}
