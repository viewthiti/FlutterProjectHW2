import 'package:flutter/material.dart';
import 'package:flutter_ui_w2/pages/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // theme: ThemeData(useMaterial3: false),
      title: 'Flutter Demo',
      home: LoginPage(),
    );
  }
}
