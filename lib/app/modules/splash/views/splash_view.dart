import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Set status bar to transparent with white icons for premium full-screen immersion
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
      backgroundColor: const Color(0xFF030406), // Ultra-dark luxury canvas
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          // ----------------------------------------------------
          // BACKGROUND NEON GLOWS (LAYERED DEPTH)
          // ----------------------------------------------------

          /// TOP PURPLE BACKDROP GLOW
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
                    const Color(0xFF8F39FF).withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// MID-RIGHT AMBER/ORANGE GLOW (RIM LIGHT SYNC)
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
                    const Color(0xFFFF5F00).withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// BOTTOM-LEFT CYAN/BLUE GLOW
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
                    const Color(0xFF00E5FF).withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // ----------------------------------------------------
          // CINEMATIC ATHLETE BACKGROUND IMAGE (TOP 58%)
          // ----------------------------------------------------
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
                  stops: [0.0, 0.72, 1.0], // Elegant fading gradient at the bottom
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/images/athlete.png',
                fit: BoxFit.cover,
                alignment: const Alignment(0, -0.45), // Centers the athletes perfectly, pushing bezel out of bounds
              ),
            ),
          ),

          // ----------------------------------------------------
          // SCROLLABLE INTERACTIVE FRONT LAYER
          // ----------------------------------------------------
          Positioned.fill(
            child: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      // Dynamic spacer to push UI controls below the focal athlete area
                      SizedBox(height: screenHeight * 0.39),

                      // 1. BRAND LOGO (Premium Cursive Neon-Glowing "N")
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFFF00E5).withOpacity(0.05),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF8F39FF).withOpacity(0.22),
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

                      // 2. BRAND NAME
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
                                color: const Color(0xFF8F39FF), // Glowing Neon Violet
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),

                      // 3. BRAND TAGLINE (Peach/Bronze Glow Gradient Style)
                      Text(
                        'FUEL YOUR BEST SELF',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 4.5,
                          color: const Color(0xFFFF9E7B).withOpacity(0.9), // Matching mockup rim tone
                        ),
                      ),

                      const SizedBox(height: 32),

                      // 4. THREE NEON GLASSMORPHIC CARDS
                      Row(
                        children: [
                          Expanded(
                            child: _buildFeatureCard(
                              icon: Icons.local_fire_department_rounded,
                              iconColor: const Color(0xFF9E00FF), // Neon Purple
                              title: 'Smart Nutrition',
                              subtitle: 'Personalized meal\nplans for you',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildFeatureCard(
                              icon: Icons.trending_up_rounded,
                              iconColor: const Color(0xFFFF00D6), // Neon Pink
                              title: 'Track Progress',
                              subtitle: 'Monitor your journey\nin real-time',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildFeatureCard(
                              icon: Icons.fitness_center_rounded,
                              iconColor: const Color(0xFFFF7A00), // Neon Orange
                              title: 'Better Performance',
                              subtitle: 'Workout smarter\nachieve more',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // 5. LIQUID GRADIENT CAPSULE BUTTON
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFFFF7A00), // Vibrant Orange
                              Color(0xFFFF00E5), // Rich Magenta
                              Color(0xFF7B61FF), // Deep Violet
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFF00E5).withOpacity(0.35),
                              blurRadius: 18,
                              spreadRadius: 1,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(28),
                            onTap: () {
                              Get.toNamed('/login');
                            },
                            child: Center(
                              child: Text(
                                'Get Started',
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

                      const SizedBox(height: 18),

                      // 6. LOGIN REDIRECT FOOTER
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/login');
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already have an account? ',
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'Login',
                                style: GoogleFonts.inter(
                                  color: const Color(0xFFB066FF), // Neon Purple text
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: const Color(0xFFB066FF).withOpacity(0.4),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // REUSABLE PREMIUM FEATURE CARD GENERATOR
  // ----------------------------------------------------
  Widget _buildFeatureCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1015).withOpacity(0.65), // Rich dark translucent glass
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.06), // Micro thin border
          width: 0.8,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Glowing Icon Container
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.12),
              boxShadow: [
                BoxShadow(
                  color: iconColor.withOpacity(0.2),
                  blurRadius: 12,
                  spreadRadius: -1,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 10),
          // Card Title
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
          // Card Subtitle
          Text(
            subtitle,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.45),
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
