library;

import 'package:url_launcher/url_launcher.dart' as url;

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
    //return await canLaunchUrl(uri) ? launchUrl(uri, mode: LaunchMode.platformDefault) : false;
  }
}
