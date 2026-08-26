import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Shared calorie history bar chart.
///
/// Renders one bar per entry in [history] against a dashed [target] line.
/// Each history entry is `{ "day": String, "calories": num, "isToday": bool }`.
/// Used by the Progress screen (Weekly Calories + All-Time) and the Meal
/// screen's Nutrition History (Daily Intake) so both read identically.
class CalorieBarChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> history;
  final double target;

  CalorieBarChartPainter({required this.history, required this.target});

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;

    double yAxisWidth = 30.0;
    double xAxisHeight = 24.0;

    double chartLeft = yAxisWidth;
    double chartWidth = w - yAxisWidth;
    double chartHeight = h - xAxisHeight;

    double maxVal = max(target, 2500);
    for (var day in history) {
      double cal = double.tryParse(day['calories']?.toString() ?? '0') ?? 0;
      if (cal > maxVal) maxVal = cal;
    }
    maxVal = (maxVal / 1000).ceil() * 1000.0;

    int steps = (maxVal / 1000).floor();
    for (int i = 0; i <= steps; i++) {
      double val = i * 1000.0;
      double y = chartHeight - (val / maxVal) * chartHeight;

      String label = val == 0 ? "0" : "${(val / 1000).toInt()}K";
      final textPainter = TextPainter(
        text: TextSpan(
          text: label,
          style: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.5),
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(canvas, Offset(0, y - textPainter.height / 2));
    }

    double targetY = chartHeight - (target / maxVal) * chartHeight;
    double dashWidth = 4.0;
    double dashSpace = 4.0;
    double currentX = chartLeft;
    final targetPaint = Paint()
      ..color = const Color(0xffFF7A00).withOpacity(0.6)
      ..strokeWidth = 1.0;

    while (currentX < w) {
      canvas.drawLine(
        Offset(currentX, targetY),
        Offset(currentX + dashWidth, targetY),
        targetPaint,
      );
      currentX += dashWidth + dashSpace;
    }

    if (history.isEmpty) return;

    double barWidth = 24.0;
    double spacing =
        (chartWidth - (barWidth * history.length)) / (history.length + 1);

    for (int i = 0; i < history.length; i++) {
      double x = chartLeft + spacing + (i * (barWidth + spacing));
      double cal =
          double.tryParse(history[i]['calories']?.toString() ?? '0') ?? 0;
      double barHeight = (cal / maxVal) * chartHeight;

      if (barHeight > 0) {
        bool isToday = history[i]['isToday'] == true;

        Rect barRect = Rect.fromLTWH(
          x,
          chartHeight - barHeight,
          barWidth,
          barHeight,
        );

        Paint barPaint = Paint()
          ..shader = LinearGradient(
            colors: isToday
                ? [const Color(0xffFFD166), const Color(0xffFF7A00)]
                : [const Color(0xffD07CFF), const Color(0xff702F9A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(barRect);

        Paint glowPaint = Paint()
          ..color =
              (isToday ? const Color(0xffFF7A00) : const Color(0xffB100FF))
                  .withOpacity(0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);

        canvas.drawRRect(
          RRect.fromRectAndRadius(barRect, const Radius.circular(6)),
          glowPaint,
        );

        canvas.drawRRect(
          RRect.fromRectAndRadius(barRect, const Radius.circular(6)),
          barPaint,
        );
      }

      String dayLabel = history[i]['day'] ?? '';
      final labelPainter = TextPainter(
        text: TextSpan(
          text: dayLabel,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      labelPainter.paint(
        canvas,
        Offset(x + (barWidth / 2) - (labelPainter.width / 2), chartHeight + 8),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CalorieBarChartPainter oldDelegate) => true;
}

/// A short horizontal dashed rule, used in chart legends.
class DashedLinePainter extends CustomPainter {
  final Color color;
  DashedLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 4.0;
    double dashSpace = 4.0;
    double currentX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    while (currentX < size.width) {
      canvas.drawLine(
        Offset(currentX, size.height / 2),
        Offset(currentX + dashWidth, size.height / 2),
        paint,
      );
      currentX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant DashedLinePainter oldDelegate) => false;
}
