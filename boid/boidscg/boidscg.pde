Boid[] boids;
Boid[] trash;
int NUM = 200;
int tNUM = 50;

void setup() {
    size(600, 600);
    boids = new Boid[NUM];
    PVector p = new PVector(width/2,height/2);
    PVector d = new PVector(random(0,2*PI),2);
    boids[0] = new Boid(p, d, 50,3);
    for (int i=1; i<NUM; i++) {
        PVector pos = new PVector(random(0,width),random(0,height));
        PVector dir = new PVector(random(0,2*PI),3);
        boids[i] = new Boid(pos, dir, 50,3);
    }
    trash = new Boid[tNUM];
    for (int i=0; i<tNUM; i++) {
        PVector pos = new PVector(random(0,width),random(0,height));
        PVector dir = new PVector(0,0);
        trash[i] = new Boid(pos, dir, 0, 1);
    }
    
    
}

void draw() {
    background(255);
    
    /*/ //test one search
    //boids[0].pos.set(mouseX,mouseY); //test code
    for (int i=1; i<NUM; i++) {
        boids[0].sensor(boids[i]);
    }
    boids[0].showSensorRange();
    /*/ //All search
    for (int i=0; i<NUM; i++) {
        for (int j=0; j<NUM; j++) {
            if(i==j) continue;
            boids[i].sensor(boids[j]);
        }
        //boids[i].showSensorRange();
        //boids[i].showSensorLine();
    }
    //*/
    //boids[0].setDirc(atan2(mouseY-boids[0].pos.y, mouseX-boids[0].pos.x));
    //boids[0].pos.set(mouseX,mouseY);
    boids[0].showSensorRange();
    boids[0].showSensorLine();
    
    //println(boids[0].pos);
    //println(boids[0].getDist(boids[1].pos));
    //println(cos(PI));
    
    for (int i=0; i<NUM; i++) {
        boids[i].update();
        boids[i].show();
    }
    
    for (int i=0; i<tNUM; i++) {
        trash[i].update();
        trash[i].show();
    }
    
    //translate(mouseX,mouseY);
    
    //float a = atan2(mouseY-height/2, mouseX-width/2);
    //println(degrees(a));
}
