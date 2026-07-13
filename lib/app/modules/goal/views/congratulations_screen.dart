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

    // 1. Initialize Confetti Particles
    for (int i = 0; i < 70; i++) {
      _particles.add(ConfettiParticle(
        x: _random.nextDouble(),
        y: -_random.nextDouble() * 0.5,
        size: _random.nextDouble() * 8 + 6,
        color: _getRandomColor(),
        speedY: _random.nextDouble() * 3 + 2,
        speedX: _random.nextDouble() * 2 - 1,
        rotation: _random.nextDouble() * 2 * math.pi,
        rotationSpeed: _random.nextDouble() * 4 - 2,
      ));
    }

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        setState(() {
          for (var p in _particles) {
            p.y += p.speedY * 0.005;
            p.x += p.speedX * 0.002;
            p.rotation += p.rotationSpeed * 0.01;

            // Reset particle to top if it goes off screen
            if (p.y > 1.1) {
              p.y = -0.1;
              p.x = _random.nextDouble();
            }
          }
        });
      });

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
            top: -100, right: -100,
            child: Container(
              height: 320, width: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xffFF00E5).withOpacity(0.15),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: -80, left: -80,
            child: Container(
              height: 280, width: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xffFF7A00).withOpacity(0.12),
                  Colors.transparent,
                ]),
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
                const SizedBox(height: 20),

                // ── CONGRATULATIONS ICON HEADER
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 84, width: 84,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xffFF00E5).withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xffFF00E5).withOpacity(0.3),
                            blurRadius: 30,
                            spreadRadius: 3,
                          ),
                        ],
                      ),
                    ),
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: 1.0),
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: const Icon(
                            Icons.celebration_rounded,
                            color: Color(0xffFF7A00),
                            size: 46,
                          ),
                        );
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Title
                Text(
                  "CONGRATULATIONS!",
                  style: GoogleFonts.outfit(
                    color: const Color(0xffFF00E5).withOpacity(0.95),
                    fontSize: 12, letterSpacing: 2.0, fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Plan Activated Successfully",
                  style: GoogleFonts.outfit(
                    color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.8),
                  ),
                  child: Text(
                    "MEMBER CODE: ${widget.memberCode}",
                    style: GoogleFonts.outfit(
                      color: const Color(0xff00E5FF),
                      fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Benefits Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "HERE IS WHAT'S UNLOCKED FOR YOU:",
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // Scrollable List of Premium Benefits
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        _buildBenefitCard(
                          title: "Personalized Daily Diet Plan",
                          desc: "A fully custom 5-meal daily schedule tailored to your Veg/Non-Veg type, macros, and medical exclusions.",
                          icon: Icons.restaurant_rounded,
                          color: const Color(0xffFF5F6D),
                        ),
                        _buildBenefitCard(
                          title: "AI Hydration & Intake Reminders",
                          desc: "Smart hourly notifications keeping you fully accountable and on track with water, meals, and supplements.",
                          icon: Icons.water_drop_rounded,
                          color: const Color(0xff00E5FF),
                        ),
                        _buildBenefitCard(
                          title: "Adaptive 30-Day Checkpoints",
                          desc: "At the end of each cycle, your metrics re-evaluate to automatically adjust and progress your nutrition plan.",
                          icon: Icons.refresh_rounded,
                          color: const Color(0xffFF7A00),
                        ),
                        _buildBenefitCard(
                          title: "Streaks, XP & Level Rewards",
                          desc: "Log daily meals to maintain streaks, earn fit points, level up, and unlock exclusive community badges.",
                          icon: Icons.workspace_premium_rounded,
                          color: const Color(0xffC026D3),
                        ),
                        _buildBenefitCard(
                          title: "Expert Video Consultation",
                          desc: "Free 1-on-1 scheduled sessions with certified nutritionists if you face plateauing or require customized corrections.",
                          icon: Icons.videocam_rounded,
                          color: const Color(0xff7B61FF),
                        ),
                      ],
                    ),
                  ),
                ),

                // Let's Go Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                  child: Container(
                    height: 48, width: double.infinity,
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
                          blurRadius: 12, spreadRadius: 1, offset: const Offset(0, 3),
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
                              color: Colors.white, fontSize: 16,
                              fontWeight: FontWeight.bold, letterSpacing: 0.5,
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

  Widget _buildBenefitCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.03),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 40, width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.12),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      desc,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.55), fontSize: 11.5, height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
        Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
