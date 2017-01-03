class Alphabet {

  HashMap<String, Letter> alphabet;
  private String canWriteExpanded;
  private String shouldPracticeExpanded;
  private String fullAlphabet;

  Alphabet (String _fullAlphabet) {

    canWriteExpanded = "";
    shouldPracticeExpanded = "";
    fullAlphabet = _fullAlphabet;

    alphabet = new HashMap<String, Letter>();

    for (int f=0; f<fullAlphabet.length(); f++) {
      alphabet.put(fullAlphabet.substring(f, f+1), new Letter(fullAlphabet.charAt(f)));
    }
  }

  void setAlternates(String key, String alternates) {
    alphabet.get(key).setAlternates(alternates);
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

  void setCanWriteLetter(String l, boolean w) {
    alphabet.get(l).setWrite(w);
    canWriteExpanded = "";
    for (String key : alphabet.keySet()) {
      Letter lt = alphabet.get(key);
      if (lt.canWrite()) {
        canWriteExpanded += key + lt.getAlternates();
      }
    }
  }

  boolean getCanWriteLetter(String l) {
    return alphabet.get(l).canWrite();
  }

  void setShouldPractice(String s) {
    for (String key : alphabet.keySet()) {
      alphabet.get(key).setPractice(false);
    }
    shouldPracticeExpanded = "";
    for (int f=0; f<s.length(); f++) {
      Letter l = alphabet.get(s.substring(f, f+1));
      if (l.canWrite()) {
        l.setPractice(true);
        shouldPracticeExpanded += s.substring(f, f+1) + l.getAlternates();
      }
    }
  }

  String getShouldPractice() {
    return shouldPracticeExpanded;
  }

  void setShouldPracticeLetter(String l, boolean w) {
    alphabet.get(l).setPractice(w);
    shouldPracticeExpanded = "";
    for (String key : alphabet.keySet()) {
      Letter lt = alphabet.get(key);
      if (lt.shouldPractice()) {
        shouldPracticeExpanded += key + lt.getAlternates();
      }
    }
  }

  boolean getShouldPracticeLetter(String l) {
    return alphabet.get(l).shouldPractice();
  }  

  String getFullAlphabet() {
    return fullAlphabet;
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