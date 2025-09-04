class Endpoint {
  static const String baseURL = "https://appfutsal.mobileprojp.com/api";
  static const String register = "$baseURL/register";
  static const String profile = "$baseURL/profile";
  static const String login = "$baseURL/login";
  static String get getFields => "$baseURL/fields";
  static String updateField(int id) => "$baseURL/fields/$id";
  static String deleteField(int id) => "$baseURL/fields/$id";
}
