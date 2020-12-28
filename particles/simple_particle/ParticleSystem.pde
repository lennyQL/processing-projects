// discribe a group of particles

class ParticleSystem {
    ArrayList<Particle> particles;
    PVector origin;
    
    ParticleSystem(PVector position) {
        origin = position.copy();
        particles = new ArrayList<Particle>();
    }
    
    void addParticle() {
        particles.add(new Particle(origin));
    }
    
    void run() {
        for (int i = 0; i < particles.size(); i++) {
            Particle p = particles.get(i);
            p.run();
            if (p.isDead()) {
                particles.remove(i);
            }
        }
    }
}
