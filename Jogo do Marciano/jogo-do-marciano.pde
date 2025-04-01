// Declaração de variáveis globais
int arvoreMarciano;             
int tentativas;                 
String mensagem = "Tente adivinhar a árvore (1-100)"; 
boolean jogoAtivo = true;       // Estado do jogo (ativo ou finalizado)
String entrada = "";            // Armazena os números digitados pelo jogador
int melhorPontuacao = Integer.MAX_VALUE; 
PFont fonteModern;             

// Variáveis para o céu estrelado
int numEstrelas = 200;         
PVector[] estrelas = new PVector[numEstrelas]; // Vetor que armazenará as posições das estrelas

void setup() {
  // Aumenta a largura da tela para 600 (mantendo 300 de altura)
  size(600, 300);
  
  // Carrega uma fonte moderna (Verdana) e define seu tamanho
  fonteModern = createFont("Verdana", 50);
  textFont(fonteModern);
  
  // Inicializa as posições das estrelas de forma aleatória
  for (int i = 0; i < numEstrelas; i++) {
    float x = random(width);
    float y = random(height);
    estrelas[i] = new PVector(x, y);
  }
  
  iniciarJogo(); // Inicializa o jogo
}

void draw() {
 
  background(10, 10, 40);
  
  // Desenha as estrelas
  fill(255);
  noStroke();
  for (int i = 0; i < numEstrelas; i++) {
    ellipse(estrelas[i].x, estrelas[i].y, 2, 2);
  }
  
  // Define a cor e alinhamento do texto
  fill(255);
  textAlign(CENTER);
  
  // Exibe a mensagem principal
  textSize(20);
  text(mensagem, width/2, height/2 - 40);
    
  // Exibe o número de tentativas
  textSize(16);
  text("Tentativas: " + tentativas, width/2, height/2);
  
  // Se o jogo estiver finalizado, exibe instruções para reiniciar e a melhor pontuação
  if (!jogoAtivo) {
    textSize(18);
    text("Pressione 'F' para jogar novamente", width/2, height/2 + 40);
    text("Melhor pontuação: " + (melhorPontuacao == Integer.MAX_VALUE ? "N/A" : melhorPontuacao), width/2, height/2 + 70);
  }
  
  // Exibe o palpite atual do jogador apenas enquanto o jogo estiver ativo
  if (jogoAtivo) {
    textSize(24);
    text("Seu palpite: " + (entrada.equals("") ? "" : entrada), width/2, height/2 + 100);
  }
}

void keyPressed() {
  // Se o jogo estiver ativo e o usuário digitar números, adiciona à entrada
  if (key >= '0' && key <= '9' && jogoAtivo) {
    entrada += key;
  }
  
  // Quando ENTER for pressionado, verifica se há entrada e valida o palpite
  if (key == ENTER && jogoAtivo && entrada.length() > 0) {
    int palpite = int(entrada); 
    verificarPalpite(palpite);   
    entrada = "";                
  }
  
  // Permite reiniciar o jogo pressionando 'F' quando o jogo estiver finalizado
  if ((key == 'f' || key == 'F') && !jogoAtivo) {
    iniciarJogo();
  }
  
  // Permite apagar o último dígito digitado com BACKSPACE
  if (key == BACKSPACE && entrada.length() > 0) {
    entrada = entrada.substring(0, entrada.length() - 1);
  }
}

// Função que inicia ou reinicia o jogo
void iniciarJogo() {
  arvoreMarciano = int(random(1, 101)); 
  tentativas = 0;                        
  mensagem = "Tente achar o ET Bilu (1-100)"; 
  jogoAtivo = true;                     
  entrada = "";                          
}

// Função que verifica se o palpite do jogador está correto
void verificarPalpite(int palpite) {
  // Valida se o número está entre 1 e 100
  if (palpite < 1 || palpite > 100) {
    mensagem = "Número inválido! Digite um número entre 1 e 100.";
    return;
  }
  
  tentativas++; // Incrementa o número de tentativas
  
  // Verifica se o palpite é menor, maior ou igual ao número sorteado
  if (palpite < arvoreMarciano) {
    mensagem = "O Bilu está em uma árvore maior!";
  } else if (palpite > arvoreMarciano) {
    mensagem = "O Bilu está em uma árvore menor!";
  } else {
    mensagem = "Parabéns! Você encontrou ET Bilu em " + tentativas + " tentativas!";
    jogoAtivo = false;
    // Atualiza a melhor pontuação se o atual for menor
    if (tentativas < melhorPontuacao) {
      melhorPontuacao = tentativas;
    }
  }
}
