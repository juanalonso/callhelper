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
String finalWordList;

Alphabet a;

int wordLength = 7;

void setup() {

  size(600, 730);
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
  new SimpleButton( 20, 60, 40, 40, "-", 0, 1);
  new SimpleButton(120, 60, 40, 40, "+", 0, 1);
  new SimpleButton(220, 60, width-240, 40, "Actualizar lista", 0, 2);

  String fullAlphabet = a.getFullAlphabet();
  for (int f=0; f<fullAlphabet.length(); f++) {
    int status = 0;
    if (a.getShouldPracticeLetter(fullAlphabet.substring(f, f+1))) {
      status = 2;
    } else if (a.getCanWriteLetter(fullAlphabet.substring(f, f+1))) {
      status = 1;
    }
    new SimpleButton (20 + f*21, 20, 15, 20, fullAlphabet.substring(f, f+1), status, 3);
  }

  finalWordList = updateWords();
}



void draw() {
  background(#ecf0f1);
  fill(255);
  noStroke();
  rect(20, 120, width - 40, 550);
  fill(#2c3e50);
  textSize(TEXTSIZE_MEDIUM);
  text("" + wordLength, 62, 66, 60, 40);
  textSize(TEXTSIZE_BIG);
  text(finalWordList, 35, 130, width - 70, height-140);
  textSize(TEXTSIZE_SMALL);
  text(filteredWords.length + " palabra" + (filteredWords.length!=1?"s":""), 25, height-40, width - 40, height);
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



String updateWords() {

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
  
  return outputText;
}



class SimpleButton extends ActiveElement {

  boolean on;
  int type, active;
  String label = "";

  SimpleButton (float x, float y, float w, float h, String _label, int _active, int _type) {
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
        finalWordList = updateWords();
      }
    } else if (type == 1 && label == "+") {
      if (wordLength<23) {
        wordLength++;
        finalWordList = updateWords();
      }
    } else if (type == 2) {
      finalWordList = updateWords();
    } else if (type==3) {
      if (active==0) {
        active = 1;
        a.setCanWriteLetter(label, true);
        a.setShouldPracticeLetter(label, false);
      } else if (active == 1) {
        active = 2;
        a.setCanWriteLetter(label, true);
        a.setShouldPracticeLetter(label, true);
      } else if (active == 2) {
        active = 0;
        a.setCanWriteLetter(label, false);
        a.setShouldPracticeLetter(label, false);
      }
      finalWordList = updateWords();
    }
  }

  void mouseReleased () {
    on = false;
  }

  void draw () {

    noStroke();

    if (type==1 || type==2) {
      if (!hover && !on) {
        fill(#f1c40f);
      } else if (hover && !on) {
        fill(#f39c12);
      } else if (on) {
        fill(#d35400);
      }
    }

    if (type==3) {

      if (active==0) {
        fill(#bdc3c7);
      } else if (active==1) {
        fill(#f1c40f);
      } else if (active==2) {
        fill(#1abc9c);
      }

      if (hover) {
        stroke(#2c3e50);
      } else {
        noStroke();
      }


      if (!hover && !on) {
        noStroke();
      } else if (hover && !on) {
        /*if (active==0) {
         fill(#f1c40f);
         } else if (active==1) {
         fill(#1abc9c);
         } else if (active==2) {
         fill(#bdc3c7);
         }*/
        //stroke(#2c3e50);
      }/* else if (on) {
       if (active==0) {
       fill(#f39c12);
       } else if (active==1) {
       fill(#16a085);
       } else if (active==2) {
       fill(#95a5a6);
       }
       }
       */
    }

    rect(x, y, width, height);

    fill(#2c3e50);

    if (type == 1) {
      textSize(TEXTSIZE_BIG);
      text(label, x, y, width, height);
    } else if (type == 2) {
      textSize(TEXTSIZE_MEDIUM);
      text(label, x, y+6, width, height);
    } else if (type == 3) {
      textSize(TEXTSIZE_SMALL);
      text(label, x, y, width, height);
    }
  }
}