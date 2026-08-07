import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class CongratulationsScreen extends StatefulWidget {
  final String memberCode;
  const CongratulationsScreen({super.key, required this.memberCode});

  @override
  State<CongratulationsScreen> createState() => _CongratulationsScreenState();
}

class _CongratulationsScreenState extends State<CongratulationsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _confettiController;
  final List<ConfettiParticle> _particles = [];
  final _random = math.Random();

  @override
  void initState() {
    super.initState();

    // Initialize Confetti Particles — subtle, fewer, smaller
    for (int i = 0; i < 30; i++) {
      _particles.add(
        ConfettiParticle(
          x: _random.nextDouble(),
          y: -_random.nextDouble() * 0.8,
          size: _random.nextDouble() * 5 + 3,
          color: _getRandomColor(),
          speedY: _random.nextDouble() * 1.5 + 1.0,
          speedX: _random.nextDouble() * 0.8 - 0.4,
          rotation: _random.nextDouble() * 2 * math.pi,
          rotationSpeed: _random.nextDouble() * 2 - 1,
        ),
      );
    }

    _confettiController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..addListener(() {
            setState(() {
              for (var p in _particles) {
                p.y += p.speedY * 0.004;
                p.x += p.speedX * 0.001;
                p.rotation += p.rotationSpeed * 0.008;

                // Loop particles back to the top when they fall off the screen
                if (p.y > 1.1) {
                  p.y = -0.1;
                  p.x = _random.nextDouble();
                  p.speedY = _random.nextDouble() * 1.5 + 1.0;
                  p.speedX = _random.nextDouble() * 0.8 - 0.4;
                }
              }
            });
          });

    // Play continuously until the user navigates forward
    _confettiController.repeat();
  }

  Color _getRandomColor() {
    final colors = [
      const Color(0xffFF00E5), // Pink
      const Color(0xffFF7A00), // Orange
      const Color(0xff7B61FF), // Purple
      const Color(0xff00E5FF), // Teal
      const Color(0xff34C759), // Green
      const Color(0xffFFCC00), // Yellow
    ];
    return colors[_random.nextInt(colors.length)];
  }

  String _formatMemberCode(String code) {
    if (code.isEmpty) return "MEM - 0000 - 0000";
    String clean = code.replaceAll('-', '');
    if (clean.length > 3) {
      String prefix = clean.substring(0, 3);
      String rest = clean.substring(3);
      if (rest.length > 4) {
        return "$prefix - ${rest.substring(0, 4)} - ${rest.substring(4)}";
      }
      return "$prefix - $rest";
    }
    return code;
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050510),
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              height: 320,
              width: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffFF00E5).withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: Container(
              height: 280,
              width: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffFF7A00).withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Custom Confetti Animation Painter
          CustomPaint(
            size: Size.infinite,
            painter: ConfettiPainter(particles: _particles),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top Spacer (Replaced with SizedBox to push content up)
                const SizedBox(height: 20),

                // ── CONGRATULATIONS IMAGE HEADER
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.elasticOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Image.asset(
                        'assets/new_images/extra_active.png',
                        height: 250,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Subtitle
                Text(
                  "CONGRATULATIONS!",
                  style: GoogleFonts.outfit(
                    color: const Color(0xffFF00E5).withOpacity(0.95),
                    fontSize: 12,
                    letterSpacing: 2.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),

                // Main Message
                Text(
                  "Plan Activated Successfully",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 28),

                // ── SINGLE ULTRA-PREMIUM MEMBERSHIP PASS CARD
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutBack,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24),
                        width: double.infinity,
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.12),
                            width: 1.0,
                          ),
                          image: DecorationImage(
                            image: const AssetImage(
                              'assets/images/athlete.png',
                            ),
                            opacity:
                                0.6, // Lowered opacity to make the background more subtle
                            fit: BoxFit.cover,
                            alignment: const Alignment(
                              0,
                              -0.7,
                            ), // Shifts the image downwards inside the card
                            colorFilter: ColorFilter.mode(
                              Colors.black.withOpacity(0.4),
                              BlendMode.darken,
                            ),
                          ),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              const Color(0xffFF00E5).withOpacity(
                                0.2,
                              ), // Added some tint since we have a bg image
                              const Color(0xffFF7A00).withOpacity(0.2),
                            ],
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(23),
                          child: Padding(
                            padding: const EdgeInsets.all(22),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top row: Brand & EMV Chip
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "FITFUEL HEALTH PASS",
                                      style: GoogleFonts.outfit(
                                        color: Colors.white.withOpacity(0.75),
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    // Glowing Gold EMV Chip
                                    Container(
                                      height: 26,
                                      width: 34,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(
                                              0xffFFCC00,
                                            ).withOpacity(0.8),
                                            const Color(
                                              0xffFF7A00,
                                            ).withOpacity(0.8),
                                          ],
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(
                                              0xffFFCC00,
                                            ).withOpacity(0.2),
                                            blurRadius: 8,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                // Middle row: Member Code (Credit Card Style)
                                Text(
                                  _formatMemberCode(widget.memberCode),
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.5,
                                  ),
                                ),
                                const Spacer(),
                                // Bottom row: Status & Features snapshot
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "STATUS",
                                          style: GoogleFonts.outfit(
                                            color: Colors.white.withOpacity(
                                              0.4,
                                            ),
                                            fontSize: 9,
                                            letterSpacing: 1.0,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            Container(
                                              height: 6,
                                              width: 6,
                                              decoration: const BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: Color(0xff34C759),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              "ACTIVE",
                                              style: GoogleFonts.outfit(
                                                color: const Color(0xff34C759),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: const Color(
                                          0xffFF00E5,
                                        ).withOpacity(0.12),
                                      ),
                                      child: Text(
                                        "30-DAY PLAN",
                                        style: GoogleFonts.outfit(
                                          color: Colors
                                              .white, // Changed to white as requested
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),

                // Bottom Spacer
                const Spacer(flex: 2),

                // Let's Go Button (Floats at bottom)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xffB100FF),
                          Color(0xffFF5F6D),
                          Color(0xffFF7A00),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffB100FF).withOpacity(0.30),
                          blurRadius: 12,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          Get.offAllNamed('/main-navigation');
                        },
                        child: Center(
                          child: Text(
                            "Let's Go to Dashboard",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
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
}

class ConfettiParticle {
  double x;
  double y;
  double size;
  Color color;
  double speedY;
  double speedX;
  double rotation;
  double rotationSpeed;

  ConfettiParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
    required this.speedY,
    required this.speedX,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class ConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  ConfettiPainter({required this.particles});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (var p in particles) {
      paint.color = p.color;

      canvas.save();
      // Translate to particle coordinates
      canvas.translate(p.x * size.width, p.y * size.height);
      canvas.rotate(p.rotation);

      // Draw a small rotating rectangle/square confetti particle
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: p.size,
          height: p.size * 0.6,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
