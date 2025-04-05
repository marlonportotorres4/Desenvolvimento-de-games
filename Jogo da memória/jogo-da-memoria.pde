// JOGO DA MEMÓRIA EM PROCESSING

// ===== CONFIGURAÇÕES DO JOGO =====
final int ROWS = 4, COLS = 4;             
final int CARD_WIDTH = 100, CARD_HEIGHT = 100; 
final int SPACING = 10;                   

// Vetor de cartas e imagens
Card[] cards = new Card[ROWS * COLS];
PImage backImage;                        
PImage[] frontImages;                     // Vetor com as imagens das cartas (pares)

// ===== CONTROLE DO JOGO =====
Card firstSelected = null, secondSelected = null; // Cartas selecionadas
boolean canClick = true;                  // Controla se o jogador pode clicar nas cartas

// ===== TEMPORIZADOR E RECORDE =====
final int INITIAL_TIME = 180;             // Tempo inicial em segundos (3 minutos)
int startTime, totalTime = INITIAL_TIME;    // Tempo do jogo (em millis) e total (pode ser alterado)
int bestRecord = 0;                       // Recorde do usuário (tempo restante máximo ao vencer)

// ===== CONTROLE DA CHECAGEM DAS CARTAS =====
int checkDelay = 1000, checkStartTime = 0;  // Delay para exibir as cartas antes de virar de novo

// ===== CENTRALIZAÇÃO DO TABULEIRO =====
int boardWidth, boardHeight, offsetX, offsetY;

// ===== ESTADOS DO JOGO E POSIÇÃO DOS BOTÕES =====
boolean initialScreen = true;             
boolean gameWon = false, gameOver = false;  // Estados de vitória ou tempo esgotado
int buttonX, buttonY, buttonW = 120, buttonH = 40;      // Botão de reiniciar (usado após vitória/tempo)
int startButtonX, startButtonY, startButtonW = 120, startButtonH = 40; // Botão "Começar" na tela inicial

// ===== CONFIGURAÇÃO INICIAL =====
void setup() {
  size(600, 600);
  surface.setTitle("Jogo da Memória - Exemplo");
  
  // Carrega as imagens
  backImage = loadImage("back.png");
  frontImages = new PImage[8];
  for (int i = 0; i < 8; i++) {
    frontImages[i] = loadImage("card" + (i+1) + ".png");
  }
  
  // Calcula dimensões do tabuleiro e posicionamento centralizado
  boardWidth = SPACING + COLS * (CARD_WIDTH + SPACING);
  boardHeight = SPACING + ROWS * (CARD_HEIGHT + SPACING);
  offsetX = (width - boardWidth) / 2;
  offsetY = (height - boardHeight) / 2;
  
  // Define posições dos botões
  buttonX = width / 2 - buttonW / 2;
  buttonY = height / 2 + 40;
  startButtonX = width / 2 - startButtonW / 2;
  startButtonY = height / 2;
  
  createCards();      // Embaralha e cria as cartas
  startTime = millis(); // Registra o tempo de início
  noLoop();           // Inicia com a tela inicial (sem o loop do jogo)
}

// ===== LOOP PRINCIPAL =====
void draw() {
  // Se estiver na tela inicial, exibe a tela de "Começar"
  if (initialScreen) {
    drawInitialScreen();
    return;
  }
  
  background(200, 230, 255);
  
  // Desenha as cartas e a HUD (tempo e recorde)
  for (Card card : cards) {
    card.display();
  }
  drawHUD();
  
  // Checa se é hora de verificar se as cartas formam par
  if (!canClick && millis() - checkStartTime > checkDelay) {
    checkMatch();
  }
  
  // Verifica se todas as cartas foram encontradas
  boolean allMatched = true;
  for (Card card : cards) {
    if (!card.matched) { allMatched = false; break; }
  }
  if (allMatched) {
    gameWon = true;
    // Atualiza recorde se o tempo restante for maior
    int elapsed = (millis() - startTime) / 1000;
    int remaining = max(0, totalTime - elapsed);
    if (remaining > bestRecord) bestRecord = remaining;
    drawEndScreen("Você Ganhou!");
    noLoop();
    return;
  }
  
  // Verifica se o tempo acabou
  int elapsed = (millis() - startTime) / 1000;
  if (elapsed >= totalTime) {
    gameOver = true;
    drawEndScreen("Tempo Esgotado!");
    noLoop();
    return;
  }
}

// ===== FUNÇÕES DE DESENHO =====

// Tela inicial com botão "Começar"
void drawInitialScreen() {
  background(100, 150, 200);
  fill(255);
  textSize(36);
  textAlign(CENTER, CENTER);
  text("Jogo da Memória", width/2, height/2 - 80);
  
  fill(200);
  rect(startButtonX, startButtonY, startButtonW, startButtonH, 7);
  fill(0);
  textSize(20);
  text("Começar", width/2, startButtonY + startButtonH/2);
}

// HUD exibindo tempo restante e recorde
void drawHUD() {
  fill(0);
  textSize(20);
  textAlign(LEFT, TOP);
  int elapsed = (millis() - startTime) / 1000;
  int remaining = max(0, totalTime - elapsed);
  text("Tempo: " + remaining + "s   |   Recorde: " + bestRecord + "s", 10, 10);
}

// Tela de fim (vitória ou tempo esgotado) com botão de reiniciar
void drawEndScreen(String msg) {
  fill(0, 150);
  rect(0, 0, width, height);
  // Define cor da mensagem dependendo do resultado
  fill(msg.equals("Você Ganhou!") ? color(0, 255, 0) : color(255, 0, 0));
  textSize(36);
  textAlign(CENTER, CENTER);
  text(msg, width/2, height/2 - 20);
  
  fill(200);
  rect(buttonX, buttonY, buttonW, buttonH, 7);
  fill(0);
  textSize(20);
  text("Reiniciar", width/2, buttonY + buttonH/2);
}

// ===== CHECAGEM E EVENTOS =====

// Verifica se as cartas selecionadas formam um par
void checkMatch() {
  if (firstSelected != null && secondSelected != null) {
    if (firstSelected.frontImage == secondSelected.frontImage) {
      firstSelected.matched = true;
      secondSelected.matched = true;
    } else {
      firstSelected.flipDown();
      secondSelected.flipDown();
      // Penaliza o jogador retirando 10 segundos do tempo total
      totalTime = max(0, totalTime - 10);
    }
  }
  firstSelected = null;
  secondSelected = null;
  canClick = true;
}

// Evento de clique do mouse
void mousePressed() {
  // Se estiver na tela inicial, verifica clique no botão "Começar"
  if (initialScreen) {
    if (mouseX >= startButtonX && mouseX <= startButtonX + startButtonW &&
        mouseY >= startButtonY && mouseY <= startButtonY + startButtonH) {
      initialScreen = false;
      resetGame();
      loop();  // Inicia o loop do jogo
    }
    return;
  }
  
  // Se o jogo terminou (vitória ou tempo esgotado), verifica clique no botão "Reiniciar"
  if (gameWon || gameOver) {
    if (mouseX >= buttonX && mouseX <= buttonX + buttonW &&
        mouseY >= buttonY && mouseY <= buttonY + buttonH) {
      resetGame();
    }
    return;
  }
  
  if (!canClick) return;
  
  // Processa o clique nas cartas
  for (Card card : cards) {
    if (!card.matched && card.isMouseOver(mouseX, mouseY)) {
      if (!card.isFaceUp) {
        card.flipUp();
        if (firstSelected == null) {
          firstSelected = card;
        } else if (secondSelected == null) {
          secondSelected = card;
          canClick = false;
          checkStartTime = millis();
        }
      }
      break;
    }
  }
}

// ===== FUNÇÕES AUXILIARES =====

// Cria e embaralha as cartas
void createCards() {
  ArrayList<Integer> indexes = new ArrayList<Integer>();
  for (int i = 0; i < frontImages.length; i++) {
    indexes.add(i);
    indexes.add(i);
  }
  java.util.Collections.shuffle(indexes);
  int index = 0;
  for (int r = 0; r < ROWS; r++) {
    for (int c = 0; c < COLS; c++) {
      float x = offsetX + c * (CARD_WIDTH + SPACING) + SPACING;
      float y = offsetY + r * (CARD_HEIGHT + SPACING) + SPACING;
      int imageIndex = indexes.get(index);
      PImage front = frontImages[imageIndex];
      cards[index] = new Card(x, y, CARD_WIDTH, CARD_HEIGHT, front, backImage);
      index++;
    }
  }
}

// Reinicia o jogo: reinicia cartas, tempo e estados
void resetGame() {
  firstSelected = null;
  secondSelected = null;
  canClick = true;
  gameWon = false;
  gameOver = false;
  createCards();
  totalTime = INITIAL_TIME;
  startTime = millis();
  loop();
}

// ===== CLASSE CARTA =====
class Card {
  float x, y, w, h;
  PImage frontImage, backImage;
  boolean isFaceUp, matched;
  
  Card(float x, float y, float w, float h, PImage front, PImage back) {
    this.x = x; this.y = y;
    this.w = w; this.h = h;
    this.frontImage = front;
    this.backImage = back;
    this.isFaceUp = false;
    this.matched = false;
  }
  
  // Desenha a carta, mostrando a frente ou o verso
  void display() {
    if (matched) {
      tint(255, 100);
      image(frontImage, x, y, w, h);
      noTint();
    } else {
      if (isFaceUp) image(frontImage, x, y, w, h);
      else image(backImage, x, y, w, h);
    }
  }
  
  // Verifica se o mouse está sobre a carta
  boolean isMouseOver(float mx, float my) {
    return (mx > x && mx < x + w && my > y && my < y + h);
  }
  
  // Vira a carta para cima ou para baixo
  void flipUp() { isFaceUp = true; }
  void flipDown() { isFaceUp = false; }
}
