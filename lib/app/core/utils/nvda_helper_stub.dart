/// Stub implementation para plataformas não-web
class NVDAHelper {
  static bool get isAvailable => false;
  static void createNVDAArea(String text) {}
  static void removeNVDAArea() {}
  static void toggleNVDAArea(String text) {}
  static bool get isAreaVisible => false;
}