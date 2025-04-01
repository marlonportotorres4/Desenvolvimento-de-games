int gameState = 0;

// Listas de palavras dos temas
String[] paises = {"BRASIL", "ARGENTINA", "CANADA", "ALEMANHA", "JAPAO"};
String[] frutas = {"BANANA", "JAMBRE", "MORANGO", "ABACAXI", "MANGA"};

// Variáveis do jogo
String secretWord; // Palavra secreta selecionada
char[] displayWord; // Palavra oculta (com "_")
int erros = 0; // Contador de erros
final int maxErros = 6; // Número máximo de erros
ArrayList<LetraBotao> letras; // Botões das letras
Botao temaPaises, temaFrutas; // Botões de seleção de tema

void setup() {
  size(800, 600);
  textAlign(CENTER, CENTER);
  textSize(20);
  
  // Inicializa botões do menu
  temaPaises = new Botao(width/2 - 150, height/2 - 25, 120, 50, "Países");
  temaFrutas = new Botao(width/2 + 30, height/2 - 25, 120, 50, "Frutas");
  
  initLetras(); // Inicializa botões de letras
}

void draw() {
  background(50);
  
  // Renderiza a tela de acordo com o estado do jogo
  if(gameState == 0) desenhaMenu();
  else if(gameState == 1) desenhaJogo();
  else if(gameState == 2) desenhaFimJogo();
}

// Desenha a tela inicial
void desenhaMenu() {
  fill(255);
  textSize(32);
  text("Jogo da Forca", width/2, height/4);
  temaPaises.desenha();
  temaFrutas.desenha();
}

// Desenha a tela do jogo
void desenhaJogo() {
  desenhaForca();
  desenhaBoneco(erros);
  
  // Exibe a palavra oculta
  fill(255);
  textSize(36);
  String palavraExibida = "";
  for (char c : displayWord) palavraExibida += c + " ";
  text(palavraExibida, width/2, height/3);
  
  // Exibe os botões das letras
  for (LetraBotao lb : letras) lb.desenha();
}

// Tela de fim de jogo
void desenhaFimJogo() {
  fill(255);
  textSize(32);
  text(erros >= maxErros ? "Você perdeu! Palavra: " + secretWord : "Parabéns, você venceu!", width/2, height/3);
  text("Clique para jogar novamente", width/2, height/3 + 50);
}

// Captura cliques do mouse
void mousePressed() {
  if(gameState == 0) { // Menu
    if(temaPaises.clicado(mouseX, mouseY)) iniciaJogo(paises);
    if(temaFrutas.clicado(mouseX, mouseY)) iniciaJogo(frutas);
  } else if(gameState == 1) { // Jogo
    for (LetraBotao lb : letras) {
      if(lb.clicado(mouseX, mouseY) && lb.ativa) {
        lb.ativa = false;
        processaLetra(lb.letra);
        break;
      }
    }
  } else if(gameState == 2) gameState = 0; // Reinicia o jogo
}

// Inicia o jogo com um tema
void iniciaJogo(String[] tema) {
  secretWord = tema[int(random(tema.length))];
  displayWord = new char[secretWord.length()];
  for (int i = 0; i < secretWord.length(); i++) displayWord[i] = '_';
  erros = 0;
  initLetras();
  gameState = 1;
}

// Processa a letra clicada
void processaLetra(char l) {
  boolean acerto = false;
  for (int i = 0; i < secretWord.length(); i++) {
    if(secretWord.charAt(i) == l) {
      displayWord[i] = l;
      acerto = true;
    }
  }
  if(!acerto) erros++;
  if(erros >= maxErros || !new String(displayWord).contains("_")) gameState = 2;
}

// Inicializa os botões das letras
void initLetras() {
  letras = new ArrayList<LetraBotao>();
  int x = 100, y = height - 120, w = 40, h = 40, esp = 10, cols = 13;
  for (int i = 0; i < 26; i++) letras.add(new LetraBotao(x + (i % cols) * (w + esp), y + (i / cols) * (h + esp), w, h, (char)('A' + i)));
}

// Desenha a estrutura da forca
void desenhaForca() {
  stroke(255);
  strokeWeight(4);
  line(50, height - 50, 150, height - 50);
  line(100, height - 50, 100, height/4);
  line(100, height/4, 200, height/4);
  line(200, height/4, 200, height/4 + 30);
}

// Desenha o boneco na forca conforme os erros
void desenhaBoneco(int erros) {
  stroke(255);
  if(erros > 0) ellipse(200, height/4 + 50, 40, 40); // Cabeça
  if(erros > 1) line(200, height/4 + 70, 200, height/4 + 130); // Corpo
  if(erros > 2) line(200, height/4 + 80, 170, height/4 + 100); // Braço esquerdo
  if(erros > 3) line(200, height/4 + 80, 230, height/4 + 100); // Braço direito
  if(erros > 4) line(200, height/4 + 130, 170, height/4 + 170); // Perna esquerda
  if(erros > 5) line(200, height/4 + 130, 230, height/4 + 170); // Perna direita
}

// Classe para botões de letras
class LetraBotao {
  int x, y, w, h;
  char letra;
  boolean ativa = true;
  LetraBotao(int x, int y, int w, int h, char letra) { this.x = x; this.y = y; this.w = w; this.h = h; this.letra = letra; }
  void desenha() {
    fill(ativa ? 200 : 100);
    stroke(255);
    rect(x, y, w, h);
    fill(0);
    text(letra, x + w/2, y + h/2);
  }
  boolean clicado(int mx, int my) { return mx > x && mx < x + w && my > y && my < y + h; }
}

// Classe para botões de menu
class Botao {
  int x, y, w, h;
  String texto;
  Botao(int x, int y, int w, int h, String texto) { this.x = x; this.y = y; this.w = w; this.h = h; this.texto = texto; }
  void desenha() {
    fill(200);
    stroke(255);
    rect(x, y, w, h, 7);
    fill(0);
    text(texto, x + w/2, y + h/2);
  }
  boolean clicado(int mx, int my) { return mx > x && mx < x + w && my > y && my < y + h; }
}