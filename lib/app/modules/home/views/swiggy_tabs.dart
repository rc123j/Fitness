import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class SwiggyTabPainter extends CustomPainter {
  final bool isMeal;
  final Color color;

  SwiggyTabPainter({required this.isMeal, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    final double W = size.width;
    final double H = size.height;
    final double baseY = 60.0; // Extreme dip (60 pixels deep!)
    final double topY = 0.0; // Top of active tab
    final double middle = W / 2;

    if (isMeal) {
      path.moveTo(0, H);
      path.lineTo(0, baseY);
      // Extremely sweeping S-curve from left edge of screen to active Meal tab
      path.cubicTo(18, baseY, 36, topY, 48, topY);
      // Top flat area of Meal tab
      path.lineTo(middle - 36, topY);
      // Extra-wide curve down to the right shoulder
      path.cubicTo(middle - 14, topY, middle + 14, baseY, middle + 36, baseY);
      // Inactive shoulder flat to the right edge
      path.lineTo(W, baseY);
      path.lineTo(W, H);
      path.close();
    } else {
      path.moveTo(0, H);
      path.lineTo(0, baseY);
      // Inactive shoulder flat from left edge to middle
      path.lineTo(middle - 36, baseY);
      // Extra-wide curve up to the active Workout tab
      path.cubicTo(middle - 14, baseY, middle + 14, topY, middle + 36, topY);
      // Top flat area of Workout tab
      path.lineTo(W - 48, topY);
      // Curve down to right edge of screen
      path.cubicTo(W - 36, topY, W - 18, baseY, W, baseY);
      path.lineTo(W, H);
      path.close();
    }

    canvas.drawPath(path, paint);

    final activeBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final inactiveBorderPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    if (isMeal) {
      // Active tab curves (Meal tab)
      final activePath = Path()
        ..moveTo(0, baseY)
        ..cubicTo(18, baseY, 36, topY, 48, topY)
        ..lineTo(middle - 36, topY)
        ..cubicTo(middle - 14, topY, middle + 14, baseY, middle + 36, baseY);
      canvas.drawPath(activePath, activeBorderPaint);

      // Inactive flat shoulder
      final inactivePath = Path()
        ..moveTo(middle + 36, baseY)
        ..lineTo(W, baseY);
      canvas.drawPath(inactivePath, inactiveBorderPaint);
    } else {
      // Inactive flat shoulder
      final inactivePath = Path()
        ..moveTo(0, baseY)
        ..lineTo(middle - 36, baseY);
      canvas.drawPath(inactivePath, inactiveBorderPaint);

      // Active tab curves (Workout tab)
      final activePath = Path()
        ..moveTo(middle - 36, baseY)
        ..cubicTo(middle - 14, baseY, middle + 14, topY, middle + 36, topY)
        ..lineTo(W - 48, topY)
        ..cubicTo(W - 36, topY, W - 18, baseY, W, baseY);
      canvas.drawPath(activePath, activeBorderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant SwiggyTabPainter oldDelegate) {
    return oldDelegate.isMeal != isMeal || oldDelegate.color != color;
  }
}

class SwiggyTabsHeader extends GetView<HomeController> {
  const SwiggyTabsHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isMeal = controller.activeTab.value == 0;
      final mealColor = const Color(0xffFD6702); // Swiggy Orange
      final workoutColor = const Color(0xff3F72AF); // Soft Blue
      final activeColor = isMeal ? mealColor : workoutColor;

      return Container(
        color: const Color(0xff06010F), // App dark background
        width: double.infinity,
        height: 80,
        child: Stack(
          children: [
            // 1. The Custom Painted Swiggy Background
            Positioned.fill(
              child: CustomPaint(
                painter: SwiggyTabPainter(isMeal: isMeal, color: activeColor),
              ),
            ),

            // 2. The Interactive Labels & Icons
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // MEAL TAB
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.activeTab.value = 0,
                        child: Container(
                          height: 80, // Always full height to ensure correct alignment
                          color: Colors.transparent, // Detect taps anywhere in the area
                          padding: EdgeInsets.only(
                            top: isMeal ? 0 : 6,
                            bottom: isMeal ? 6 : 0,
                          ),
                          child: Column(
                            mainAxisAlignment: isMeal
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Text(
                                "🍔",
                                style: TextStyle(fontSize: isMeal ? 18 : 14),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Meal",
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: isMeal
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: isMeal ? 14 : 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // WORKOUT TAB
                    Expanded(
                      child: GestureDetector(
                        onTap: () => controller.activeTab.value = 1,
                        child: Container(
                          height: 80, // Always full height
                          color: Colors.transparent,
                          padding: EdgeInsets.only(
                            top: !isMeal ? 0 : 6,
                            bottom: !isMeal ? 6 : 0,
                          ),
                          child: Column(
                            mainAxisAlignment: !isMeal
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Text(
                                "💪",
                                style: TextStyle(fontSize: !isMeal ? 18 : 14),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                "Workout",
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontWeight: !isMeal
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  fontSize: !isMeal ? 14 : 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
