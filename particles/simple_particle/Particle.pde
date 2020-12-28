// simple particle class
class Particle {
    PVector position;
    PVector velocity;
    PVector acceleration;
    float lifespan;
    float d; // particle's diameter
    
    Particle(PVector l) {
        acceleration = new PVector(0, 0);
        velocity = new PVector(random(-1, 1), random(-1, 1));
        position = l.copy();
        lifespan = 550;
        d = random(8,20);
    }
    
    void run() {
        update();
        display();
    }
    
    void update() {
        velocity.add(acceleration);
        position.add(velocity);
        lifespan -= 3;
        
    }
    
    void display() {
        //fill(144, 180, 255, lifespan);
        fill(0, lifespan);
        noStroke();
        //stroke(0, lifespan);
        ellipse(position.x, position.y, d, d);
    }
    
    boolean isDead() {
        return lifespan < 0 ? true : false;
    }
}
