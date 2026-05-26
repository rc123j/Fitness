import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    // Transparent immersive status bar overlays for premium styling
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF05060A),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xff05060A),
      body: Stack(
        children: [
          // 1. BACKGROUND IMAGE (Fitted to the upper part of the screen, shifted 90px to the right)
          Positioned(
            top: 0,
            left: 40,
            right: -50,
            height: screenHeight * 0.58,
            child: Image.asset(
              'assets/images/login_athlete.png',
              fit: BoxFit.cover,
              alignment: const Alignment(0.45, -0.32),
            ),
          ),

          // 2. SEAMLESS GRADIENT OVERLAY FILTER
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.58,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.12),
                    Colors.black.withOpacity(0.35),
                    Colors.black.withOpacity(0.85),
                    const Color(
                      0xff05060A,
                    ), // Seamlessly transitions to the Scaffold background color
                  ],
                  stops: const [0.0, 0.45, 0.85, 1.0],
                ),
              ),
            ),
          ),

          // 3. CINEMATIC NEON PURPLE GLOW (Top Left)
          Positioned(
            top: 120,
            left: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFF9E00FF).withOpacity(0.35),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 4. CINEMATIC NEON ORANGE GLOW (Middle Right)
          Positioned(
            top: 260,
            right: -100,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xFFFF5E00).withOpacity(0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // 5. SCROLLABLE FRONT LAYER (Keyboard friendly!)
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 18),

                    // BRAND LOGO (Cursive Neon-Glowing N)
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xFFFF00E5).withOpacity(0.04),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF8F39FF,
                                ).withOpacity(0.25),
                                blurRadius: 25,
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                              colors: [
                                Color(0xffFF7A00),
                                Color(0xffFF00E5),
                                Color(0xff7B61FF),
                              ],
                            ).createShader(bounds);
                          },
                          blendMode: BlendMode.srcIn,
                          child: Text(
                            'N',
                            style: GoogleFonts.satisfy(
                              fontSize: 54,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    // BRAND NAME
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'NUTRI',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 3,
                            ),
                          ),
                          TextSpan(
                            text: 'FIT',
                            style: GoogleFonts.outfit(
                              color: const Color(
                                0xffFF00E5,
                              ), // Rich pink matching registration view exactly
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      'FUEL YOUR BEST SELF',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(
                          0.70,
                        ), // White opacity tagline matching registration view exactly
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                      ),
                    ),

                    // Spacing to separate header from Welcome Back text
                    SizedBox(height: screenHeight * 0.05),

                    // WELCOME BACK TITLE (Matching mockup gradient precisely)
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Welcome\n',
                            style: GoogleFonts.outfit(
                              fontSize: 54,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.0,
                            ),
                          ),
                          TextSpan(
                            text: 'Back',
                            style: GoogleFonts.outfit(
                              fontSize: 54,
                              fontWeight: FontWeight.w900,
                              height: 1.0,
                              foreground: Paint()
                                ..shader =
                                    const LinearGradient(
                                      colors: [
                                        Color(0xffFF00E5), // Neon Magenta
                                        Color(0xffFF7A00), // Neon Orange
                                      ],
                                    ).createShader(
                                      const Rect.fromLTWH(
                                        0.0,
                                        0.0,
                                        200.0,
                                        70.0,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    Text(
                      'Log in to continue your\nfitness transformation.',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.72),
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        height: 1.45,
                      ),
                    ),

                    const SizedBox(height: 34),

                    // EMAIL FIELD
                    buildField(
                      hint: 'Email Address',
                      icon: Icons.person_outline_rounded,
                    ),

                    const SizedBox(height: 16),

                    // PASSWORD FIELD
                    buildField(
                      hint: 'Password',
                      icon: Icons.lock_outline_rounded,
                      suffix: Icons.visibility_outlined,
                    ),

                    const SizedBox(height: 16),

                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          // Trigger forgot password
                        },
                        child: Text(
                          'Forgot Password?',
                          style: GoogleFonts.inter(
                            color: const Color(
                              0xFFB37BFF,
                            ), // Soft neon lavender
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // LOGIN CAPSULE BUTTON
                    Container(
                      height: 64,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(32),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xffB000FF), // Neon purple
                            Color(0xffFF5E00), // Neon orange
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xffB000FF).withOpacity(0.4),
                            blurRadius: 20,
                            spreadRadius: 1,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(32),
                          onTap: () {
                            // Navigate to Goal Selection onboarding flow on successful login
                            Get.offAllNamed('/goal-selection');
                          },
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Log In',
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    Center(
                      child: Text(
                        'OR CONTINUE WITH',
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.45),
                          letterSpacing: 2,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // SOCIAL BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: socialButton(
                            title: 'Google',
                            logoWidget: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Standard colored Google G icon
                                Image.network(
                                  'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png',
                                  height: 20,
                                  width: 20,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text(
                                      'G',
                                      style: GoogleFonts.outfit(
                                        color: Colors.redAccent,
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: socialButton(
                            title: 'Apple',
                            logoWidget: const Icon(
                              Icons.apple_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.toNamed('/register');
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Don’t have an account? ',
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.65),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'Sign Up',
                                style: GoogleFonts.inter(
                                  color: const Color(
                                    0xffFF00E5,
                                  ), // Rich pink redirect link
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: const Color(
                                        0xffFF00E5,
                                      ).withOpacity(0.3),
                                      blurRadius: 8,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField({
    required String hint,
    required IconData icon,
    IconData? suffix,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 64,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black.withOpacity(0.24),
            border: Border.all(
              color: Colors.white.withOpacity(0.06),
              width: 0.8,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: const Color(
                  0xFFB066FF,
                ).withOpacity(0.85), // Soft neon lavender
                size: 22,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: TextField(
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 15),
                  obscureText: hint.toLowerCase().contains('password'),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.40),
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
              if (suffix != null)
                Icon(suffix, color: Colors.white.withOpacity(0.45), size: 22),
            ],
          ),
        ),
      ),
    );
  }

  Widget socialButton({required String title, required Widget logoWidget}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(0.28),
        border: Border.all(color: Colors.white.withOpacity(0.06), width: 0.8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            // Trigger social login
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                logoWidget,
                const SizedBox(width: 10),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
