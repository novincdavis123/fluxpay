import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_theme.dart';
import 'package:fluxpay/features/exchange/presentation/pages/home_page.dart';

class FluxPayApp extends StatelessWidget {
  const FluxPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FluxPay',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomePage(),
    );
  }
}
