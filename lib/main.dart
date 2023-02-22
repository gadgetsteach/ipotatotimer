import 'package:flutter/material.dart';
import 'package:ipotatotimer/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xff006782),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xff216C2E),
          foregroundColor: Color(0xffffffff),
        ),
      ),
      home: const Splash(),
    );
  }
}
