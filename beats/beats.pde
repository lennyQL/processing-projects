float d = 20; // beat diameter
float fd = 10; // fast wave diameter
float sd = //low wave diameter

void setup() {
    size(500,500);
}

void draw() {
    //background(255);
    pushStyle();
    noStroke();
    fill(255, 50);
    rect(0,0,width,height);
    popStyle();
    
    fill(255,50);
    strokeWeight(2);
    ellipse(mouseX, mouseY, d,d);   
    
    d += 7;
    if (d > 250) {
        d = 20;
    }
    
    /* 2 wave */
    fill(150,150,255);
    ellipse(width/2, height/2, sd, sd);
    fill(255);
    ellipse(width/2, height/2, fd, fd);
    
    sd += 1;
    fd += 2;
    if(sd < fd) {
        sd = 100;
        fd = 10;
    }
    
    
}
