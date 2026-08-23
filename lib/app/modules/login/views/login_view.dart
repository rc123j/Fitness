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
              physics: MediaQuery.of(context).viewInsets.bottom > 0
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
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
                            text: 'NUTRI\n',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                              height: 1.15,
                            ),
                          ),
                          TextSpan(
                            text: 'SHAPE',
                            style: GoogleFonts.outfit(
                              color: const Color(
                                0xffFF00E5,
                              ), // Rich pink matching registration view exactly
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 2,
                              height: 1.15,
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

                    // ERROR MESSAGE
                    Obx(() {
                      final msg = controller.errorMessage.value;
                      if (msg == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xffFF3B30).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xffFF3B30).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Color(0xffFF3B30),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  msg,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xffFF3B30),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    // SUCCESS MESSAGE (plain widget, not reactive — no crash risk)
                    if (controller.successMessage != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xff34C759).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xff34C759).withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline_rounded,
                                color: Color(0xff34C759),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  controller.successMessage!,
                                  style: GoogleFonts.inter(
                                    color: const Color(0xff34C759),
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // EMAIL FIELD
                    PremiumTextField(
                      hint: 'Email Address',
                      icon: Icons.person_outline_rounded,
                      controller: controller.emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),

                    const SizedBox(height: 16),

                    // PASSWORD FIELD
                    Obx(
                      () => PremiumTextField(
                        hint: 'Password',
                        icon: Icons.lock_outline_rounded,
                        suffix: controller.obscurePassword.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        obscureText: controller.obscurePassword.value,
                        onSuffixTap: () =>
                            controller.togglePasswordVisibility(),
                        controller: controller.passwordController,
                      ),
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
                    Obx(
                      () => Container(
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          gradient: const LinearGradient(
                            colors: [Color(0xffB000FF), Color(0xffFF5E00)],
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
                            onTap: controller.isLoading.value
                                ? null
                                : () => controller.login(),
                            child: Center(
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 26,
                                      width: 26,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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

  Widget socialButton({required String title, required Widget logoWidget}) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.black.withOpacity(0.28),
        border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.0),
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

class PremiumTextField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final IconData? suffix;
  final bool obscureText;
  final VoidCallback? onSuffixTap;
  final TextEditingController? controller;
  final TextInputType? keyboardType;

  const PremiumTextField({
    super.key,
    required this.hint,
    required this.icon,
    this.suffix,
    this.obscureText = false,
    this.onSuffixTap,
    this.controller,
    this.keyboardType,
  });

  @override
  State<PremiumTextField> createState() => _PremiumTextFieldState();
}

class _PremiumTextFieldState extends State<PremiumTextField> {
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    final highlightColor = const Color(0xffFF00E5); // Glowing neon magenta

    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: _isFocused
              ? Colors.black.withOpacity(0.4)
              : Colors.white.withOpacity(0.06),
          border: Border.all(
            color: _isFocused ? Colors.white : Colors.white.withOpacity(0.25),
            width: _isFocused ? 1.5 : 1.0,
          ),
          boxShadow: _isFocused
              ? [
                  BoxShadow(
                    color: highlightColor.withOpacity(0.12),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Icon(
              widget.icon,
              color: _isFocused
                  ? highlightColor
                  : Colors.white.withOpacity(0.40),
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: widget.controller,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                obscureText: widget.obscureText,
                keyboardType: widget.keyboardType,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: widget.hint,
                  hintStyle: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            if (widget.suffix != null)
              GestureDetector(
                onTap: widget.onSuffixTap,
                child: Icon(
                  widget.suffix,
                  color: _isFocused
                      ? highlightColor
                      : Colors.white.withOpacity(0.45),
                  size: 20,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
