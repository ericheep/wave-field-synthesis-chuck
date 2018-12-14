public class PreFilter extends Chugen {
    0 => float angularFrequency;
    360.0 => float c;
    pi * 2.0 => float tau;
    c * tau => float tauCProduct;

    public void setC (float _c) {
        _c => c;
        c * tau => tauCProduct;
    }

    public void setAngularFrequency (float a) {
        a => angularFrequency;
    }

    private float tick (float in) {
        Math.sqrt((Math.fabs(in) * angularFrequency)/tauCProduct) => float out;
        return out * Math.sgn(in);
    }
}

SinOsc sin => blackhole;
sin.freq(0.25);

Noise n => PreFilter p => dac;

while (true) {
    p.setAngularFrequency(((sin.last() + 1.0) * 0.5) * pi * 2.0);
    <<< p.last() >>>;
    ms => now;
}

second => now;

