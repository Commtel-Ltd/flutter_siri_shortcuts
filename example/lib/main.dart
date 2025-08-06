import 'package:flutter/material.dart';
import 'package:flutter_siri_shortcuts/flutter_siri_shortcuts.dart';

// Global shortcuts instance to handle activations even when app is in background
late FlutterSiriShortcuts _globalShortcuts;
String _lastActivation = 'No shortcut activated yet';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeGlobalShortcuts();
  runApp(const MyApp());
}

Future<void> _initializeGlobalShortcuts() async {
  final options = FlutterSiriShortcutArgs(
    title: 'Quick Action',
    activityType: 'com.example.quick_action',
    suggestedInvocationPhrase: 'Quick action',
  );
  
  _globalShortcuts = FlutterSiriShortcuts(initOptions: options);
  await _globalShortcuts.initialize();
  
  // Set global callback that works even when app is backgrounded
  _globalShortcuts.setShortcutActivationCallback(_onShortcutActivated);
}

void _onShortcutActivated(String activityType, Map<String, dynamic>? userInfo) {
  _lastActivation = 'Activated: $activityType at ${DateTime.now().toString().substring(11, 19)}';
  print('🎯 Shortcut executed: $activityType with data: $userInfo');
  
  // Your task execution logic here - this runs even when app is backgrounded
  switch (activityType) {
    case 'com.example.quick_action':
      print('🚀 Executing quick action...');
      break;
    default:
      print('📱 Unknown action: $activityType');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Siri Shortcuts',
      theme: ThemeData.dark(useMaterial3: true),
      home: const ShortcutPage(),
    );
  }
}

class ShortcutPage extends StatefulWidget {
  const ShortcutPage({super.key});

  @override
  State<ShortcutPage> createState() => _ShortcutPageState();
}

class _ShortcutPageState extends State<ShortcutPage> {
  String _status = _lastActivation;

  @override
  void initState() {
    super.initState();
    // Update UI when shortcuts are activated
    _globalShortcuts.setShortcutActivationCallback((activityType, userInfo) {
      _onShortcutActivated(activityType, userInfo);
      if (mounted) {
        setState(() {
          _status = _lastActivation;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '🎤 Siri Shortcuts',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w300,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 60),
            AddToSiriButton(
              title: 'Quick Action',
              id: 'quick_action',
              height: 50,
            ),
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[700]!),
              ),
              child: Column(
                children: [
                  const Text(
                    'Status:',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _status,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
