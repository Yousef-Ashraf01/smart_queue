class ApiEndpoints {
  // Auth
  static const String register = '/app/profiles/';
  // static const String login = '/auth/jwt/create/';
  static const String login = '/app/login/';
  static const String refreshToken = '/auth/jwt/refresh/';
  static const String changePassword = '/auth/users/set_password/';

  // Profile
  static const String getProfileData = '/app/profiles/';

  // Booking
  static const String appointments = '/api/appointments/';

  // Services
  static const String services = '/api/services/';

  // Organizations
  static const String organizations = '/api/organizations/';

  // Extract Id
  static const String extractId = '/app/extract-id/';

  // Branches
  static String branches(int organizationId) =>
      '/api/organizations/$organizationId/branches/';
  static String serviceCounters(int branchId) =>
      '/api/branches/$branchId/service-counters/';

  // Slots
  static String availableSlots(int counterId) =>
      '/api/service-counters/$counterId/available_slots/';
}
