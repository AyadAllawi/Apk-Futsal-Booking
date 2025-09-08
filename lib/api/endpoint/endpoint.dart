class Endpoint {
  static const String baseURL = "https://appfutsal.mobileprojp.com/api";

  // 🔹 Auth
  static const String register = "$baseURL/register";
  static const String profile = "$baseURL/profile";
  static const String login = "$baseURL/login";

  // 🔹 Field
  static String get getFields => "$baseURL/fields";
  static String updateField(int id) => "$baseURL/fields/$id";
  static String deleteField(int id) => "$baseURL/fields/$id";

  // 🔹 Booking & Schedule
  static String get createSchedule => "$baseURL/schedules";
  static String get createBooking => "$baseURL/bookings";
}
