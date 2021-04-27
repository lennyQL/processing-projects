class Boid {
    PVector pos;
    PVector vel;
    PVector dir;
    PVector acc;
    PVector ppos; // previos position
    float dm = 20; //obj ellipse diamiter
    float range;
    float centerX = width/2;
    float centerY = height/2;
    //PVector v; // Sensed other obj's position vector
    ArrayList<Boid> mates;
    

    /**
    _pos(POSITION x, POSITION y)
    _dir(RADIAN angle, FLOAT power)
    _range(DISTANCE sensor)
    */
    Boid(PVector _pos, PVector _dir, float _range, float _dm) {
        pos = _pos;
        vel = new PVector(cos(_dir.x),sin(_dir.x)).mult(_dir.y);
        dir = _dir;
        range = _range;
        mates = new ArrayList<Boid>();
        acc = new PVector(0,0);
        ppos = pos;
        dm = _dm;
        
    }
    
    void setDirc(float _d) {
        dir.x = _d;
    }
    
    //void setAcc(float _x, float _y) {
    //    acc.set(_x, _y);
    //}

    void update() {
        openMap();
        //boundMap();
        //closeMap();
        //vel.set(cos(dir.x),sin(dir.x)).mult(dir.y);
        // 途中で止まらないように
        // 画面の中心にひきつける
        //float dirc = atan2(mouseY-pos.y, mouseX-pos.x);
        float dirc = atan2(centerY-pos.y, centerX-pos.x);
        acc.set(cos(dirc),sin(dirc));
        acc.mult(0.2);
        // いつもの情報更新
        vel.normalize(); // 方向のみを決めるために速度を正規化
        vel.mult(dir.y); // 速度を改めて決める
        if(vel.x<=1e-3 && vel.y<=1e-3) {
            //vel = PVector.random2D().mult(dir.y);
            //vel.set(cos(dir.x),sin(dir.x)).mult(dir.y);
        }
        // 空間にぐるぐる回転するベクトル
        float agl = atan2(pos.y-centerY, pos.x-centerX);
        vel.add(new PVector(-sin(agl),cos(agl)).mult(0.5));
        //vel.add(acc);
        pos.add(vel);
        mates.clear();
        //moveCamera();
    }

    void show() {
        noFill();
        stroke(0);
        ellipse(pos.x, pos.y, dm, dm);
        float p = 10/2;
        line(pos.x, pos.y, pos.x+p*vel.x, pos.y+p*vel.y);
    }
    
    void addMate(Boid _m) {
        mates.add(_m);
    }

    private float getDist(PVector _v) {
        return dist(pos.x, pos.y, _v.x, _v.y);
    }

    public void showSensorRange() {
        //noFill();
        fill(255,0,0,10);
        stroke(255, 0, 0);
        ellipse(pos.x, pos.y, range*2, range*2);
    }
    
    public void showSensorLine() {
        if(!mates.isEmpty()){
            for(int i=0; i<mates.size(); i++) {
                stroke(255,0,0,200);
                line(pos.x, pos.y, mates.get(i).pos.x, mates.get(i).pos.y);
            }
        }
    }
    
    // main dissue
    void sensor(Boid _mate) {
        PVector v = _mate.pos;
        if (getDist(v) < range) {
            mates.add(_mate);
            
            cohese();
            separate(v);
            align();
            //collide();
        }
    }
    
    // 衝突回避
    void separate(PVector _v) {
        //if(range > getDist(_v)) {
        //    float dirc = -atan2(_v.y-pos.y, _v.x-pos.x);
        //    vel.add(cos(dirc),sin(dirc)).mult(1);
        //}
        PVector s = new PVector(0,0);
        //if(!mates.isEmpty()){
            for(int i=0; i<mates.size(); i++) {
                if(dm*8 > getDist(mates.get(i).pos)) {
                    s.add(mates.get(i).pos);
                }
            }
            s.add(pos);
            s.div(mates.size()+1);
        //}
        float dirc = atan2(s.y-pos.y, s.x-pos.x);
        vel.sub(s.set(cos(dirc),sin(dirc)).mult(dir.y).normalize()).mult(1);
        //float dirc = -atan2(s.y-pos.y, s.x-pos.x);
        //vel.set(s.set(cos(dirc),sin(dirc)).mult(dir.y).normalize()).mult(1);
    }
    
    // 進路一致
    void align() {
        //setDirc(atan2(_v.y-pos.y, _v.x-pos.x));
        PVector v = new PVector(0,0);
        if(!mates.isEmpty()){
            for(int i=0; i<mates.size(); i++) {
                v.add(mates.get(i).vel);
            }
            v.normalize();
        }
        vel.add(v.mult(1));
    }
    
    // 凝縮
    void cohese() {
        PVector s = new PVector(0,0);
        if(!mates.isEmpty()){
            for(int i=0; i<mates.size(); i++) {
                s.add(mates.get(i).pos);
            }
            s.add(pos);
            s.div(mates.size()+1);
        }
        float dirc = atan2(s.y-pos.y, s.x-pos.x);
        vel.add(new PVector(cos(dirc),sin(dirc)).mult(dir.y).normalize());
    }
    
    //衝突
    void collide() {
        if(!mates.isEmpty()){
            for(int i=0; i<mates.size(); i++) {
                if(dm > getDist(mates.get(i).pos)) {
                    float dirc = -atan2(mates.get(i).pos.y-pos.y, mates.get(i).pos.x-pos.x);
                    vel.add(new PVector(cos(dirc),sin(dirc)).mult(dir.y));
                }
            }
        }
    }
    
    float x = centerX;
    float y = centerY;
    void moveCamera() {
        float R = 100;
        float S = 5;
        if(mousePressed) {
        if(mouseX < centerX-R) {
            pos.x += S;
            x+=S;
        }
        else if(mouseX > centerX+R) {
            pos.x -= S;
            x-=S;
        }
        if(mouseY < centerY-R) {
            pos.y += S;
            y+=S;
        }
        else if(mouseY > centerY+R) {
            pos.y -= 5;
            y-=S;
        }
        }
        noFill();
        stroke(0,1);
        ellipse(centerX,centerY,R,R);
        stroke(0);
        line(x-10,y,x+10,y);
        line(x,y-10,x,y+10);
    }
    
    // 下から上，左から右，ドラクエマップ方式
    private void openMap() {
        // about X position
        if (pos.x < -dm) {
            pos.x = width + pos.x + dm;
        } else if (pos.x > width + dm) {
            pos.x = pos.x - width - dm;
        }
        // about Y position
        if (pos.y < -dm) {
            pos.y = height + pos.y + dm;
        } else if (pos.y > height + dm) {
            pos.y = pos.y - height - dm;
        }
    }
    
    // 画面外からからそのまま帰ってくる
    private void boundMap() {
        float dirc = atan2(height/2-pos.y, width/2-pos.x);
        // about X position
        if (pos.x < -100 || pos.x > width + 100) {
            //vel.x *= -1;
            vel.set(cos(dirc),sin(dirc));
        } 
        // about Y position
        else if (pos.y < -100 || pos.y > height + 100) {
            //pos.y *= -1;
            vel.set(cos(dirc),sin(dirc));
        }
        else {
            //acc.set(0,0);
        }
    }
    
    // 画面から出ない
    private void closeMap() {
        // about X position
        if (pos.x < dm/2) {
            pos.x = dm/2;
        } else if (pos.x > width - dm/2) {
            pos.x = width - dm/2;
        }
        // about Y position
        if (pos.y < dm/2) {
            pos.y = dm/2;
        } else if (pos.y > height - dm/2) {
            pos.y = height - dm/2;
        }
    }
    
};
