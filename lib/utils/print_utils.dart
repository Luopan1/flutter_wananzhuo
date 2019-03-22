class PrintUtils {
  static bool openPrint = true;

  static void printValue(value) {
    if (openPrint) {
      print("*" * 100);
      print(value);
      print("*" * 100);
    }
  }
}
