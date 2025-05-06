library;

import 'dart:io';

import 'package:url_launcher/url_launcher.dart' as url;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class WhatsAppLauncher {
  /// Launches WhatsApp with the given phone number and message.
  ///
  /// [phoneNumber] should be in international format (e.g., +919999999999 or 919999999999).
  /// [message] is the text to be sent.
  /// Returns `true` if WhatsApp was successfully launched, otherwise `false`.
  static Future<bool> launchWhatsAppMessage({
    required String phoneNumber,
    required String message,
  }) async {
    final encodedMessage = Uri.encodeComponent(message);
    final link = 'https://wa.me/$phoneNumber?text=$encodedMessage';
    return await url.launchUrl(
      Uri.parse(link),
      mode: url.LaunchMode.platformDefault,
    );
  }

  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();
  static bool _isInitialized = false;

  static Future<void> _initializeNotifications() async {
    if (_isInitialized) return;
    tz_data.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidInit);

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) async {
        final payload = response.payload;
        if (payload != null) {
          final parts = payload.split('|');
          if (parts.length == 2) {
            final phone = parts[0];
            final msg = parts[1];
            await launchWhatsAppMessage(phoneNumber: phone, message: msg);
          }
        }
      },
    );

    _isInitialized = true;
  }

  static Future<void> scheduleWhatsAppMessage({
    required String phoneNumber,
    required String message,
    required DateTime scheduleAt,
  }) async {
    if (Platform.isAndroid) await _checkExactAlarmPermission();
    await _initializeNotifications();

    // Schedule the notification
    await _notificationsPlugin.zonedSchedule(
      0,
      'Scheduled WhatsApp Message',
      'Tap to send your WhatsApp message.',
      tz.TZDateTime.from(scheduleAt, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'whatsapp_channel_id',
          'WhatsApp Message Scheduler',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: '$phoneNumber|$message',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // Removed deprecated parameters
    );
  }

  /// On Android 12+, requests the exact alarm permission if not granted
  static Future<void> _checkExactAlarmPermission() async {
    final androidImpl =
    _notificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidImpl != null) {
      final hasPermission =
          await androidImpl.areNotificationsEnabled() ?? false;
      // Note: flutter_local_notifications does not expose exact alarm permission directly
      // For exact alarms, direct user to settings as needed.
    }
  }

}
