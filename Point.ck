// Point.ck

public class Point {
    float x;
    float y;

    public void set(float _x, float _y) {
        _x => x;
        _y => y;
    }

    public float distanceFrom(Point p) {
        return Math.sqrt( Math.pow(x - p.x, 2) + Math.pow(y - p.y, 2));
    }

    public float angleFrom(Point p) {
        return Math.atan2(x - p.x, y - p.y);
    }
}
