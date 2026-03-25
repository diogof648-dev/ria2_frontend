import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ria2_frontend/app.dart';
import 'package:ria2_frontend/core/di/app_dependencies.dart';

void main() {
  runApp(MultiProvider(providers: appProviders, child: const RiaApp()));
}
