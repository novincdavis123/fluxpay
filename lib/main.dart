import 'package:flutter/material.dart';
import 'package:fluxpay/app/app.dart';
import 'package:fluxpay/injection_container.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Dependency Injection
  await initDependencies();

  runApp(const FluxPayApp());
}
