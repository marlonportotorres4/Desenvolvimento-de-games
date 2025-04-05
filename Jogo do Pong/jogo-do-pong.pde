// Declaração de variáveis globais
Paddle player, ai;
Ball ball;
int scorePlayer = 0, scoreAI = 0;
final int WINNING_SCORE = 3; // Pontuação para vitória
boolean gameOver = false, inMenu = true, ballInPlay = false;
String winner = "", difficulty = "";
float paddleWidth = 100, ballSpeedMultiplier = 1;

void setup() {
  size(1000, 800); // Define o tamanho da tela
  smooth();        // Ativa o suavizador para desenhos
  showMainMenu();  // Exibe o menu principal ao iniciar
}

void draw() {
  background(0);   // Fundo preto para o jogo
  
  // Verifica o estado atual do jogo e chama a função correspondente
  if (inMenu) {
    drawMainMenu();
  } else if (!gameOver) {
    updateGame();
    drawGameElements();
  } else {
    drawGameOver();
  }
}

// Atualiza a lógica do jogo a cada frame
void updateGame() {
  player.update();
  ai.update();
  
  if (ballInPlay) {  // Atualiza a bola e verifica colisões se estiver em jogo
    ball.update();
    moveAI();
    ball.checkCollision(player);
    ball.checkCollision(ai);
  }
  
  checkVictory(); // Verifica se alguém venceu
}

// Lógica de movimentação da IA conforme a dificuldade escolhida
void moveAI() {
  if (difficulty.equals("Difícil")) {
    float targetX = constrain(ball.x, ai.w/2, width - ai.w/2);
    ai.move((targetX - (ai.x + ai.w/2)) * 0.25);
  } else if (difficulty.equals("Moderado")) {
    if (ball.x < ai.x + ai.w/2 - 20) ai.move(-6);
    if (ball.x > ai.x + ai.w/2 + 20) ai.move(6);
  } else { // Fácil
    if (random(1) < 0.6) {
      if (ball.x < ai.x + ai.w/2) ai.move(-5);
      if (ball.x > ai.x + ai.w/2) ai.move(5);
    }
  }
}

// Desenha os elementos do jogo: bola, paddles e placar
void drawGameElements() {
  rectMode(CORNER); // Define que os retângulos serão desenhados a partir do canto superior esquerdo
  
  ball.display();
  player.display();
  ai.display();
  
  // Desenha o placar
  fill(255);
  textSize(32);
  textAlign(LEFT);
  text("Jogador: " + scorePlayer, 20, height - 30);
  textAlign(RIGHT);
  text("Computador: " + scoreAI, width - 20, 50);
  
  // Instrução para iniciar a partida, caso a bola ainda não esteja em jogo
  if (!ballInPlay) {
    textSize(24);
    textAlign(CENTER);
    text("Pressione A ou D para iniciar", width/2, height/2 + 50);
  }
}

// Verifica se a pontuação atingiu o limite para definir o fim de jogo
void checkVictory() {
  if (scorePlayer >= WINNING_SCORE || scoreAI >= WINNING_SCORE) {
    gameOver = true;
    winner = (scorePlayer >= WINNING_SCORE) ? "JOGADOR" : "COMPUTADOR";
  }
}

// Desenha o menu principal com as opções de dificuldade
void drawMainMenu() {
  textAlign(CENTER, CENTER);
  fill(255);
  textSize(48);
  text("PONG - Escolha a Dificuldade", width/2, 100);
  
  // Desenha os botões para cada dificuldade
  drawButton("Fácil", width/2, 250, color(0, 200, 0));
  drawButton("Moderado", width/2, 350, color(200, 200, 0));
  drawButton("Difícil", width/2, 450, color(200, 0, 0));
}

// Função para desenhar um botão com rótulo, posição e cor definidos
void drawButton(String label, float x, float y, color c) {
  fill(c);
  rectMode(CENTER);
  rect(x, y, 200, 60, 10); // Retângulo com bordas arredondadas
  fill(0);
  textSize(24);
  text(label, x, y);
}

// Desenha a tela de Game Over com as opções de reiniciar ou voltar ao menu
void drawGameOver() {
  fill(255);
  textSize(64);
  textAlign(CENTER, CENTER);
  text(winner + " VENCEU!", width/2, height/2);
  textSize(24);
  text("Pressione 'R' para reiniciar ou 'F' para voltar à tela inicial", width/2, height/2 + 50);
}

// Lida com as entradas do teclado
void keyPressed() {
  // Se F for pressionado, retorna ao menu principal e reseta o jogo
  if (key == 'f' || key == 'F') {
    inMenu = true;
    gameOver = false;
    scorePlayer = 0;
    scoreAI = 0;
    difficulty = "";
    showMainMenu();
    return; // Evita outras ações neste frame
  }
  
  // Movimentação do jogador e início da partida
  if (!gameOver && !inMenu) {
    if (key == 'a' || key == 'A') player.startMoving(-1);
    if (key == 'd' || key == 'D') player.startMoving(1);
    if (!ballInPlay && (key == 'a' || key == 'A' || key == 'd' || key == 'D')) {
      ballInPlay = true;
      ball.launch();
    }
  }
  
  // Reinicia o jogo se R for pressionado
  if (key == 'r' || key == 'R') resetGame();
}

// Para a movimentação do jogador quando as teclas são liberadas
void keyReleased() {
  if (key == 'a' || key == 'A' || key == 'd' || key == 'D') {
    player.stopMoving();
  }
}

// Lida com cliques do mouse para selecionar a dificuldade
void mousePressed() {
  if (inMenu) {
    // Verifica as coordenadas do clique para cada botão de dificuldade
    if (mouseY > 220 && mouseY < 280) setDifficulty("Fácil");
    if (mouseY > 320 && mouseY < 380) setDifficulty("Moderado");
    if (mouseY > 420 && mouseY < 480) setDifficulty("Difícil");
  }
}

// Configura a dificuldade selecionada, ajusta parâmetros e recria os paddles
void setDifficulty(String selectedDifficulty) {
  difficulty = selectedDifficulty;
  
  // Ajusta o tamanho dos paddles e a velocidade da bola conforme a dificuldade
  switch(difficulty) {
    case "Fácil":
      paddleWidth = 150;
      ballSpeedMultiplier = 0.8;
      break;
    case "Moderado":
      paddleWidth = 100;
      ballSpeedMultiplier = 1.0;
      break;
    case "Difícil":
      paddleWidth = 70;
      ballSpeedMultiplier = 1.3;
      break;
  }
  
  inMenu = false;
  // Recria os paddles com o novo paddleWidth imediatamente
  player = new Paddle(width/2 - paddleWidth/2, height - 50, paddleWidth, 20);
  ai = new Paddle(width/2 - paddleWidth/2, 30, paddleWidth, 20);
  resetGame();
}

// Exibe o menu principal e inicializa os objetos do jogo
void showMainMenu() {
  player = new Paddle(width/2 - paddleWidth/2, height - 50, paddleWidth, 20);
  ai = new Paddle(width/2 - paddleWidth/2, 30, paddleWidth, 20);
  resetBall();
}

// Reinicia a bola e define que ela não está em jogo
void resetBall() {
  ball = new Ball(width/2, height/2, 30); // Bola com tamanho maior
  ballInPlay = false;
}

// Reinicia os parâmetros do jogo para iniciar uma nova partida
void resetGame() {
  scorePlayer = 0;
  scoreAI = 0;
  gameOver = false;
  resetBall();
}

// Classe que define o comportamento do paddle (barra)
class Paddle {
  float x, y, w, h;
  float velocity;
  float acceleration = 0.8;
  float friction = 0.92;
  int direction = 0;
  
  // Construtor do Paddle
  Paddle(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
  
  // Inicia o movimento na direção especificada (-1 para esquerda, 1 para direita)
  void startMoving(int dir) {
    direction = dir;
  }
  
  // Para o movimento
  void stopMoving() {
    direction = 0;
  }
  
  // Move o paddle garantindo que não ultrapasse os limites da tela
  void move(float speed) {
    x += speed;
    if (x < 0) {
      x = 0;
      velocity = 0;
    } else if (x > width - w) {
      x = width - w;
      velocity = 0;
    }
  }
  
  // Atualiza a posição do paddle com base na velocidade e direção
  void update() {
    velocity += direction * acceleration;
    velocity *= friction;
    x += velocity;
    
    // Garante que o paddle permaneça na tela
    if (x < 0) {
      x = 0;
      velocity = 0;
    } else if (x > width - w) {
      x = width - w;
      velocity = 0;
    }
  }
  
  // Exibe o paddle na tela
  void display() {
    fill(255);
    rectMode(CORNER); // Desenha o retângulo a partir do canto superior esquerdo
    rect(x, y, w, h);
  }
}

// Classe que define o comportamento da bola
class Ball {
  float x, y, size;
  float speedX, speedY;
  float baseSpeed = 3;
  float currentSpeed;
  final float MAX_SPEED = 12;
  PVector prevPos;
  
  // Construtor da bola
  Ball(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
    currentSpeed = baseSpeed * ballSpeedMultiplier;
    prevPos = new PVector(x, y);
    reset();
  }
  
  // Lança a bola em uma direção aleatória com velocidade baseada na dificuldade
  void launch() {
    speedX = random(-1, 1);
    speedY = random(0.5, 1);
    if (random(1) < 0.5) speedY *= -1;
    
    // Normaliza a velocidade para manter a magnitude definida
    float mag = sqrt(speedX * speedX + speedY * speedY);
    speedX = (speedX / mag) * currentSpeed;
    speedY = (speedY / mag) * currentSpeed;
  }
  
  // Reinicia a posição e velocidade da bola
  void reset() {
    x = width/2;
    y = height/2;
    speedX = 0;
    speedY = 0;
    currentSpeed = baseSpeed * ballSpeedMultiplier;
  }
  
  // Atualiza a posição da bola e trata colisões com as bordas
  void update() {
    prevPos.set(x, y);
    x += speedX;
    y += speedY;
    
    // Colisão com as bordas laterais
    if (x < size/2 || x > width - size/2) {
      speedX *= -1;
      x = constrain(x, size/2, width - size/2);
    }
    
    // Verifica se houve pontuação e reseta a bola
    if (y < 0) {
      scorePlayer++;
      resetBall();
    } else if (y > height) {
      scoreAI++;
      resetBall();
    }
  }
  
  // Verifica colisão entre a bola (círculo) e o paddle (retângulo)
  void checkCollision(Paddle p) {
    float closestX = constrain(x, p.x, p.x + p.w);
    float closestY = constrain(y, p.y, p.y + p.h);
    float distance = dist(x, y, closestX, closestY);
    if (distance < size/2) {
      processCollision(p);
    }
  }
  
  // Processa a colisão, reposicionando a bola e ajustando seu ângulo
  void processCollision(Paddle p) {
    // Reposiciona a bola para evitar que fique "dentro" do paddle
    if (p.y > height/2) { 
      // Paddle do jogador (inferior): coloca a bola acima
      y = p.y - size/2;
    } else {  
      // Paddle da IA (superior): coloca a bola abaixo
      y = p.y + p.h + size/2;
    }
    
    // Calcula o ponto de impacto relativo ao centro do paddle (-1 a 1)
    float hitPoint = (x - (p.x + p.w/2)) / (p.w/2);
    hitPoint = constrain(hitPoint, -1, 1);
    
    float maxAngle = radians(75);
    float angle = hitPoint * maxAngle;
    
    // Aumenta a velocidade levemente, respeitando o limite máximo
    currentSpeed = constrain(currentSpeed * 1.1, baseSpeed * ballSpeedMultiplier, MAX_SPEED * ballSpeedMultiplier);
    
    // Define a direção vertical da bola com base na posição do paddle
    if (p.y > height/2) {
      // Se for o paddle do jogador, a bola sobe
      speedY = -abs(currentSpeed * cos(angle));
    } else {
      // Se for o paddle da IA, a bola desce
      speedY = abs(currentSpeed * cos(angle));
    }
    // Ajusta a velocidade horizontal com base no ângulo calculado
    speedX = currentSpeed * sin(angle);
  }
  
  // Exibe a bola na tela
  void display() {
    fill(255);
    ellipse(x, y, size, size);
  }
}
