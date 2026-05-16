import 'package:flutter/material.dart';

import 'package:fluxpay/app/theme/app_spacing.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

class LiveRateIndicator extends StatefulWidget {
  final bool isStale;

  final DateTime? lastUpdated;

  const LiveRateIndicator({
    super.key,
    required this.isStale,
    required this.lastUpdated,
  });

  @override
  State<LiveRateIndicator> createState() => _LiveRateIndicatorState();
}

class _LiveRateIndicatorState extends State<LiveRateIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final indicatorColor = widget.isStale ? Colors.orange : Colors.green;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.2).animate(
                CurvedAnimation(
                  parent: _pulseController,
                  curve: Curves.easeInOut,
                ),
              ),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: indicatorColor,
                ),
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            Text(
              widget.isStale ? 'Refreshing rates...' : 'LIVE rates',
              style: AppTextStyles.bodySmall,
            ),
          ],
        ),

        const SizedBox(height: AppSpacing.xs),

        if (widget.lastUpdated != null)
          Text(
            'Updated just now • ${_formatTime(widget.lastUpdated!)}',
            style: AppTextStyles.bodySmall,
          ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');

    final minute = time.minute.toString().padLeft(2, '0');

    final second = time.second.toString().padLeft(2, '0');

    return '$hour:$minute:$second';
  }
}
