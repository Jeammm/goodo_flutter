import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:goodo_flutter/screens/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = const ColorScheme(
      brightness: Brightness.light,
      primary: Color.fromARGB(255, 229, 78, 69), // Main button color
      onPrimary: Colors.white,
      secondary: Color(0xFF03DAC6),
      onSecondary: Colors.black,
      error: Color(0xFFB00020),
      onError: Colors.white,
      surface: Color(0xFFF5F5F5),
      onSurface: Colors.black,
    );

    return ProviderScope(
      child: MaterialApp(
        title: 'Goodo',
        theme: ThemeData(colorScheme: colorScheme),
        home: const HomeScreen(),
      ),
    );
  }
}
