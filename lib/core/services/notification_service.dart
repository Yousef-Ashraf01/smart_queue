import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:smart_queue/core/localization/api_localization.dart';
import 'package:smart_queue/core/routing/app_router.dart';
import 'package:smart_queue/core/routing/app_routes.dart';
import 'package:smart_queue/core/services/notification_store.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Initializes timezone database and the local notifications settings
  static Future<void> init() async {
    // Initialize timezone database
    tz.initializeTimeZones();

    // Default location to Egypt timezone (standard locale for the app's services)
    try {
      tz.setLocalLocation(tz.getLocation('Africa/Cairo'));
    } catch (_) {
      // Fallback if Africa/Cairo is not present, tz.local will be used
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: _onNotificationTapBackground,
    );

    // Request permissions on Android 13+
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();
  }

  /// Handles tap interaction when the app is in the foreground
  static void _onNotificationTap(NotificationResponse response) {
    _navigateToTimerScreen();
  }

  /// Handles tap interaction when the app is in the background or killed
  @pragma('vm:entry-point')
  static void _onNotificationTapBackground(NotificationResponse response) {
    _navigateToTimerScreen();
  }

  /// Navigates the app to the Timer / My Queue screen
  static void _navigateToTimerScreen() {
    final context = AppRouter.navigatorKey.currentContext;
    if (context != null) {
      context.push(AppRoutes.timer);
    }
  }

  // Test Notification
  // static Future<void> testNotification() async {
  //   const AndroidNotificationDetails androidDetails =
  //       AndroidNotificationDetails(
  //         'test_channel',
  //         'Test Notifications',
  //         channelDescription: 'Channel for testing notifications',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //       );
  //
  //   const NotificationDetails notificationDetails = NotificationDetails(
  //     android: androidDetails,
  //     iOS: DarwinNotificationDetails(),
  //   );
  //
  //   final scheduledDate = DateTime.now().add(const Duration(minutes: 1));
  //
  //   await _notificationsPlugin.zonedSchedule(
  //     999,
  //     'Test Notification',
  //     'Notifications are working correctly 🚀',
  //     tz.TZDateTime.from(scheduledDate, tz.local),
  //     notificationDetails,
  //     androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //   );
  // }

  /// Schedules two notifications: one 1 hour before and another 10 minutes before the slot start
  static Future<void> scheduleBookingReminders({
    required int bookingId,
    required String orgName,
    required String serviceName,
    required DateTime slotStart,
  }) async {
    final now = DateTime.now();
    if (slotStart.isBefore(now)) return;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'smart_queue_reminders',
          'Booking Reminders',
          channelDescription: 'Notifications for upcoming queue appointments',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    // 1. One-Hour Reminder
    final oneHourBefore = slotStart.subtract(const Duration(hours: 1));
    if (oneHourBefore.isAfter(now)) {
      final tzDateTime = tz.TZDateTime.from(oneHourBefore, tz.local);
      final notifId = bookingId * 10 + 1;
      final title = 'upcoming_booking_1_hour_title'.tr();
      final body = 'upcoming_booking_1_hour_body'.tr(
        args: [serviceName.localizedApi, orgName.localizedApi],
      );
      await _notificationsPlugin.zonedSchedule(
        notifId,
        title,
        body,
        tzDateTime,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'timer',
      );
      // Persist in inbox store
      await NotificationStore.add(
        NotificationEntry(
          id: notifId,
          title: title,
          body: body,
          triggerTime: oneHourBefore,
          bookingId: bookingId,
        ),
      );
    }

    // 2. Ten-Minute Reminder
    final tenMinutesBefore = slotStart.subtract(const Duration(minutes: 10));
    if (tenMinutesBefore.isAfter(now)) {
      final tzDateTime = tz.TZDateTime.from(tenMinutesBefore, tz.local);
      final notifId = bookingId * 10 + 2;
      final title = 'upcoming_booking_10_min_title'.tr();
      final body = 'upcoming_booking_10_min_body'.tr(
        args: [serviceName.localizedApi, orgName.localizedApi],
      );
      await _notificationsPlugin.zonedSchedule(
        notifId,
        title,
        body,
        tzDateTime,
        platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'timer',
      );
      // Persist in inbox store
      await NotificationStore.add(
        NotificationEntry(
          id: notifId,
          title: title,
          body: body,
          triggerTime: tenMinutesBefore,
          bookingId: bookingId,
        ),
      );
    }

    // Prune old read notifications to keep storage tidy
    await NotificationStore.pruneOld();
  }

  /// Shows an instant local notification confirming a successful Stripe payment
  /// and persists it in the in-app notification inbox.
  static Future<void> showPaymentSuccessNotification({
    required int bookingId,
    required String serviceName,
    required double amount,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'smart_queue_payments',
          'Payment Confirmations',
          channelDescription: 'Notifications for successful payments',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    final notifId = bookingId * 10 + 3;
    final title = 'payment_successful_title'.tr();
    final body = 'payment_successful_body'.tr(
      args: [amount.toStringAsFixed(0), serviceName.localizedApi],
    );

    await _notificationsPlugin.show(
      notifId,
      title,
      body,
      platformDetails,
      payload: 'timer',
    );

    // Persist in inbox store so it appears in the in-app notification list
    await NotificationStore.add(
      NotificationEntry(
        id: notifId,
        title: title,
        body: body,
        triggerTime: DateTime.now(),
        bookingId: bookingId,
      ),
    );
  }

  /// Cancels both scheduled reminders for a specific booking ID
  static Future<void> cancelBookingReminders(int bookingId) async {
    await _notificationsPlugin.cancel(bookingId * 10 + 1);
    await _notificationsPlugin.cancel(bookingId * 10 + 2);
    // Remove from local inbox store so they don't appear as delivered
    await NotificationStore.removeByBookingId(bookingId);
  }
}
