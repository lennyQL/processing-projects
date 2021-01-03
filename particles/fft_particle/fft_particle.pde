import processing.sound.*;

FFT fft;
Amplitude amp;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];

Star st;
ParticleSystem ps;

void setup() {
    size(900, 600);
    //fullScreen(2);
    
    /// sound analysis init
    fft = new FFT(this, bands);
    amp = new Amplitude(this);
    
    in = new AudioIn(this, 0);
    in.start();
    
    fft.input(in);
    amp.input(in);
    
    /// particles init
    st = new Star(new PVector(random(width), random(height)));
    ps = new ParticleSystem(st.position); //width/2, height/2
}


void draw() {
    background(255);
    
    /// FFT visual
    //for(int i = 0; i < bands; i++) {
    //    line(i, height, i, height - spectrum[i]*height*5);
    //}
    
    /// update star and particles position
    st.run();
    ps.setPosition(st.position);
    st.init();
    
    /// update ParticleSystem
    ps.addParticle();
    ps.run();
    
    fftEvent(spectrum, bands);
    
    //println(maxSpectrumIndex(spectrum, bands)); 
    //println(ps.particles.size());
    //println(amp.analyze());
}

// FFT関連のイベントリスナ
void fftEvent(float[] spct, int band) {
    // FFT解析(必須)
    fft.analyze(spct);
    // noize switch
    if (maxSpectrumIndex(spct, band) >= band/2 &&
        amp.analyze() >= 0.03) {
        //println(true);
        moveStar();
    }
}

// particlesの中心を動かす
void moveStar() {
    // starをできるだけ画面中心に動かすように制約
    float px = map(st.position.x, 0, width, 0, 100);
    float py = map(st.position.y, 0, height, 0, 100);
    
    float w = 1;                 // 重み(移動量)
    float vlx = w * px;            // x軸左への移動範囲
    float vrx = w * (100 - px);    // x軸右への移動範囲
    float vly = w * py;            // y軸左への移動範囲
    float vry = w * (100 - py);    // y軸右への移動範囲
    
    PVector velocity = new PVector(random(-vlx, vrx), random(-vly, vry));
    
    // 移動後のクールタイム
    if(st.time < -5 ) {
        st.setVelocity(velocity);
        st.setTime(5);
    }
    
}

// スペクトルが最大の周波数
int maxSpectrumIndex(float[] spct, int band) {
    float maxfft = -1;
    int index = -1;
    for (int i = 0; i < band; i++) {
           if(spct[i] >= maxfft) {
               maxfft = spct[i];
               index = i;
           }
    }
    return index;
}

void mouseMoved() {
    ps.setPosition(new PVector(mouseX, mouseY));
}
