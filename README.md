<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

A Flutter plugin that provides a simple way to launch WhatsApp conversations with pre-filled messages using the official WhatsApp deep linking system.

# whatsapp_launcher

A Flutter plugin to launch WhatsApp with a phone number and a pre-filled message using the [wa.me](https://wa.me) deep link.

## Features

- Open WhatsApp chat for a specific phone number
- Send pre-filled messages
- Simple and easy-to-use API
- Supports both Android and iOS platforms
- Handles error cases gracefully

## Getting Started

Add the dependency in your `pubspec.yaml`:

```yaml
dependencies:
  whatsapp_launcher: ^1.0.0
```

## Usage

Here's a simple example of how to use the plugin:

```dart
import 'package:whatsapp_launcher/whatsapp_launcher.dart';

void sendMessage() async {
  bool launched = await WhatsAppLauncher.launchWhatsAppMessage(
    phoneNumber: '919999999999', // Use international format without '+'
    message: 'Hello from Flutter!',
  );

  if (!launched) {
    print('Could not open WhatsApp');
  }
}
```

### Parameters

- `phoneNumber`: The recipient's phone number in international format without the '+' symbol (e.g., '919999999999')
- `message`: The pre-filled message to be sent (optional)

## Requirements

- WhatsApp must be installed on the user's device
- Supported on both Android and iOS platforms
- For Android: Requires minimum SDK version 16
- For iOS: Requires iOS 9.0 or later

## Additional Information

For more detailed examples and implementation details, check out the `/example` directory in the package repository.
