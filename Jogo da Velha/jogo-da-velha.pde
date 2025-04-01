// Declaração das variáveis principais do jogo
int[][] board = new int[3][3];       // Tabuleiro 3x3 para o jogo da velha
boolean playerTurn = true;           // Indica de quem é a vez (true = Jogador 1, false = Jogador 2/AI)
boolean gameOver = false;            // Estado do jogo: false = em andamento, true = finalizado
boolean vsAI = true;                 // Modo de jogo: true = jogar contra a AI, false = 1 vs 1
int gameState = 0;                   // Estado do jogo: 0 = Menu, 1 = Jogando
int winner = 0;                      // Vencedor: 0 = nenhum, 1 = Jogador 1, 2 = Jogador 2/AI, 3 = Empate

// Declaração dos botões para o menu
Botao btn1vs1, btnVsAI;
PFont font;                          // Fonte utilizada no jogo

// Função setup: configura o ambiente do jogo
void setup() {
  size(600, 600);                   // Define o tamanho da janela
  font = createFont("Arial Bold", 32);  
  textFont(font);
  textAlign(CENTER, CENTER);
  criarBotoes();                   
  resetGame();                      
}

// Função para criar os botões do menu
void criarBotoes() {
  btn1vs1 = new Botao(width/2 - 120, height/2 - 60, 240, 60, "1 vs 1"); // Botão para jogo 1 vs 1
  btnVsAI = new Botao(width/2 - 120, height/2 + 40, 240, 60, "vs Computador"); // Botão para jogar contra a AI
}

// Função draw: executada em loop para atualizar a tela
void draw() {
  background(150);                  // Fundo cinza

  // Verifica se estamos no menu ou no jogo
  if(gameState == 0) {
    desenhaMenu();                  // Exibe o menu principal
  } 
  else {
    desenhaBoard();                 // Desenha o tabuleiro e as jogadas
    checkWinner();                  // Verifica se há um vencedor ou empate

    // Se for a vez da AI e o jogo não estiver acabado, faz a jogada da AI
    if (!playerTurn && vsAI && !gameOver) {
      aiMove();
      playerTurn = true;            // Retorna a vez para o jogador após a jogada da AI
    }

    // Se o jogo acabou, exibe o resultado
    if(gameOver) {
      desenhaResultado();
    }
  }
}

// Função para desenhar o menu principal
void desenhaMenu() {
  fill(255);
  textSize(48);
  text("Jogo da Velha", width/2, height/4); // Título do jogo
  btn1vs1.desenha();              // Desenha o botão 1 vs 1
  btnVsAI.desenha();              // Desenha o botão vs Computador
}

// Função para desenhar a tela de resultado do jogo
void desenhaResultado() {
  fill(255, 230);
  rectMode(CENTER);
  rect(width/2, height/2, 500, 200, 20); // Caixa para exibir o resultado

  fill(0);
  textSize(36);
  String mensagem = "";
  if(winner == 3) {
    mensagem = "Empate!";
  } else {
    // Define a mensagem com base no vencedor e no modo de jogo
    mensagem = "Vencedor:\n" + (winner == 1 ? "Jogador 1 (X)" : vsAI ? "Computador (O)" : "Jogador 2 (O)");
  }
  text(mensagem, width/2, height/2 - 20);
  textSize(24);
  fill(100);
  text("Clique para voltar ao menu", width/2, height/2 + 50); // Instrução para retornar ao menu
}

// Função para tratar o clique do mouse
void mousePressed() {
  if(gameState == 0) {
    // No menu, verifica se um dos botões foi clicado para iniciar o jogo
    if(btn1vs1.clicado(mouseX, mouseY)) {
      vsAI = false;
      iniciarJogo();
    }
    if(btnVsAI.clicado(mouseX, mouseY)) {
      vsAI = true;
      iniciarJogo();
    }
  }
  else if (gameOver) {
    // Se o jogo acabou, volta para o menu ao clicar
    resetGame();
  }
  else if (gameState == 1) {
    // Durante o jogo, determina qual célula foi clicada e faz a jogada
    int col = mouseX / (width / 3);
    int row = mouseY / (height / 3);

    if (board[row][col] == 0) {
      board[row][col] = playerTurn ? 1 : 2; // Marca com 1 (Jogador 1) ou 2 (Jogador 2/AI)
      playerTurn = !playerTurn;             // Alterna a vez do jogador
    }
  }
}

// Função para iniciar o jogo a partir do menu
void iniciarJogo() {
  gameState = 1;                    // Muda o estado para "Jogando"
  resetBoard();                     // Reseta o tabuleiro para uma nova partida
}

// Função para resetar o jogo e voltar ao menu
void resetGame() {
  resetBoard();                     // Reseta o tabuleiro
  gameState = 0;                    // Volta para o estado do menu
}

// Função para resetar o tabuleiro do jogo
void resetBoard() {
  for (int row = 0; row < 3; row++) {
    for (int col = 0; col < 3; col++) {
      board[row][col] = 0;          // Define todas as células como vazias (0)
    }
  }
  gameOver = false;
  playerTurn = true;
  winner = 0;
}

// Função para desenhar o tabuleiro e as jogadas realizadas
void desenhaBoard() {
  stroke(255);                      // Cor branca para as linhas do tabuleiro
  strokeWeight(4);
  // Desenha as linhas verticais e horizontais do tabuleiro
  for (int i = 1; i < 3; i++) {
    line(i * width / 3, 0, i * width / 3, height);
    line(0, i * height / 3, width, i * height / 3);
  }

  // Desenha os símbolos (X e O) em cada célula, conforme o valor da matriz
  for (int row = 0; row < 3; row++) {
    for (int col = 0; col < 3; col++) {
      int x = col * width / 3 + width / 6;
      int y = row * height / 3 + height / 6;
      if (board[row][col] == 1) {
        stroke(255, 0, 0);          // Vermelho para o Jogador 1 (X)
        strokeWeight(6);
        line(x - 30, y - 30, x + 30, y + 30);
        line(x + 30, y - 30, x - 30, y + 30);
      } else if (board[row][col] == 2) {
        stroke(0, 0, 255);          // Azul para o Jogador 2 ou AI (O)
        strokeWeight(6);
        noFill();
        ellipse(x, y, 60, 60);
      }
    }
  }
}

// Função para verificar se há um vencedor ou empate após cada jogada
void checkWinner() {
  // Verifica todas as linhas e colunas
  for (int i = 0; i < 3; i++) {
    if (board[i][0] != 0 && board[i][0] == board[i][1] && board[i][1] == board[i][2]) {
      gameOver = true;
      winner = board[i][0];
    }
    if (board[0][i] != 0 && board[0][i] == board[1][i] && board[1][i] == board[2][i]) {
      gameOver = true;
      winner = board[0][i];
    }
  }

  // Verifica as diagonais
  if (board[0][0] != 0 && board[0][0] == board[1][1] && board[1][1] == board[2][2]) {
    gameOver = true;
    winner = board[0][0];
  }
  if (board[0][2] != 0 && board[0][2] == board[1][1] && board[1][1] == board[2][0]) {
    gameOver = true;
    winner = board[0][2];
  }

  // Verifica se há empate (todas as células preenchidas sem vencedor)
  boolean tie = true;
  for (int row = 0; row < 3; row++) {
    for (int col = 0; col < 3; col++) {
      if (board[row][col] == 0) tie = false;
    }
  }
  if (tie && !gameOver) {
    gameOver = true;
    winner = 3;
  }
}

// Função que realiza a jogada da AI usando o algoritmo Minimax
void aiMove() {
  int bestScore = -1000;
  int bestRow = -1;
  int bestCol = -1;

  // Percorre todas as células do tabuleiro
  for (int row = 0; row < 3; row++) {
    for (int col = 0; col < 3; col++) {
      if (board[row][col] == 0) {       // Se a célula estiver vazia
        board[row][col] = 2;            // Simula uma jogada da AI
        int score = minimax(board, 0, false); // Calcula a pontuação usando o minimax
        board[row][col] = 0;            // Desfaz a jogada simulada

        // Se a jogada tiver a melhor pontuação, atualiza as melhores posições
        if (score > bestScore) {
          bestScore = score;
          bestRow = row;
          bestCol = col;
        }
      }
    }
  }
  board[bestRow][bestCol] = 2;           // Realiza a melhor jogada encontrada
}

// Algoritmo Minimax para avaliar as jogadas
int minimax(int[][] b, int depth, boolean isMaximizing) {
  if (checkWin(2)) return 10 - depth;    // Se a AI ganhar, retorna pontuação positiva
  if (checkWin(1)) return depth - 10;      // Se o jogador ganhar, retorna pontuação negativa
  if (isBoardFull()) return 0;             // Se o tabuleiro estiver cheio, é empate

  if (isMaximizing) {
    int bestScore = -1000;
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (b[row][col] == 0) {
          b[row][col] = 2;
          int score = minimax(b, depth + 1, false);
          b[row][col] = 0;
          bestScore = max(score, bestScore);
        }
      }
    }
    return bestScore;
  } else {
    int bestScore = 1000;
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        if (b[row][col] == 0) {
          b[row][col] = 1;
          int score = minimax(b, depth + 1, true);
          b[row][col] = 0;
          bestScore = min(score, bestScore);
        }
      }
    }
    return bestScore;
  }
}

// Função para verificar se um determinado jogador venceu
boolean checkWin(int player) {
  for (int i = 0; i < 3; i++) {
    if (board[i][0] == player && board[i][1] == player && board[i][2] == player) return true;
    if (board[0][i] == player && board[1][i] == player && board[2][i] == player) return true;
  }
  if (board[0][0] == player && board[1][1] == player && board[2][2] == player) return true;
  if (board[0][2] == player && board[1][1] == player && board[2][0] == player) return true;
  return false;
}

// Função para verificar se o tabuleiro está completamente preenchido
boolean isBoardFull() {
  for (int row = 0; row < 3; row++) {
    for (int col = 0; col < 3; col++) {
      if (board[row][col] == 0) return false;
    }
  }
  return true;
}

// Classe Botao para criar e manipular os botões do menu
class Botao {
  int x, y, w, h;
  String texto;

  // Construtor da classe Botao
  Botao(int x, int y, int w, int h, String texto) { 
    this.x = x; 
    this.y = y; 
    this.w = w; 
    this.h = h; 
    this.texto = texto; 
  }

  // Método para desenhar o botão na tela
  void desenha() {
    rectMode(CORNER);
    fill(200);
    stroke(255);
    strokeWeight(2);
    rect(x, y, w, h, 15);
    fill(0);
    textSize(28);
    textAlign(CENTER, CENTER);
    text(texto, x + w/2, y + h/2);
  }

  // Método para verificar se o botão foi clicado
  boolean clicado(int mx, int my) { 
    return mx > x && mx < x + w && my > y && my < y + h; 
  }
}
