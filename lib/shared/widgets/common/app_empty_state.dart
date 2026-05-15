import 'package:flutter/material.dart';

class AppEmptyState extends StatelessWidget {
  final String title;

  const AppEmptyState({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text(title));
  }
}
