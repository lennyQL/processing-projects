///*** 物理演算の継承用クラス ***///
class Mover {
    PVector position;
    PVector velocity;
    PVector acceleration;
    float d; // particle's diameter
    
    Mover(PVector l) {
        acceleration = new PVector(0, 0);
        velocity = new PVector(0, 0);
        position = l.copy();
    }
    
    void run() {
        update();
        display();
    }
    
    void display() {
        pushStyle();
        popStyle();
    }
    
    void update() {
        velocity.add(acceleration);
        position.add(velocity);
    }
}


///*** simple particle class ***///
class Particle extends Mover {
    float lifespan;
    
    Particle(PVector l) {
        super(l); // 親クラスのインスタンス
        
        //*  // 円形
        float rad = random(0, 2*PI);
        velocity = new PVector(cos(rad), sin(rad));//.mult(random(1));
        /*/ // 四角
        velocity = new PVector(random(-1, 1), random(-1, 1));//.mult(random(2));
        //*/
        
        lifespan = 550;
        d = random(4,15); // 8,20
    }
    
    void update() {
        super.update();
        lifespan -= 3;
    }
    
    void display() {
        pushStyle();
        //fill(144, 180, 255, lifespan);
        fill(0, lifespan);
        noStroke();
        //stroke(0, lifespan);
        ellipse(position.x, position.y, d, d);
        popStyle();
    }
    
    boolean isDead() {
        return lifespan < 0 ? true : false;
    }
}


///*** Particles kernel class ***///
class Star extends Mover {
    int time;
    
    Star(PVector l) {
        super(l);
        
        //float rad = random(0, 2*PI);
        //velocity = new PVector(cos(rad), sin(rad)).mult(4);
        //velocity = new PVector(random(-1, 1), random(-1, 1)).mult(4);
        
        time = 0;
    }
    
    void setVelocity(PVector vel) {
        velocity = vel.copy();
    }
    
    void init() {
        if(isTime()) {
            velocity = new PVector(0,0);
        }
    }
    
    void setTime(int t) {
        time = t;
    }
    
    boolean isTime() {
        return time < 0 ? true : false;
    }
    
    void update() {
        super.update();
        bound();
        time--;
    }
    
    void bound() {
        //左右の壁でバウンドさせる
        if (position.x < d / 2 || position.x > width - d / 2) {
          position.x = constrain(position.x, d/2, width - d / 2);
          velocity.x *= -1;
          //acceleration = new PVector(0, random(-0.01, 0.01));
          //velocity.x *= -random(0.5, 1.5);
        }
        //上下の壁でバウンドさせる
        if (position.y < d / 2 || position.y > height - d / 2) {
          position.y = constrain(position.y, d/2, height - d / 2);
          velocity.y *= -1;
          //acceleration = new PVector(random(-0.01, 0.01), 0);
          //velocity.x *= -random(0.5, 1.5);
        }
    }
}
