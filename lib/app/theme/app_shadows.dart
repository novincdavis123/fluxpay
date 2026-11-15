import 'package:material_ui/material_ui.dart';

class AppShadows {
  static List<BoxShadow> primary = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.08),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];
}
