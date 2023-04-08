// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: DialScreen());
  }
}

class DialScreen extends StatefulWidget {
  const DialScreen({super.key});

  @override
  _DialScreenState createState() => _DialScreenState();
}

class _DialScreenState extends State<DialScreen> with WidgetsBindingObserver {
  final accessToken =
      'eyJjdHkiOiJ0d2lsaW8tZnBhO3Y9MSIsInR5cCI6IkpXVCIsImFsZyI6IkhTMjU2In0.eyJpc3MiOiJTSzlmMzllMzM2YmE0YTJkNzY5MGRmMGU3ZDY5YTBiNWJjIiwiZXhwIjoxNjgwODY1NTg0LCJqdGkiOiJTSzlmMzllMzM2YmE0YTJkNzY5MGRmMGU3ZDY5YTBiNWJjLTE2ODA4NTgzODQiLCJzdWIiOiJBQzU4ODYxMDE4YzhiZTM5ZmRhMGNlYjc5YjBmNDRiMmNlIiwiZ3JhbnRzIjp7ImlkZW50aXR5IjoiMTkwOTM3NTgyMjQiLCJ2b2ljZSI6eyJpbmNvbWluZyI6eyJhbGxvdyI6dHJ1ZX0sIm91dGdvaW5nIjp7ImFwcGxpY2F0aW9uX3NpZCI6IkFQZWQ1NTkwYzg3MGZiYWJkZTc0NDdmMTNkODU1YmVmMmIifX19fQ.lRodtPf03wqKoTEX5zlmKcXdbf2B2QQYPLp8iHRaM5c';
  final _controller = TextEditingController();
  static const MethodChannel _channel = MethodChannel('voice_quickstart');

  Future<void> makeCall(String accessToken) async {
    final result = await _channel.invokeMethod('makeCall', {'accessToken': accessToken});
    print(result);
    return result;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  controller: _controller,
                  decoration: const InputDecoration(labelText: 'Client Identifier or Phone Number'),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  child: const Text("Make Call"),
                  onPressed: () async {
                    try {
                      await makeCall(accessToken);
                    } catch (e) {
                      print(e);
                    }
                    print("starting call to ${_controller.text}");
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
