Noise n => FFT fft =^ IFFT ifft => dac;

UAnaBlob blob;

// set parameters
1024 => int FFT_SIZE;
512 * 2 => int windowSize;
FFT_SIZE => fft.size;
second/samp => float SR;
SR * 0.5 => float NYQUIST;
343.0 => float c;

squareRootFilter(FFT_SIZE, SR) @=> float squareRootFilters[];

[0.5, 0.0] @=> float speakerPos[];
[0.5, 0.1] @=> float sourcePos[];
[0.0, 1.0, -0.5] @=> float referenceLine[];
0.0 => float speakerAngle;

pointLineDistance(speakerPos, referenceLine) => float deltaR;
pointPointDistance(speakerPos, sourcePos) => float r;
0.0 => float theta;

<<< r, deltaR, amplitudeFactor() >>>;

// control loop
while( true ) {
    fft.upchuck() @=> blob;

    // take fft then ifft
    ifft.upchuck();

    // advance time
    windowSize::samp => now;
}

fun float amplitudeFactor() {
    Math.sqrt(deltaR/(r + deltaR)) => float firstTerm;
    1.0/Math.sqrt(r) => float secondTerm;
    Math.cos(theta) => float thirdTerm;; <<< firstTerm, secondTerm, thirdTerm >>>;
}

fun float pointPointDistance(float point1[], float point2[]) {
    return Math.sqrt(Math.pow(point1[0] - point2[0], 2) + Math.pow(point1[1] - point2[1], 2));
}

fun float pointLineDistance (float point[], float line[]) {
    Math.fabs(line[0] * point[0] + line[1] * point[1] + line[2]) => float numerator;
    Math.sqrt(Math.pow(line[0], 2) + Math.pow(line[1], 2)) => float denominator;

    return numerator/denominator;
}

fun float[] squareRootFilter (int fftSize, float sr) {
    float squareRootFilters[fftSize/2];
    sr * 1.0/fftSize => float frequencyScalar;
    for (0 => int i; i < fftSize/2; i++) {
        frequencyScalar * (i + 1) => squareRootFilters[i];
    }

    return squareRootFilters;
}
