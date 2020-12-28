import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput in;
FFT fft;

void setup() {
  size(1024, 400);
  background(255);

  minim = new Minim(this);
  //textFont(createFont("Calibri-Bold-24", 12));
  in = minim.getLineIn(Minim.STEREO, 512);
  fft = new FFT(in.bufferSize(), in.sampleRate());
  fft.window(FFT.HAMMING);
  stroke(255);
  frameRate(30);
  colorMode(HSB);
  strokeWeight(2);
}

void draw(){
  background(0);

  fft.forward(in.mix);

  for (int i = 0;i < fft.specSize(); i++) {
    float x = map(i, 0, fft.specSize(), 0, width);
    float h = map(i, 0, fft.specSize(), 0, 255);
    stroke(h, 255, 255);
    line(x, height, x, height - fft.getBand(i) * 80); //default *8
  }
}


void stop() {
  minim.stop();
  super.stop();
}
