class ApiEndpoints {
  // Auth
  static const String register = '/app/profiles/';
  // static const String login = '/auth/jwt/create/';
  static const String login = '/app/login/';
  static const String refreshToken = '/auth/jwt/refresh/';

  // Profile
  static const String getProfileData = '/app/profiles/';

  // Booking
  static const String appointmentRequests = '/api/appointment-requests/';
  static const String appointments = '/api/appointments/';

  // Services
  static const String services = '/api/services/';

  // Organizations
  static const String organizations = '/api/organizations/';
}
