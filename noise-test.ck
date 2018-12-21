CNoise nois;
nois.gain(0.5);

while (true) {
    for (13 => int i; i < 14; i++) {
        nois => dac.chan(i);
        2::second => now;
        nois =< dac.chan(i);
    }
}
