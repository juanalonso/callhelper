class Letter {

  char letter;
  private String alternates;
  private boolean canWrite;
  private boolean shouldPractice;

  Letter (char c, String a) {
    letter = c;
    alternates = a;
    canWrite = false;
    shouldPractice = false;
  }

  Letter (char c) {
    this(c, "");
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
  
  String getAlternates () {
    return alternates;
  }

}