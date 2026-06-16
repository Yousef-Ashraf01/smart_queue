import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Represents a single scheduled notification entry stored locally.
class NotificationEntry {
  final int id;
  final String title;
  final String body;
  final DateTime triggerTime;
  final int bookingId;
  bool isRead;

  NotificationEntry({
    required this.id,
    required this.title,
    required this.body,
    required this.triggerTime,
    required this.bookingId,
    this.isRead = false,
  });

  /// Whether this notification has been "delivered" (trigger time is in the past)
  bool get isDelivered => DateTime.now().isAfter(triggerTime);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'triggerTime': triggerTime.toIso8601String(),
    'bookingId': bookingId,
    'isRead': isRead,
  };

  factory NotificationEntry.fromJson(Map<String, dynamic> json) =>
      NotificationEntry(
        id: json['id'] as int,
        title: json['title'] as String,
        body: json['body'] as String,
        triggerTime: DateTime.parse(json['triggerTime'] as String),
        bookingId: json['bookingId'] as int,
        isRead: json['isRead'] as bool? ?? false,
      );
}

/// Persists and manages the local notification inbox.
class NotificationStore {
  static const _prefsKey = 'scheduled_notifications_inbox';

  // ─── Read ───────────────────────────────────────────────────────────────────

  static Future<List<NotificationEntry>> _loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_prefsKey) ?? [];
    return raw
        .map((e) {
          try {
            return NotificationEntry.fromJson(
              jsonDecode(e) as Map<String, dynamic>,
            );
          } catch (_) {
            return null;
          }
        })
        .whereType<NotificationEntry>()
        .toList();
  }

  static Future<void> _saveAll(List<NotificationEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      _prefsKey,
      entries.map((e) => jsonEncode(e.toJson())).toList(),
    );
  }

  // ─── Public API ─────────────────────────────────────────────────────────────

  /// Persists a new notification entry when it is scheduled.
  static Future<void> add(NotificationEntry entry) async {
    final all = await _loadAll();
    // Remove duplicates by same notification id
    all.removeWhere((e) => e.id == entry.id);
    all.add(entry);
    await _saveAll(all);
  }

  /// Returns all notifications that have been delivered (past trigger time)
  /// but not yet read by the user inside the in-app inbox.
  static Future<List<NotificationEntry>> getUnread() async {
    final all = await _loadAll();
    return all.where((e) => e.isDelivered && !e.isRead).toList()
      ..sort((a, b) => b.triggerTime.compareTo(a.triggerTime));
  }

  /// Returns the count of unread delivered notifications.
  static Future<int> unreadCount() async {
    final unread = await getUnread();
    return unread.map((e) => e.bookingId).toSet().length;
  }

  /// Marks all delivered notifications as read.
  static Future<void> markAllRead() async {
    final all = await _loadAll();
    for (final e in all) {
      if (e.isDelivered) e.isRead = true;
    }
    await _saveAll(all);
  }

  /// Removes all stored entries for a given booking (used on cancellation).
  static Future<void> removeByBookingId(int bookingId) async {
    final all = await _loadAll();
    all.removeWhere((e) => e.bookingId == bookingId);
    await _saveAll(all);
  }

  /// Cleans up old read notifications older than 7 days to avoid bloat.
  static Future<void> pruneOld() async {
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    final all = await _loadAll();
    all.removeWhere((e) => e.isRead && e.triggerTime.isBefore(cutoff));
    await _saveAll(all);
  }
}
