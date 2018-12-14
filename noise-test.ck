Noise c;
Gain g[8];

c.gain(0.2);
for (0 => int i; i < 8; i++) {
    c => g[i] => dac.chan(i);
    g[i].gain(0.0);
}

while (true) {
    for (0 => int i; i < 8; i++) {
        g[i].gain(1.0);
        100::ms => now;
        g[i].gain(0.0);
    }
}
