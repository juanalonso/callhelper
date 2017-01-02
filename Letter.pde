class Letter {

  char letter;
  private String alternates;
  private boolean canWrite;
  private boolean shouldPractice;

  Letter (char c) {
    letter = c;
    alternates = "";
    canWrite = false;
    shouldPractice = false;
  }

  void setWrite(boolean _canWrite) {
    canWrite = _canWrite;
  }

  boolean canWrite() {
    return canWrite;
  }

  void setPractice(boolean _shouldPractice) {
    shouldPractice = _shouldPractice;
  }

  boolean shouldPractice() {
    return shouldPractice;
  }
  
  void setAlternates(String s){
    alternates = s;
  }
  
  String getAlternates () {
    return alternates;
  }

}