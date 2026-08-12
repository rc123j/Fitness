import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class SwiggyTabPainter extends CustomPainter {
  final bool isMeal;
  final Color color;

  SwiggyTabPainter({required this.isMeal, required this.color});

  void _addTabCurve(
    Path path,
    double startX,
    double width,
    double topY,
    double baseY, {
    bool leftFlare = true,
    bool rightFlare = true,
  }) {
    final double R = 14.0; // Bottom flare radius
    final double topR = 16.0; // Top corner radius
    final double endX = startX + width;

    if (leftFlare) {
      path.lineTo(startX, baseY);
      // Bottom left inward flare
      path.quadraticBezierTo(startX + R, baseY, startX + R, baseY - R);
    } else {
      path.lineTo(startX + R, baseY);
    }

    // Straight vertical line up
    path.lineTo(startX + R, topY + topR);
    // Top left rounded corner
    path.quadraticBezierTo(startX + R, topY, startX + R + topR, topY);

    // Flat top
    path.lineTo(endX - R - topR, topY);

    // Top right rounded corner
    path.quadraticBezierTo(endX - R, topY, endX - R, topY + topR);
    // Straight vertical line down

    if (rightFlare) {
      path.lineTo(endX - R, baseY - R);
      // Bottom right outward flare
      path.quadraticBezierTo(endX - R, baseY, endX, baseY);
    } else {
      path.lineTo(endX - R, baseY);
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final double W = size.width;
    final double H = size.height;
    final double baseY = 60.0;
    final double topY = 0.0;

    final double tabWidth =
        (W / 2) +
        12.0; // Pushes the intersection point slightly higher up the active tab's curve
    final double mealStartX = 0.0;
    final double workoutStartX = W - tabWidth;

    final activeBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final inactiveFillPaint = Paint()
      ..color = Colors.black.withOpacity(0.25) // Darker fill to look like tucked card on red background
      ..style = PaintingStyle.fill;

    final inactiveBorderPaint = Paint()
      ..color = Colors.white
          .withOpacity(0.15) // Slightly brighter border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    if (isMeal) {
      // 1. Draw inactive ghost outline (Workout)
      final inactivePath = Path();
      inactivePath.moveTo(workoutStartX, baseY);
      _addTabCurve(inactivePath, workoutStartX, tabWidth, topY, baseY);
      canvas.drawPath(inactivePath, inactiveFillPaint);
      canvas.drawPath(inactivePath, inactiveBorderPaint);

      // 2. Draw active background (Meal)
      final bgPath = Path();
      bgPath.moveTo(0, H);
      bgPath.lineTo(0, baseY);
      _addTabCurve(bgPath, mealStartX, tabWidth, topY, baseY);
      bgPath.lineTo(W, baseY);
      bgPath.lineTo(W, H);
      bgPath.close();
      canvas.drawPath(bgPath, paint);

      // 3. Draw active outline (Meal)
      final activePath = Path();
      activePath.moveTo(0, baseY);
      _addTabCurve(activePath, mealStartX, tabWidth, topY, baseY);
      activePath.lineTo(W, baseY);
      canvas.drawPath(activePath, activeBorderPaint);
    } else {
      // 1. Draw inactive ghost outline (Meal)
      final inactivePath = Path();
      inactivePath.moveTo(mealStartX, baseY);
      _addTabCurve(inactivePath, mealStartX, tabWidth, topY, baseY);
      canvas.drawPath(inactivePath, inactiveFillPaint);
      canvas.drawPath(inactivePath, inactiveBorderPaint);

      // 2. Draw active background (Workout)
      final bgPath = Path();
      bgPath.moveTo(0, H);
      bgPath.lineTo(0, baseY);
      _addTabCurve(bgPath, workoutStartX, tabWidth, topY, baseY);
      bgPath.lineTo(W, baseY);
      bgPath.lineTo(W, H);
      bgPath.close();
      canvas.drawPath(bgPath, paint);

      // 3. Draw active outline (Workout)
      final activePath = Path();
      activePath.moveTo(0, baseY);
      _addTabCurve(activePath, workoutStartX, tabWidth, topY, baseY);
      activePath.lineTo(W, baseY);
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
      final mealColor = const Color(0xff640F11); // Dark wine/maroon (Rakhi card)
      final workoutColor = const Color(0xff3F72AF); // Soft Blue for Workout
      final activeColor = isMeal ? mealColor : workoutColor;

      final inactiveBg = isMeal
          ? const Color(0xffB81F22).withOpacity(0.20) // Match the transparent red appbar color
          : const Color(0xff3F72AF).withOpacity(0.20);

      return Container(
        color: inactiveBg,
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
                          height:
                              80, // Always full height to ensure correct alignment
                          color: Colors
                              .transparent, // Detect taps anywhere in the area
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
