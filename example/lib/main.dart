// example/lib/main.dart

import 'package:flutter/material.dart';
import 'package:whatsapp_launcher/whatsapp_launcher.dart';
import 'package:intl/intl.dart';

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

class WhatsAppDemo extends StatefulWidget {
  const WhatsAppDemo({super.key});

  @override
  State<WhatsAppDemo> createState() => _WhatsAppDemoState();
}

class _WhatsAppDemoState extends State<WhatsAppDemo> {
  final TextEditingController messageController = TextEditingController();
  final TextEditingController scheduleDateController = TextEditingController();
  DateTime? selectedDateTime;

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
            TextField(
              controller: scheduleDateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Schedule Time',
                hintText: 'Tap to pick date & time',
              ),
              onTap: () async {
                final DateTime? date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(Duration(minutes: 1)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );

                if (date != null) {
                  final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );

                  if (time != null) {
                    selectedDateTime = DateTime(
                      date.year,
                      date.month,
                      date.day,
                      time.hour,
                      time.minute,
                    );

                    scheduleDateController.text =
                        DateFormat('yyyy-MM-dd – kk:mm').format(selectedDateTime!);
                  }
                }
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                bool success = await WhatsAppLauncher.launchWhatsAppMessage(
                  phoneNumber: '919214529913', // Replace with test number
                  message: messageController.text,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(success ? 'Launched!' : 'Failed to launch')),
                );
              },
              child: const Text("Send to WhatsApp Now"),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                if (selectedDateTime == null || messageController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter message and select time')),
                  );
                  return;
                }

                await WhatsAppLauncher.scheduleWhatsAppMessage(
                  phoneNumber: '919214529913', // Replace with test number
                  message: messageController.text,
                  scheduleAt: selectedDateTime!,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Message scheduled!')),
                );
              },
              child: const Text("Schedule WhatsApp Message"),
            ),
          ],
        ),
      ),
    );
  }
}
