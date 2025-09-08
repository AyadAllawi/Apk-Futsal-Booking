class Endpoint {
  static const String baseURL = "https://appfutsal.mobileprojp.com/api";

  // Auth
  static const String register = "$baseURL/register";
  static const String profile = "$baseURL/profile";
  static const String login = "$baseURL/login";

  // Fields
  static String get getFields => "$baseURL/fields";
  static String updateField(int id) => "$baseURL/fields/$id";
  static String deleteField(int id) => "$baseURL/fields/$id";

  // Schedule
  static String schedulesByField(int fieldId) => "$baseURL/fields/$fieldId/schedules";
  static const String createSchedule = "$baseURL/schedules";

  // Booking
  static const String createBooking = "$baseURL/bookings";
  static const String myBookings = "$baseURL/my-bookings";
  static String cancelBooking(int id) => "$baseURL/bookings/$id";
}