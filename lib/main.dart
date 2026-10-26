import 'package:flutter/material.dart';

import 'pages/home_page.dart';

void main() => runApp(const EduEcoApp());

class EduEcoApp extends StatelessWidget {
  const EduEcoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduEco ASEAN',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1B5E8C)),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
