class ApiEndpoints {
  // Auth
  static const String register = '/app/profiles/';
  static const String resetPasswordRequest =
      '/app/profiles/reset_password_request/';
  static const String resetPasswordConfirm =
      '/app/profiles/reset_password_confirm/';
  static const String verifySmsCode = '/app/profiles/verify_sms_code/';
  static const String registerSmsRequest =
      '/app/profiles/register_sms_request/';

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

  // Feedbacks
  static String feedback(int appointmentId) =>
      '${ApiEndpoints.appointments}$appointmentId/feedback/';

  static String feedbackList(int appointmentId) =>
      '${ApiEndpoints.appointments}$appointmentId/feedback/';

  // n8n Chatbot
  static const String aiChatbot =
      'https://minaa04.app.n8n.cloud/webhook/smartiq';
  static const String aiChatbotToken =
      'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3Nzk5ODg3NzJ9.oUXXhBJGGcP3vlEUGCQIpu9HnBPzuy0t43LtfEmqwn4';
}
