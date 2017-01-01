//Uses Guido, by Florian Jenett
//Sketch > Import library > Add library > Guido

//UI colors from https://flatuicolors.com/


import de.bezier.guido.*;

String[] palabrasLemario;
String[] filteredWords;

Alphabet a;

SimpleButton sbGenerate, sbIncWL, sbDecWL;

int wordLength = 6;

void setup() {

  size(600, 800);
  pixelDensity(2);
  background(#ecf0f1);
  fill(0);
  //So the first time there is no delay when writing the words
  textSize(32);
  textSize(14);

  palabrasLemario = loadStrings("lemario-general-del-espanol.txt");
  palabrasLemario = sort(palabrasLemario);

  a = new Alphabet();
  a.setCanWrite("inmulhtraocebdpqfj");
  a.setShouldPractice("fj");

  Interactive.make(this);
  sbDecWL = new SimpleButton (20, 20, 40, 40, "dec");
  sbIncWL = new SimpleButton (180, 20, 40, 40, "inc");
  sbGenerate = new SimpleButton(20, 80, width-40, 40, "gen");
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
  rect(20, 140, width - 40, height-200);
  fill(0);
  textSize(32);
  text(outputText, 35, 150, width - 70, height-160);
  textSize(14);
  text(filteredWords.length + " palabras encontradas", 25, height-40, width - 40, height);
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

    if (!hover && !on) {
      fill(#f1c40f);
    } else if (hover && !on) {
      fill(#f39c12);
    } else if (on) {
      fill(#d35400);
    }

    noStroke();

    rect(x, y, width, height);
  }
}