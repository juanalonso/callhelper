//CREDITS:

//Uses Guido, by Florian Jenett   Sketch > Import library > Add library > Guido
//UI colors from https://flatuicolors.com/
//Lemario from https://github.com/olea/lemarios

import de.bezier.guido.*;

final int TEXTSIZE_BIG = 27;
final int TEXTSIZE_MEDIUM = 22;
final int TEXTSIZE_SMALL = 14;

String[] palabrasLemario;
String[] filteredWords;

Alphabet a;

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

  a = new Alphabet("abcdefghijklmnñopqrstuvwxyz");
  a.setAlternates("a", "á");
  a.setAlternates("e", "é");
  a.setAlternates("i", "í");
  a.setAlternates("o", "ó");
  a.setAlternates("u", "úü");
  a.setCanWrite("inñmulhtraocebdpqfjksg");
  a.setShouldPractice("g");

  Interactive.make(this);
  new SimpleButton( 20, 90, 40, 40, "-", true, 1);
  new SimpleButton(120, 90, 40, 40, "+", true, 1);
  new SimpleButton(220, 90, width-240, 40, "Actualizar lista", true, 2);

  String fullAlphabet = a.getFullAlphabet();
  for (int f=0; f<fullAlphabet.length(); f++) {
    new SimpleButton (20 + f*21, 20, 15, 20, fullAlphabet.substring(f, f+1), a.getCanWriteLetter(fullAlphabet.substring(f, f+1)), 3);
    new SimpleButton (20 + f*21, 50, 15, 20, fullAlphabet.substring(f, f+1), a.getShouldPracticeLetter(fullAlphabet.substring(f, f+1)), 4);
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
  rect(20, 150, width - 40, height-210);
  fill(#2c3e50);
  textSize(TEXTSIZE_MEDIUM);
  text("" + wordLength, 62, 96, 60, 40);
  textSize(TEXTSIZE_BIG);
  text(outputText, 35, 160, width - 70, height-140);
  textSize(TEXTSIZE_SMALL);
  text(filteredWords.length + " palabra" + (filteredWords.length!=1?"s":""), 25, height-40, width - 40, height);
}

class SimpleButton extends ActiveElement {

  boolean on, active;
  int type;
  String label = "";

  SimpleButton (float x, float y, float w, float h, String _label, boolean _active, int _type) {
    super(x, y, w, h);
    label = _label;
    active = _active;
    type = _type;
  }

  void mousePressed () {

    on = true;

    if (type == 1 && label == "-") {
      if (wordLength>0) {
        wordLength--;
        updateWords();
      }
    } else if (type == 1 && label == "+") {
      if (wordLength<23) {
        wordLength++;
        updateWords();
      }
    } else if (type == 2) {
      updateWords();
    } else if (type==3) {
      active=!active;
      a.setCanWriteLetter(label, active);
      updateWords();
    } else if (type==4 && a.getCanWriteLetter(label)) {
      active=!active;
      a.setShouldPracticeLetter(label, active);
      updateWords();
    }
  }

  void mouseReleased () {
    on = false;
  }

  void draw () {

    noStroke();

    if (!hover && !on) {
      if (active) {
        fill(#f1c40f);
      } else {
        fill(#bdc3c7);
      }
    } else if (hover && !on) {
      fill(#f39c12);
    } else if (on) {
      fill(#d35400);
    }

    if (type!=4 || (type==4 && a.getCanWriteLetter(label))) {
      rect(x, y, width, height);
    }

    fill(#2c3e50);

    if (type == 1) {
      textSize(TEXTSIZE_BIG);
      text(label, x, y, width, height);
    } else if (type == 2) {
      textSize(TEXTSIZE_MEDIUM);
      text(label, x, y+6, width, height);
    } else if (type == 3) {
      textSize(TEXTSIZE_SMALL);
      if (!active) {
        fill(#ecf0f1);
      }
      text(label, x, y, width, height);
    } else if (type == 4) {
      textSize(TEXTSIZE_SMALL);
      if (!active) {
        fill(#ecf0f1);
      }
      if (a.getCanWriteLetter(label)) {
        text(label, x, y, width, height);
      }
    }
  }
}