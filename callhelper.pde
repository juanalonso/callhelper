final String letrasQueNoSeEscribir = "qweéryoópsdfgjkñzxcvb";
final String letrasQueQuieroPracticar = "mniuhlta";
final int longitudPalabra = 0;

String[] palabrasLemario;
String[] filteredWords;



void setup() {

  size(600, 800);
  pixelDensity(2);
  background(255);
  fill(0);

  palabrasLemario = loadStrings("lemario-general-del-espanol.txt");
  palabrasLemario = sort(palabrasLemario);
}



void draw() {
}



String[] filtraPalabras(String palabrasLemario[]) {

  ArrayList<String> listaPalabras = new ArrayList();

  for (String word : palabrasLemario) {

    word = word.toLowerCase();

    //If the length doesn't match, we skip the word
    if (longitudPalabra>0 && word.length() != longitudPalabra) {
      continue;
    }

    //If the word is a preffix (xxx-) or a suffix (-xxx) (or an expression, such as 'tabula rasa') we skip the word
    if (match(word, "-|‒| ")!=null) {
      continue;
    }

    //If the word contains a letter we don't know how to write, we skip the word    
    if (letrasQueNoSeEscribir.length()>0 && match(word, "[" +letrasQueNoSeEscribir + "]+")!=null) {
      continue;
    }

    //If the word doesn't contain at least one of the letter we want to practice, we skip the word
    if (letrasQueQuieroPracticar.length()>0 && match(word, "[" + letrasQueQuieroPracticar + "]+")==null) {
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



void mousePressed() {

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

  outputText += filteredWords[offset + (int)random(0, wordCounter)];

  background(255);
  textSize(36);
  text(outputText, 20, 20, width - 40, height-40);
  textSize(14);
  text(filteredWords.length + " palabras encontradas", 20, height-40, width - 40, height);

}