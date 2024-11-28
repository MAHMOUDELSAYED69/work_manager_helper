import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'work_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  WorkManagerHelper.initializeWorkManager();

  WorkManagerHelper.registerPeriodicTask();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter WorkManager Example',
      debugShowCheckedModeBanner: false,
      home: WorkScreen(),
    );
  }
}

class WorkScreen extends StatefulWidget {
  const WorkScreen({super.key});

  @override
  State<WorkScreen> createState() => _WorkScreenState();
}

class _WorkScreenState extends State<WorkScreen> {
  String _data = '';
  String _fetchTime = '';

  Future<void> fetchDataFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _data = prefs.getString('fetchedData') ?? 'No data fetched yet';
      _fetchTime = prefs.getString('fetchTime') ?? 'No data fetched yet';
    });
  }

  @override
  void initState() {
    super.initState();
    fetchDataFromPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WorkManager Example")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Fetched Data:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _data.isEmpty ? 'Loading...' : _data,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Last Fetch Time:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _fetchTime.isEmpty ? 'No data fetched yet' : _fetchTime,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
