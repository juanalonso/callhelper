//CREDITS:

//Uses Guido, by Florian Jenett   Sketch > Import library > Add library > Guido
//UI colors from https://flatuicolors.com/
//Lemario from https://github.com/olea/lemarios

import de.bezier.guido.*;

final int TEXTSIZE_BIG = 32;
final int TEXTSIZE_MEDIUM = 24;
final int TEXTSIZE_SMALL = 14;

String[] palabrasLemario;
String[] filteredWords;

Alphabet a;

SimpleButton sbGenerate, sbIncWL, sbDecWL;

int wordLength = 7;

void setup() {

  size(600, 800);
  pixelDensity(2);
  background(#ecf0f1);
  fill(0);
  noStroke();
  //So the first time there is no delay when writing the words
  textSize(TEXTSIZE_BIG);
  textSize(TEXTSIZE_MEDIUM);
  textSize(TEXTSIZE_SMALL);
  textAlign(CENTER);

  palabrasLemario = loadStrings("lemario-general-del-espanol.txt");
  palabrasLemario = sort(palabrasLemario);

  a = new Alphabet();
  a.setCanWrite("inñmulhtraocebdpqfjk");
  a.setShouldPractice("k");

  Interactive.make(this);
  sbDecWL = new SimpleButton (20, 60, 40, 40, "dec");
  sbIncWL = new SimpleButton (120, 60, 40, 40, "inc");
  sbGenerate = new SimpleButton(220, 60, width-240, 40, "gen");
  
  for (int f=0; f<27; f++) {
    new SimpleButton (20 + f*21, 20, 15, 20, "a");
  }

  updateWords();
}



void draw() {
}



String[] filtraPalabras(String palabrasLemario[]) {

  ArrayList<String> listaPalabras = new ArrayList();

  String lettersCanWrite = a.getCanWrite();
  String lettersToPractice = a.getShouldPractice();

  for (String word : palabrasLemario) {

    word = word.toLowerCase();

    //If the length doesn't match, we skip the word
    if (wordLength>0 && word.length() != wordLength) {
      continue;
    }

    //If the word is a preffix (xxx-) or a suffix (-xxx) (or an expression, such as 'tabula rasa') we skip the word
    if (match(word, "-|‒| ")!=null) {
      continue;
    }

    //If the word contains a letter we don't know how to write, we skip the word    
    if (match(word, "^[" +lettersCanWrite + "]+$")==null) {
      continue;
    }

    //If the word doesn't contain at least one of the letter we want to practice, we skip the word
    if (lettersToPractice.length()>0 && match(word, "[" + lettersToPractice + "]+")==null) {
      continue;
    }

    //We found a word!!!
    listaPalabras.add(word);
  }

  return sort(listaPalabras.toArray(new String[0]));
}



String[] formateaSalida(String[] palabras) {

  int lineCounter = 0;
  String linea = "";
  ArrayList<String> lineas = new ArrayList();

  for (String word : palabras) {

    if (lineCounter + 1 + word.length() >= 56) {
      lineas.add(linea);
      lineCounter = 0;
      linea = "";
    }

    linea = linea.concat(word).concat(" ");
    lineCounter += 1 + word.length();
  }
  lineas.add(linea);

  return lineas.toArray(new String[0]);
}



void updateWords() {

  filteredWords = filtraPalabras(palabrasLemario);
  saveStrings("lista_palabras.txt", formateaSalida(filteredWords));

  int wordCounter = -1;
  int offset = 0;

  String currentInitial = "";
  String outputText = "";

  for (String word : filteredWords) {

    if (!word.substring(0, 1).equals(currentInitial)) {

      if (wordCounter > 0) {
        outputText += filteredWords[offset + (int)random(0, wordCounter)] + " · ";
        offset += wordCounter;
      } 

      wordCounter = 0;
      currentInitial = word.substring(0, 1);
    }
    wordCounter++;
  }

  if (filteredWords.length>0) {
    outputText += filteredWords[offset + (int)random(0, wordCounter)];
  }

  background(#ecf0f1);
  fill(255);
  rect(20, 180, width - 40, height-240);
  fill(#2c3e50);
  textSize(TEXTSIZE_BIG);
  text("" + wordLength, 60, 60, 60, 40);
  text(outputText, 35, 190, width - 70, height-200);
  textSize(TEXTSIZE_SMALL);
  text(filteredWords.length + " palabra" + (filteredWords.length!=1?"s":""), 25, height-40, width - 40, height);
}

class SimpleButton extends ActiveElement {

  boolean on;
  String ID = "";

  SimpleButton (float x, float y, float w, float h, String _ID) {
    super(x, y, w, h);
    ID = _ID;
  }

  void mousePressed () {
    on = true;
    if (ID == "gen") {
      updateWords();
    } else if (ID == "inc") {
      if (wordLength<20) {
        wordLength++;
        updateWords();
      }
    } else if (ID == "dec") {
      if (wordLength>0) {
        wordLength--;
        updateWords();
      }
    }
  }

  void mouseReleased () {
    on = false;
  }

  void draw () {

    noStroke();

    if (!hover && !on) {
      fill(#f1c40f);
    } else if (hover && !on) {
      fill(#f39c12);
    } else if (on) {
      fill(#d35400);
    }

    rect(x, y, width, height);

    fill(#2c3e50);

    if (ID == "gen") {
      textSize(TEXTSIZE_MEDIUM);
      text("Actualizar lista", x, y+6, width, height);
    } else if (ID == "inc") {
      textSize(TEXTSIZE_BIG);
      text("+", x, y, width, height);
    } else if (ID == "dec") {
      textSize(TEXTSIZE_BIG);
      text("-", x, y, width, height);
    }
  }
}