
ParticleSystem ps;

void setup() {
    size(900, 600);
    //fullScreen(2);
    ps = new ParticleSystem(new PVector(width/2, height/2));
}


void draw() {
    background(255);
    
    ps.addParticle();
    ps.run();
    
    println(ps.particles.size());
}

void mouseMoved() {
    ps.setPosition(new PVector(mouseX, mouseY));
}
