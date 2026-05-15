import 'package:flutter/material.dart';
import 'package:fluxpay/app/app.dart';
import 'package:fluxpay/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initDependencies();

  runApp(const FluxPayApp());
}
