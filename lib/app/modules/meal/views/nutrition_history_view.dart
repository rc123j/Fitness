import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/meal_controller.dart';

class NutritionHistoryView extends GetView<MealController> {
  const NutritionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          /// BACKGROUND GLOW BLOBS
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xff00FF87).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffB100FF).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// CONTENT
          SafeArea(
            child: Column(
              children: [
                /// Custom Header
                buildHeader(),

                /// Scrollable body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 1. Weekly summary cards
                        buildSummaryCards(),
                        const SizedBox(height: 20),

                        /// 2. Calorie trend line chart
                        buildCalorieTrendCard(),
                        const SizedBox(height: 20),

                        /// 3. Meal attendance matrix
                        buildMealAttendanceCard(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 0.8,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Nutrition History",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Your weekly calorie & meal compliance tracker",
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.50),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildSummaryCards() {
    return Obx(() {
      final avg = controller.historyAverageCalories.value;
      final target = controller.historyTargetCalories.value;
      final rate = controller.historyAdherenceRate.value;

      return Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xff0B0817).withOpacity(0.55),
                border: Border.all(
                  color: const Color(0xff00FF87).withOpacity(0.15),
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Avg Intake",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.50),
                          fontSize: 10,
                        ),
                      ),
                      const Icon(
                        Icons.bolt,
                        color: Color(0xff00FF87),
                        size: 14,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$avg kcal",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Target: $target kcal",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xff0B0817).withOpacity(0.55),
                border: Border.all(
                  color: const Color(0xffB100FF).withOpacity(0.15),
                  width: 1.0,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Adherence",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.50),
                          fontSize: 10,
                        ),
                      ),
                      const Icon(
                        Icons.verified_rounded,
                        color: Color(0xffB100FF),
                        size: 14,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "$rate%",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Days with logged meals",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 9,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget buildCalorieTrendCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(color: Colors.white.withOpacity(0.04), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Weekly Calorie Intake vs Target",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 22),
          Obx(() {
            final list = controller.calorieHistoryList.toList();
            if (list.isEmpty) {
              return const SizedBox(
                height: 160,
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xff00FF87),
                    ),
                  ),
                ),
              );
            }
            return Column(
              children: [
                SizedBox(
                  height: 160,
                  width: double.infinity,
                  child: CustomPaint(
                    painter: CalorieHistoryChartPainter(
                      history: list,
                      target: controller.historyTargetCalories.value.toDouble(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: list.map((day) {
                    final dateStr = day['date'] as String;
                    final parts = dateStr.split('-');
                    final label = parts.length == 3
                        ? "${parts[2]}/${parts[1]}"
                        : "Log";
                    return Text(
                      label,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 9,
                      ),
                    );
                  }).toList(),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget buildMealAttendanceCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(color: Colors.white.withOpacity(0.04), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Meal Attendance Log",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Visual check of marked vs missed meals",
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.40),
              fontSize: 9.5,
            ),
          ),
          const SizedBox(height: 18),
          Obx(() {
            final list = controller.calorieHistoryList.toList();
            if (list.isEmpty) {
              return const SizedBox(
                height: 100,
                child: Center(child: Text("No logs to show")),
              );
            }

            final mealTypes = [
              {"id": 1, "name": "Breakfast"},
              {"id": 2, "name": "Mid Meal"},
              {"id": 3, "name": "Lunch"},
              {"id": 4, "name": "Evening Snack"},
              {"id": 5, "name": "Dinner"},
            ];

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Table(
                defaultColumnWidth: const FixedColumnWidth(70),
                children: [
                  // Table Header Row
                  TableRow(
                    children: [
                      const TableCell(
                        child: Center(
                          child: Text("", style: TextStyle(fontSize: 8)),
                        ),
                      ),
                      ...list.map((day) {
                        final dateStr = day['date'] as String;
                        final parts = dateStr.split('-');
                        final dayLabel = parts.length == 3
                            ? "${parts[2]}/${parts[1]}"
                            : "";
                        return TableCell(
                          child: Center(
                            child: Text(
                              dayLabel,
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.60),
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ],
                  ),

                  // Table Data Rows
                  ...mealTypes.map((type) {
                    final typeId = type['id'] as int;
                    final typeName = type['name'] as String;

                    return TableRow(
                      children: [
                        // Leftmost column: Meal type name
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              typeName,
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.50),
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        // Daily columns
                        ...list.map((day) {
                          final List mealsLogged = day['meals_logged'] ?? [];
                          final bool isLogged = mealsLogged.contains(typeId);
                          final String dayStr = day['date'] as String;
                          final bool isPast = DateTime.parse(dayStr).isBefore(
                            DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                            ),
                          );

                          Widget icon = const SizedBox.shrink();
                          if (isLogged) {
                            icon = const Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xff00FF87),
                              size: 14,
                            );
                          } else if (isPast) {
                            icon = Icon(
                              Icons.cancel_rounded,
                              color: Colors.white.withOpacity(0.12),
                              size: 14,
                            );
                          } else {
                            icon = const Icon(
                              Icons.radio_button_unchecked_rounded,
                              color: Colors.white24,
                              size: 12,
                            );
                          }

                          return TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                ),
                                child: icon,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class CalorieHistoryChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> history;
  final double target;

  CalorieHistoryChartPainter({required this.history, required this.target});

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;

    // Draw horizontal grid line representing target threshold
    final targetPaint = Paint()
      ..color = const Color(0xffFF3B30).withOpacity(0.3)
      ..strokeWidth = 1.0;

    // Draw target baseline text
    final textPainter = TextPainter(
      text: TextSpan(
        text: "Target: ${target.toInt()} kcal",
        style: GoogleFonts.inter(
          color: const Color(0xffFF3B30).withOpacity(0.6),
          fontSize: 8,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    double maxVal = max(
      target,
      history
          .map(
            (day) => double.tryParse(day['calories']?.toString() ?? '0') ?? 0.0,
          )
          .reduce(max),
    );
    if (maxVal == 0) maxVal = 2000.0;

    double targetY = h - ((target / maxVal) * (h - 20)) - 10;
    canvas.drawLine(Offset(0, targetY), Offset(w, targetY), targetPaint);
    textPainter.paint(canvas, Offset(4, targetY - 12));

    // Plot intake curve
    final List<double> calories = history
        .map(
          (day) => double.tryParse(day['calories']?.toString() ?? '0.0') ?? 0.0,
        )
        .toList();
    if (calories.isEmpty) return;

    double stepX = w / (calories.length - 1 == 0 ? 1 : calories.length - 1);
    final points = <Offset>[];

    for (int i = 0; i < calories.length; i++) {
      double x = i * stepX;
      double y = h - ((calories[i] / maxVal) * (h - 20)) - 10;
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points[0].dx, points[0].dy);
    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final controlPoint1 = Offset(p1.dx + (p2.dx - p1.dx) / 2.2, p1.dy);
      final controlPoint2 = Offset(p1.dx + (p2.dx - p1.dx) / 2.2, p2.dy);
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p2.dx,
        p2.dy,
      );
    }

    // Fill area under line
    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, h)
      ..lineTo(points.first.dx, h)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xff00FF87).withOpacity(0.08), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawPath(fillPath, fillPaint);

    // Draw main glowing green chart line
    final linePaint = Paint()
      ..color = const Color(0xff00FF87)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    // Draw dots and calorie numbers
    for (int i = 0; i < points.length; i++) {
      final pt = points[i];
      final calVal = calories[i].toInt();

      // Outer glow circle
      canvas.drawCircle(
        pt,
        5,
        Paint()..color = const Color(0xff00FF87).withOpacity(0.25),
      );
      // Inner circle
      canvas.drawCircle(pt, 2, Paint()..color = Colors.white);

      if (calVal > 0) {
        final valPainter = TextPainter(
          text: TextSpan(
            text: "$calVal",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        valPainter.paint(
          canvas,
          Offset(pt.dx - valPainter.width / 2, pt.dy - 14),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
