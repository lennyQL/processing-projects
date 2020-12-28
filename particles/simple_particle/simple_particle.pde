
ParticleSystem ps;

void setup() {
    size(500, 500);
    ps = new ParticleSystem(new PVector(width/2, height/2));
}


void draw() {
    background(255);
    
    ps.addParticle();
    ps.run();
    
    println(ps.particles.size());
}
