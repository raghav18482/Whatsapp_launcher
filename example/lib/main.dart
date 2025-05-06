import 'package:flutter/material.dart';
import 'package:whatsapp_launcher/whatsapp_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WhatsAppDemo(),
    );
  }
}

class WhatsAppDemo extends StatelessWidget {
  final TextEditingController messageController = TextEditingController();

  WhatsAppDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WhatsApp Launcher Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: messageController,
              decoration: const InputDecoration(labelText: 'Message'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                bool success = await WhatsAppLauncher.launchWhatsAppMessage(
                  phoneNumber: '919999999999', // Replace with test number
                  message: messageController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? 'Launched!' : 'Failed to launch')),
                );
              },
              child: const Text("Send to WhatsApp"),
            ),
          ],
        ),
      ),
    );
  }
}
