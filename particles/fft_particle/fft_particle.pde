import processing.sound.*;

FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];

ParticleSystem ps;

void setup() {
    size(900, 600);
    //fullScreen(2);
    
    // fft init
    fft = new FFT(this, bands);
    in = new AudioIn(this, 0);
    in.start();
    fft.input(in);
    
    // particles init
    ps = new ParticleSystem(new PVector(width/2, height/2));
}


void draw() {
    background(255);
    fft.analyze(spectrum);
    
    // FFT visual
    //for(int i = 0; i < bands; i++) {
    //    line(i, height, i, height - spectrum[i]*height*5);
    //}
    
    ps.addParticle();
    ps.run();
    
    println(ps.particles.size());
}

void mouseMoved() {
    ps.setPosition(new PVector(mouseX, mouseY));
}
