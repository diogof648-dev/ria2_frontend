import 'package:flutter/material.dart';
import 'package:ria2_frontend/pages/home.page.dart';

class RiaApp extends StatelessWidget {
  const RiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RIA2 Frontend',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const Home(),
    );
  }
}
