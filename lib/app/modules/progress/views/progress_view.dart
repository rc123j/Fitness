import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/progress_controller.dart';

class ProgressView extends GetView<ProgressController> {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          /// BACKGROUND NEON BLUR BLOBS
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
                    const Color(0xffB100FF).withOpacity(0.08),
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
                    const Color(0xffFF00E5).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// MAIN SCREEN CONTENT
          SafeArea(
            child: Column(
              children: [
                /// HEADER
                buildHeader(),

                /// BODY CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        
                        /// 1. HEALTH SNAPSHOT CARD (BMI, TDEE, BMR, IBW)
                        buildHealthSnapshotCard(),
                        const SizedBox(height: 20),

                        /// 2. WEEKLY ADHERENCE CHART (CALORIES VS TARGET)
                        buildWeeklyAdherenceCard(),
                        const SizedBox(height: 20),

                        /// 3. WEIGHT TRAJECTORY GRAPH
                        buildWeightTrajectoryCard(),
                        const SizedBox(height: 30),
                        
                        /// 4. GAMIFICATION/STREAKS
                        buildGamificationRow(),
                        const SizedBox(height: 40),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Your Health Dashboard",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Data-driven insights to transform your life.",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
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
              Icons.calendar_today_rounded,
              color: Colors.white,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHealthSnapshotCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Body Analysis",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        
        // Top Row: BMI & TDEE
        Row(
          children: [
            Expanded(
              flex: 5,
              child: buildImageCard(
                imagePath: 'assets/new_images1/weight ratio.png',
                title: 'BMI Ratio',
                value: Obx(() => Text(
                  controller.bmi.value.toStringAsFixed(1),
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                )),
                color: const Color(0xff00A2FF),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 5,
              child: buildImageCard(
                imagePath: 'assets/new_images1/daily_tdeee.png',
                title: 'Daily TDEE',
                value: Obx(() => Text(
                  "${controller.tdee.value} kcal",
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                )),
                color: const Color(0xffFF7A00),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Bottom Row: BMR & IBW
        Row(
          children: [
            Expanded(
              flex: 5,
              child: buildImageCard(
                imagePath: 'assets/new_images1/bmr.png',
                title: 'Resting BMR',
                value: Obx(() => Text(
                  "${controller.bmr.value} kcal",
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                )),
                color: const Color(0xffB100FF),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 5,
              child: buildImageCard(
                imagePath: 'assets/new_images1/ideal_weight.png',
                title: 'Ideal Weight',
                value: Obx(() => Text(
                  "${controller.ibw.value} kg",
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                )),
                color: const Color(0xff00FF87),
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget buildImageCard({
    required String imagePath,
    required String title,
    required Widget value,
    required Color color,
  }) {
    return Container(
      height: 180,
      decoration: BoxDecoration(
        color: const Color(0xff121220),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image with Shader Mask for fading
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      const Color(0xff121220).withOpacity(0.9),
                      const Color(0xff121220).withOpacity(0.1),
                    ],
                    stops: const [0.3, 1.0],
                  ).createShader(rect);
                },
                blendMode: BlendMode.srcOver,
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(),
                ),
              ),
            ),
          ),
          
          // Content on top
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                value,
                const SizedBox(height: 4),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildWeeklyAdherenceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff121220),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "7-Day Calorie Adherence",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: Obx(() {
              if (controller.weeklyAdherenceData.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return CustomPaint(
                size: const Size(double.infinity, 160),
                painter: WeeklyAdherencePainter(
                  data: controller.weeklyAdherenceData,
                  targetCalories: controller.targetCalories.value,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildWeightTrajectoryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff121220),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Weight Trajectory",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Obx(() => Text(
                "${controller.weight.value} kg",
                style: GoogleFonts.outfit(
                  color: const Color(0xffB100FF),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              )),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 160,
            child: Obx(() {
              if (controller.weightTrendData.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              return CustomPaint(
                size: const Size(double.infinity, 160),
                painter: WeightTrajectoryPainter(
                  data: controller.weightTrendData,
                  goalWeight: controller.goalWeight.value,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget buildGamificationRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xff00FF87).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xff00FF87).withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_outline, color: Color(0xff00FF87)),
                const SizedBox(height: 8),
                Text(
                  "85%",
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Diet Compliance",
                  style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.6), fontSize: 12),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xffFF7A00).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xffFF7A00).withOpacity(0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.local_fire_department_outlined, color: Color(0xffFF7A00)),
                const SizedBox(height: 8),
                Text(
                  "14 Days",
                  style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Current Streak",
                  style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.6), fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class BMIArcPainter extends CustomPainter {
  final double bmi;
  BMIArcPainter({required this.bmi});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;

    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    // Determine color based on BMI
    Color fgColor = const Color(0xff00FF87); // Normal
    if (bmi < 18.5) fgColor = const Color(0xff00A2FF); // Underweight
    if (bmi >= 25 && bmi < 30) fgColor = const Color(0xffFF7A00); // Overweight
    if (bmi >= 30) fgColor = const Color(0xffFF3E3E); // Obese

    final fgPaint = Paint()
      ..color = fgColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;

    // Draw background arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi, // 180 deg
      pi, // sweep 180 deg
      false,
      bgPaint,
    );

    // Calc sweep angle (cap between 15 and 40 for visual representation)
    double clampedBmi = bmi.clamp(15.0, 40.0);
    double fraction = (clampedBmi - 15) / (40 - 15);
    double sweepAngle = fraction * pi;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      pi,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WeeklyAdherencePainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final int targetCalories;
  
  WeeklyAdherencePainter({required this.data, required this.targetCalories});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;
    
    final int maxCal = data.map((e) => e['calories'] as int).reduce(max);
    final int maxValue = max(maxCal, targetCalories) + 200; // Add padding to top
    
    final double barWidth = (size.width / data.length) * 0.4;
    final double spacing = size.width / data.length;
    
    // Draw target dotted line
    final double targetY = size.height - (targetCalories / maxValue) * size.height;
    
    final dashPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
      
    const double dashWidth = 5;
    const double dashSpace = 5;
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, targetY), Offset(startX + dashWidth, targetY), dashPaint);
      startX += dashWidth + dashSpace;
    }
    
    // Draw bars
    for (int i = 0; i < data.length; i++) {
      final cal = data[i]['calories'] as int;
      final double barHeight = (cal / maxValue) * size.height;
      
      final double x = (i * spacing) + (spacing / 2) - (barWidth / 2);
      final double y = size.height - barHeight;
      
      Color barColor = const Color(0xff00FF87);
      if (cal > targetCalories + 100) {
        barColor = const Color(0xffFF3E3E); // Over target
      } else if (cal < targetCalories - 300) {
        barColor = const Color(0xffFF7A00); // Under target
      }
      
      final barRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        const Radius.circular(4),
      );
      
      canvas.drawRRect(barRect, Paint()..color = barColor);
      
      // Draw labels
      final textSpan = TextSpan(
        text: data[i]['day'],
        style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.6), fontSize: 10),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x + (barWidth / 2) - (textPainter.width / 2), size.height + 8));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class WeightTrajectoryPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double goalWeight;

  WeightTrajectoryPainter({required this.data, required this.goalWeight});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;

    final double maxW = data.map((e) => (e['weight'] as num).toDouble()).reduce(max);
    final double minW = data.map((e) => (e['weight'] as num).toDouble()).reduce(min);
    
    final double upperBounds = max(maxW, goalWeight) + 2.0;
    final double lowerBounds = min(minW, goalWeight) - 2.0;
    final double range = upperBounds - lowerBounds;

    final double xStep = size.width / (data.length - 1);

    // Draw goal line
    final double goalY = size.height - ((goalWeight - lowerBounds) / range) * size.height;
    final goalPaint = Paint()
      ..color = const Color(0xff00FF87).withOpacity(0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;
    
    double startX = 0;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, goalY), Offset(startX + 5, goalY), goalPaint);
      startX += 10;
    }

    final path = Path();
    for (int i = 0; i < data.length; i++) {
      final w = (data[i]['weight'] as num).toDouble();
      final double x = i * xStep;
      final double y = size.height - ((w - lowerBounds) / range) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final linePaint = Paint()
      ..color = const Color(0xffB100FF)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, linePaint);

    // Draw points
    final pointPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    for (int i = 0; i < data.length; i++) {
      final w = (data[i]['weight'] as num).toDouble();
      final double x = i * xStep;
      final double y = size.height - ((w - lowerBounds) / range) * size.height;
      canvas.drawCircle(Offset(x, y), 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
