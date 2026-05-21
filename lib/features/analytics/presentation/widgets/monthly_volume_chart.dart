import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:fluxpay/app/theme/app_colors.dart';
import 'package:fluxpay/app/theme/app_text_styles.dart';

class MonthlyVolumeChart extends StatelessWidget {
  final List<double> monthlyVolume;

  const MonthlyVolumeChart({super.key, required this.monthlyVolume});

  @override
  Widget build(BuildContext context) {
    final cardColor = AppColors.getCardColor(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 280,

      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: cardColor,

        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.04)
              : Colors.black.withOpacity(0.04),
        ),
      ),

      child: monthlyVolume.isEmpty
          ? Center(
              child: Text(
                'No analytics data available',
                style: AppTextStyles.bodyMedium,
              ),
            )
          : LineChart(
              LineChartData(
                minY: 0,

                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1000,

                  getDrawingHorizontalLine: (_) {
                    return FlLine(
                      color: isDark
                          ? Colors.white.withOpacity(0.05)
                          : Colors.black.withOpacity(0.05),
                      strokeWidth: 1,
                    );
                  },
                ),

                borderData: FlBorderData(show: false),

                titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),

                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 42,
                      interval: 1000,

                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Text(
                            value.toInt().toString(),
                            style: AppTextStyles.bodySmall,
                          ),
                        );
                      },
                    ),
                  ),

                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,

                      getTitlesWidget: (value, meta) {
                        const months = [
                          'Jan',
                          'Feb',
                          'Mar',
                          'Apr',
                          'May',
                          'Jun',
                          'Jul',
                          'Aug',
                          'Sep',
                          'Oct',
                          'Nov',
                          'Dec',
                        ];

                        final index = value.toInt();

                        if (index < 0 || index >= months.length) {
                          return const SizedBox.shrink();
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 10),

                          child: Text(
                            months[index],
                            style: AppTextStyles.bodySmall,
                          ),
                        );
                      },
                    ),
                  ),
                ),

                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    barWidth: 4,

                    spots: List.generate(monthlyVolume.length, (index) {
                      return FlSpot(
                        index.toDouble(),
                        monthlyVolume[index].toDouble(),
                      );
                    }),

                    color: AppColors.primary,

                    dotData: FlDotData(show: true),

                    belowBarData: BarAreaData(
                      show: true,

                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withOpacity(0.25),
                          AppColors.primary.withOpacity(0.02),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
