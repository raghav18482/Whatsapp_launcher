library;

import 'dart:io';

import 'package:url_launcher/url_launcher.dart' as url;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:flutter/material.dart';

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

  /// Requests all necessary permissions for scheduling notifications
  /// Compatible with various versions of flutter_local_notifications
  static Future<bool> requestNotificationPermissions(BuildContext context) async {
    if (Platform.isAndroid) {
      final androidImpl = _notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidImpl != null) {
        // Request notification permission (for Android 13+)
        try {
          // Try using requestNotificationsPermission method (available in version 9.1.0+)
          await androidImpl.requestNotificationsPermission();
        } catch (e) {
          // This method might not exist in older versions of the plugin
          print("Notification permission request not available: $e");
          // For older versions, we can't request notification permission programmatically
          // It will be requested when showing the first notification
        }

        // Check for exact alarm permission (Android 12+)
        bool hasExactAlarmPermission = false;
        try {
          // Try using canScheduleExactNotifications (available in version 9.0.0+)
          hasExactAlarmPermission = await androidImpl.canScheduleExactNotifications() ?? false;
        } catch (e) {
          // Method might not exist in older versions
          print("Cannot check exact alarm permissions: $e");
          // We'll assume we don't have permission and try to guide the user
          hasExactAlarmPermission = false;
        }

        if (!hasExactAlarmPermission) {
          // Try to open exact alarm settings
          bool openedSettings = false;
          try {
            // Try using requestExactAlarmsPermission (available in version 9.0.0+)
            openedSettings = await androidImpl.requestExactAlarmsPermission() ?? false;
          } catch (e) {
            // Method might not exist in older versions
            print("Cannot request exact alarm permission: $e");
            openedSettings = false;
          }

          // If we couldn't open settings automatically or the method doesn't exist,
          // show instructions to the user
          if (!openedSettings) {
            if (context.mounted) {
              await showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Permission Required'),
                  content: const Text(
                      'This app needs exact alarm permissions to schedule WhatsApp messages.\n\n'
                          'Please go to:\n'
                          '1. Settings > Apps > [Your App]\n'
                          '2. Special app access (or App permissions)\n'
                          '3. Alarms & reminders\n'
                          '4. Enable permission'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            }
            return false;
          }
        }
      }
    }

    return true;
  }

  static Future<void> scheduleWhatsAppMessage({
    required String phoneNumber,
    required String message,
    required DateTime scheduleAt,
    required BuildContext context,
  }) async {
    await _initializeNotifications();

    // Check and request permissions
    final hasPermissions = await requestNotificationPermissions(context);
    if (!hasPermissions) {
      throw Exception("Required permissions not granted");
    }

    // Schedule the notification
    await _notificationsPlugin.zonedSchedule(
      DateTime.now().millisecondsSinceEpoch ~/ 1000, // Generate unique ID
      'Scheduled WhatsApp Message',
      'Tap to send your WhatsApp message.',
      tz.TZDateTime.from(scheduleAt, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'whatsapp_channel_id',
          'WhatsApp Message Scheduler',
          channelDescription: 'Channel for scheduled WhatsApp messages',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: '$phoneNumber|$message',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}