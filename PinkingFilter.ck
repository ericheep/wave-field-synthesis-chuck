// Pinking Filter.ck

public class PinkingFilter extends Chugen {
    float b0, b1, b2, b3, b4, b5, b6;

    fun float tick(float in) {
        0.99886 * b0 + in * 0.0555179 => b0;
        0.99332 * b1 + in * 0.0750759 => b1;
        0.96900 * b2 + in * 0.1538520 => b2;
        0.86650 * b3 + in * 0.3104856 => b3;
        0.55000 * b4 + in * 0.5329522 => b4;
        -0.7616 * b5 - in * 0.0168980 => b5;
        b0 + b1 + b2 + b3 + b4 + b5 + b6 + in * 0.5362 => float pink;
        in * 0.115926 => b6;
        return pink;
    }
}
