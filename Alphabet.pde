class Alphabet {

  HashMap<String, Letter> alphabet;
  private String canWriteExpanded;
  private String shouldPracticeExpanded;

  Alphabet () {

    canWriteExpanded = "";
    shouldPracticeExpanded = "";

    alphabet = new HashMap<String, Letter>();
    alphabet.put("a", new Letter('a', "á"));
    alphabet.put("b", new Letter('b'));
    alphabet.put("c", new Letter('c'));
    alphabet.put("d", new Letter('d'));
    alphabet.put("e", new Letter('e', "é"));
    alphabet.put("f", new Letter('f'));
    alphabet.put("g", new Letter('g'));
    alphabet.put("h", new Letter('h'));
    alphabet.put("i", new Letter('i', "í"));
    alphabet.put("j", new Letter('j'));
    alphabet.put("k", new Letter('k'));
    alphabet.put("l", new Letter('l'));
    alphabet.put("m", new Letter('m'));
    alphabet.put("n", new Letter('n'));
    alphabet.put("ñ", new Letter('ñ'));
    alphabet.put("o", new Letter('o', "ó"));
    alphabet.put("p", new Letter('p'));
    alphabet.put("q", new Letter('q'));
    alphabet.put("r", new Letter('r'));
    alphabet.put("s", new Letter('s'));
    alphabet.put("t", new Letter('t'));
    alphabet.put("u", new Letter('u', "úü"));
    alphabet.put("v", new Letter('v'));
    alphabet.put("w", new Letter('w'));
    alphabet.put("x", new Letter('x'));
    alphabet.put("y", new Letter('y'));
    alphabet.put("z", new Letter('z'));
  }

  void setCanWrite(String s) {
    for (String key : alphabet.keySet()) {
      alphabet.get(key).setWrite(false);
    }
    canWriteExpanded = "";
    for (int f=0; f<s.length(); f++) {
      Letter l = alphabet.get(s.substring(f, f+1));
      l.setWrite(true);
      canWriteExpanded += s.substring(f, f+1) + l.getAlternates();
    }
  }

  String getCanWrite() {
    return canWriteExpanded;
  }

  void setShouldPractice(String s) {
    for (String key : alphabet.keySet()) {
      alphabet.get(key).setPractice(false);
    }
    shouldPracticeExpanded = "";
    for (int f=0; f<s.length(); f++) {
      Letter l = alphabet.get(s.substring(f, f+1));
      l.setPractice(true);
      shouldPracticeExpanded += s.substring(f, f+1) + l.getAlternates();
    }
  }

  String getShouldPractice() {
    return shouldPracticeExpanded;
  }

  void debug() {
    print("Can write: ");
    for (String key : alphabet.keySet()) {
      if (alphabet.get(key).canWrite()) {
        print(key);
      }
    }
    println();
    println("Can write EXP: " + canWriteExpanded);
    print("Should practice: ");
    for (String key : alphabet.keySet()) {
      if (alphabet.get(key).shouldPractice()) {
        print(key);
      }
    }
    println();
    println("Should practice EXP: " + shouldPracticeExpanded);
  }
}