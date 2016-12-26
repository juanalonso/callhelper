import java.util.TreeMap;
import java.util.Map;
import java.util.Collections;

final String letrasQueNoSeEscribir = "";
final String letrasQueQuieroPracticar = "";
final int longitudPalabra = 7;

int totalPalabras = 0;
ArrayList<String> listaPalabras;
String[] alfabeto;
TreeMap<String, Integer> punterosAlfabeto;

void setup() {

  size(800, 800);
  pixelDensity(2);
  background(255);
  fill(0);
  textSize(36);

  long time = millis();

  listaPalabras = new ArrayList();
  punterosAlfabeto = new TreeMap();
  String palabrasLemario[] = loadStrings("lemario-general-del-espanol.txt");
  
  filtraPalabras(palabrasLemario);
  Collections.sort(listaPalabras);
  saveStrings("lista_palabras.txt", formateaSalida());

  println(listaPalabras.size() + " palabras válidas");
  println(millis()-time + " ms");
  println(punterosAlfabeto);

  int puntero = 0;
  int posicion = 0;
  alfabeto = new String[punterosAlfabeto.size()];
  String outputText = "";
  for (Map.Entry palabrasQueEmpiezanCon : punterosAlfabeto.entrySet()) {

    int palabraAlAzar = puntero + (int)random(0, (Integer)palabrasQueEmpiezanCon.getValue());
    String palabra = listaPalabras.get(palabraAlAzar);
    alfabeto[posicion] = palabra;
    outputText += palabra + " · ";
    puntero += (Integer)palabrasQueEmpiezanCon.getValue();
    posicion++;
  }
  saveStrings("lista_alfabeto.txt", alfabeto);

  text(outputText, 20, 20, width - 40, height-40);

}



void filtraPalabras(String palabrasLemario[]) {

  String ultimaInicial = "";

  for (String palabra : palabrasLemario) {

    palabra = palabra.toLowerCase();

    //If the length doesn't match, we skip the word
    if (longitudPalabra>0 && palabra.length() != longitudPalabra) {
      continue;
    }

    //If the word is a preffix (xxx-) or a suffix (-xxx) (or an expression, such as 'tabula rasa') we skip the word
    if (match(palabra, "-|‒| ")!=null) {
      continue;
    }

    //If the word contains a letter we don't know how to write, we skip the word    
    if (letrasQueNoSeEscribir.length()>0 && match(palabra, "[" +letrasQueNoSeEscribir + "]+")!=null) {
      continue;
    }

    //If the word doesn't contain at least one of the letter we want to practice, we skip the word
    if (letrasQueQuieroPracticar.length()>0 && match(palabra, "[" + letrasQueQuieroPracticar + "]+")==null) {
      continue;
    }

    //We found a word!!!
    listaPalabras.add(palabra);

    if (!palabra.substring(0, 1).equals(ultimaInicial)) {
      ultimaInicial = palabra.substring(0, 1);
      if (punterosAlfabeto.get(ultimaInicial)==null) {
        punterosAlfabeto.put(ultimaInicial, 0);
      }
    }

    punterosAlfabeto.put(ultimaInicial, punterosAlfabeto.get(ultimaInicial)+1);
  }
}


String[] formateaSalida() {

  int lineCounter = 0;
  String linea = "";
  ArrayList<String> lineas = new ArrayList();

  for (String palabra : listaPalabras) {

    if (lineCounter + 1 + palabra.length() >= 56) {
      lineas.add(linea);
      lineCounter = 0;
      linea = "";
    }

    linea = linea.concat(palabra).concat(" ");
    lineCounter += 1 + palabra.length();
  }
  lineas.add(linea);

  return lineas.toArray(new String[0]);
}