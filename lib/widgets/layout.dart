import 'package:flutter/material.dart';

class Layout extends StatelessWidget {
  const Layout({super.key, this.title = "RIA2 Frontend", required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(child: child),
    );
  }
}
