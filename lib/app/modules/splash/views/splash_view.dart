import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/splash_controller.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView>
    with SingleTickerProviderStateMixin {
  late final SplashController controller;
  late final AnimationController _animController;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    controller = Get.find<SplashController>();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF030406),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFF030406),
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF8F39FF).withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.25,
            right: -120,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFF5F00).withValues(alpha: 0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: screenHeight * 0.15,
            left: -120,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF00E5FF).withValues(alpha: 0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.58,
            child: ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.72, 1.0],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/images/athlete.png',
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.45),
              ),
            ),
          ),
          Positioned.fill(
            child: SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.39),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color:
                                    const Color(0xFFFF00E5).withValues(alpha: 0.05),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF8F39FF)
                                        .withValues(alpha: 0.22),
                                    blurRadius: 40,
                                    spreadRadius: 10,
                                  ),
                                ],
                              ),
                            ),
                            ShaderMask(
                              shaderCallback: (bounds) {
                                return const LinearGradient(
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                  colors: [
                                    Color(0xFFFF7A00),
                                    Color(0xFFFF00E5),
                                    Color(0xFF7B61FF),
                                  ],
                                ).createShader(bounds);
                              },
                              blendMode: BlendMode.srcIn,
                              child: Text(
                                'N',
                                style: GoogleFonts.satisfy(
                                  fontSize: 98,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  height: 1.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'NUTRI',
                                style: GoogleFonts.outfit(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                  color: Colors.white,
                                ),
                              ),
                              TextSpan(
                                text: 'FIT',
                                style: GoogleFonts.outfit(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2,
                                  color: const Color(0xFF8F39FF),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'FUEL YOUR BEST SELF',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 4.5,
                            color: const Color(0xFFFF9E7B).withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            Expanded(
                              child: _buildFeatureCard(
                                icon: Icons.local_fire_department_rounded,
                                iconColor: const Color(0xFF9E00FF),
                                title: 'Smart Nutrition',
                                subtitle: 'Personalized meal\nplans for you',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildFeatureCard(
                                icon: Icons.trending_up_rounded,
                                iconColor: const Color(0xFFFF00D6),
                                title: 'Track Progress',
                                subtitle: 'Monitor your journey\nin real-time',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: _buildFeatureCard(
                                icon: Icons.fitness_center_rounded,
                                iconColor: const Color(0xFFFF7A00),
                                title: 'Better Performance',
                                subtitle: 'Workout smarter\nachieve more',
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 36),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "INITIALIZING AI HEALTH ENGINE",
                              style: GoogleFonts.outfit(
                                color: const Color(0xFFFF9E7B).withOpacity(0.6),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Glowing Linear Progress Bar matching button colors
                            Container(
                              height: 4,
                              width: 160,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.06),
                                borderRadius: BorderRadius.circular(2),
                              ),
                              child: Stack(
                                children: [
                                  TweenAnimationBuilder<double>(
                                    tween: Tween<double>(begin: 0.0, end: 1.0),
                                    duration: const Duration(milliseconds: 2000),
                                    builder: (context, value, child) {
                                      return FractionallySizedBox(
                                        widthFactor: value,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(2),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xffB100FF),
                                                Color(0xffFF5F6D),
                                                Color(0xffFF7A00),
                                              ],
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xffB100FF).withOpacity(0.5),
                                                blurRadius: 8,
                                                spreadRadius: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.04),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1015).withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.06),
          width: 0.8,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withValues(alpha: 0.12),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withValues(alpha: 0.2),
                  blurRadius: 12,
                  spreadRadius: -1,
                ),
              ],
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 11.5,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              color: Colors.white.withValues(alpha: 0.45),
              fontSize: 8.5,
              fontWeight: FontWeight.w400,
              height: 1.35,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
