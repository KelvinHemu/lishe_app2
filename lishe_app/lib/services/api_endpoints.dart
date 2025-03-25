class ApiEndpoints {
  static const String baseUrl = "https://example.com/api";

  static String initiateRegistration = "$baseUrl/register/initiate";
  static String verifyOtp = "$baseUrl/register/verify-otp";
  static String createPassword = "$baseUrl/register/create-password";
  static String login = "$baseUrl/login";
  static String userProfile(String userId) => "$baseUrl/users/$userId/profile";
}
