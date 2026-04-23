import 'package:flutter/material.dart';
import 'package:zadanko/screens/login_page.dart';
import 'package:zadanko/screens/group_list_page.dart';
import 'package:zadanko/db/database_helper.dart';
import 'package:zadanko/screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dbHelper = DatabaseHelper();
  final String? token = await dbHelper.getSession('token');
  final String? endpoint = await dbHelper.getSession('endpoint');

  final homeScreen = token != null && token.isNotEmpty
      ? const GroupListPage()
      : const LoginScreen();

  runApp(
    MyApp(
      initialScreen: endpoint != null && endpoint.isNotEmpty
          ? homeScreen
          : SettingsScreen(nextScreen: homeScreen),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Widget initialScreen;
  const MyApp({super.key, required this.initialScreen});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zadanko',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: initialScreen,
    );
  }
}
