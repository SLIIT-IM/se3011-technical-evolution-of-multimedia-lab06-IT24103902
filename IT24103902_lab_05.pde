//state
int state = 0;

 //time
int startTime;
int duration = 30;


//player
//--position

float px = 350;
float py = 280;
//--speed
float vx = 0;
float vy = 0;

float accel = 0.6;
float friction = 0.9;

float gravity = 0.6;
float jumpForce = -12;


//--size
float pR = 20;

//--ball y
float groundY = 300;


int lives = 3;


boolean canHit = true;
int lastHitTime = 0;
int hitCooldownMs = 800;


int n = 8;
//enemy
//--position
float[] ex = new float[n];
float[] ey = new float[n];
//--velocities
float[] evx = new float[n];
float[] evy = new float[n];
//--size
float eR = 15;

//----------------setup
void setup() {
  size(700, 350);
  frameRate(60);

  resetGame();
}

// -----------------reset
void resetGame() {

  px = 350;
  py = 280;

  vx = 0;
  vy = 0;

  lives = 3;

  for (int i = 0; i < n; i++) {

    ex[i] = random(eR, width - eR);
    ey[i] = random(eR, height - eR);

    evx[i] = random(-3, 3);
    evy[i] = random(-3, 3);

    if (abs(evx[i]) < 1) evx[i] = 2;
    if (abs(evy[i]) < 1) evy[i] = -2;
  }
}

// ---------------- draw
void draw() {

  background(255);

  // start
  if (state == 0) {

    textAlign(CENTER);
    textSize(32);
    fill(0);
    text("DODGE & SURVIVE", width/2, 120);

    textSize(18);
    text("Press ENTER to Start", width/2, 180);

  }

  // play
  else if (state == 1) {

    updatePlayer();
    updateEnemies();
    checkCollision();

    drawPlayer();
    drawEnemies();

    drawUI();

    // Time count
    int elapsed = (millis() - startTime) / 1000;

    if (elapsed >= duration) {
      state = 3;
    }
  }

  //over
  else if (state == 2) {

    textAlign(CENTER);
    textSize(32);
    fill(255, 0, 0);
    text("GAME OVER", width/2, 150);

    textSize(18);
    fill(0);
    text("Press R to Restart", width/2, 200);
  }

  //win
  else if (state == 3) {

    textAlign(CENTER);
    textSize(32);
    fill(0, 255, 0);
    text("YOU WIN", width/2, 150);

    textSize(18);
    fill(0);
    text("Press R to Restart", width/2, 200);
  }
}

// -------------updatePlayer
void updatePlayer() {

  // left right movement

  if (keyPressed) {
    if (keyCode == RIGHT) vx += accel;
    if (keyCode == LEFT) vx -= accel;
  }


  vx *= friction;

  
  vy += gravity;

  
  px += vx;
  py += vy;

  if (py > groundY) {
    py = groundY;
    vy = 0;
  }

  // in the inside screen
  px = constrain(px, pR, width - pR);
}

// ---------------- drawPlayer
void drawPlayer() {

  noStroke();
  fill(0, 0, 255);
  ellipse(px, py, pR*2, pR*2);
}

// ---------------- updateEnemies
void updateEnemies() {

  for (int i = 0; i < n; i++) {

    ex[i] += evx[i];
    ey[i] += evy[i];

    if (ex[i] > width - eR || ex[i] < eR) {
      evx[i] *= -1;
    }

    if (ey[i] > height - eR || ey[i] < eR) {
      evy[i] *= -1;
    }
  }
}

// ---------------- drawEnemies
void drawEnemies() {

  fill(255, 0, 0);

  for (int i = 0; i < n; i++) {
    ellipse(ex[i], ey[i], eR*2, eR*2);
  }
}

// ----------------  checkCollision
void checkCollision() {

  if (!canHit && millis() - lastHitTime > hitCooldownMs) {
    canHit = true;
  }

  for (int i = 0; i < n; i++) {

    float d = dist(px, py, ex[i], ey[i]);

    if (d < pR + eR && canHit) {

      lives--;

      lastHitTime = millis();
      canHit = false;

      if (lives <= 0) {
        state = 2;
      }
    }
  }
}

// ----------------drawUI
void drawUI() {
  
  

  fill(0);
  textAlign(LEFT);
  textSize(16);

  int elapsed = (millis() - startTime) / 1000;

  text("Lives: " + lives, 20, 25);
  text("Time: " + (30 - elapsed) , 20, 45);
  
 
}

// ---------------- keyPressed
void keyPressed() {

  // start
  if (state == 0 && keyCode == ENTER) {

    startTime = millis();
    state = 1;
  }

  // jump
  if (state == 1 && key == ' ' && py == groundY) {
    vy = jumpForce;
  }

  // reset
  if ((state == 2 || state == 3) && (key == 'r' || key == 'R')) {

    resetGame();
    state = 0;
  }
}
