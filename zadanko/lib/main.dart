import 'package:flutter/material.dart';
import 'package:zadanko/screens/login_page.dart';
import 'package:zadanko/screens/group_list_page.dart';
import 'package:zadanko/db/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final dbHelper = DatabaseHelper();
  final String? token = await dbHelper.getSession('token');
  
  runApp(MyApp(isLoggedIn: token != null && token.isNotEmpty));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zadanko',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isLoggedIn ? const GroupListPage() : const LoginScreen(),
    );
  }
}
