import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'api.dart';

class WorkManagerHelper {
  static void callbackDispatcher() {
    Workmanager().executeTask((task, inputData) async {
      final apiService = ApiServiceImpl();
      try {
        final data = await apiService.fetchData();

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('fetchedData', json.encode(data));
        await prefs.setString('fetchTime', DateTime.now().toString());

        log("Fetched data: $data");
      } catch (e) {
        log("Error fetching data: $e");
      }
      return Future.value(true);
    });
  }

  static void initializeWorkManager() {
    Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: true,
    );
  }

  static void registerPeriodicTask() {
    Workmanager().registerPeriodicTask(
      "1", 
      "fetchDataTask",
      frequency:
          const Duration(minutes: 15), 
      initialDelay: const Duration(
          seconds: 10), 
      backoffPolicy:
          BackoffPolicy.exponential, 
      backoffPolicyDelay: const Duration(
          seconds: 30), 
    );
  }
}
