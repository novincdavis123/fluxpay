import 'package:flutter/material.dart';

import 'package:fluxpay/app/theme/app_colors.dart';

class ShimmerBox extends StatefulWidget {
  final double height;

  final double? width;

  final BorderRadius borderRadius;

  final EdgeInsetsGeometry? margin;

  final bool enableShadow;

  const ShimmerBox({
    super.key,
    required this.height,
    this.width,
    this.margin,
    this.enableShadow = false,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final baseColor = isDark ? AppColors.white05 : Colors.grey.shade300;

    final middleColor = isDark ? AppColors.white12 : Colors.grey.shade100;

    return AnimatedBuilder(
      animation: _controller,

      builder: (context, child) {
        return Container(
          height: widget.height,
          width: widget.width,
          margin: widget.margin,

          decoration: BoxDecoration(
            borderRadius: widget.borderRadius,

            gradient: LinearGradient(
              begin: Alignment(-1.8 + (_controller.value * 3), 0),

              end: Alignment(-0.8 + (_controller.value * 3), 0),

              colors: [baseColor, middleColor, baseColor],

              stops: const [0.1, 0.45, 0.9],
            ),

            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.03)
                  : Colors.black.withOpacity(0.03),
            ),

            boxShadow: widget.enableShadow
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.20 : 0.04),

                      blurRadius: 10,

                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
        );
      },
    );
  }
}
