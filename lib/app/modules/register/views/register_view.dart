import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    // Transparent immersive status bar overlays for premium styling
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. IMMERSIVE BACKGROUND IMAGE (Fitted to the upper part of the screen)
          Positioned(
            top: 0,
            left: 90, // Shifts the image 50px to the right
            right: -90, // Proportional offset to shift the image right
            height: screenHeight * 0.58,
            child: Image.asset(
              'assets/images/register_girl.png',
              fit: BoxFit.cover,
              alignment: const Alignment(
                0.70,
                -0.45,
              ), // Shifts the athlete slightly to the right side
            ),
          ),

          // 2. SEAMLESS GRADIENT OVERLAY FILTER (Fades smoothly to pure black)
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
                    Colors.black.withOpacity(
                      0.12,
                    ), // Clear top to keep neon/girl colors vibrant
                    Colors.black.withOpacity(0.35),
                    Colors.black.withOpacity(0.85),
                    Colors
                        .black, // Fades completely to black at the end of the image height
                  ],
                  stops: const [0.0, 0.45, 0.85, 1.0],
                ),
              ),
            ),
          ),

          // 3. SCROLLABLE FRONT LAYER (Keyboard friendly, matches mockup exactly)
          SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // BACK BUTTON (Clean left arrow matching mockup exactly)
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    const SizedBox(height: 24),

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
                              color: const Color(0xffFF00E5),
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
                        color: Colors.white.withOpacity(0.70),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.0,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // HEADLINE TITLE (Create Your Account)
                    Text(
                      'Create',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 48,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      'Your',
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 48,
                        height: 1.05,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Account',
                        style: GoogleFonts.outfit(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          height: 1.05,
                          foreground: Paint()
                            ..shader =
                                const LinearGradient(
                                  colors: [
                                    Color(0xffFF00E5),
                                    Color(0xffFF7A00),
                                  ],
                                ).createShader(
                                  const Rect.fromLTWH(0.0, 0.0, 220.0, 60.0),
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Underside gradient line separator
                    Container(
                      height: 4,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2.0),
                        gradient: const LinearGradient(
                          colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // SUBTITLE
                    Text(
                      'Join Nutrifit and start your\nfitness transformation journey.',
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.75),
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ERROR MESSAGE
                    Obx(() {
                      final msg = controller.errorMessage.value;
                      if (msg == null) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xffFF3B30).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xffFF3B30).withOpacity(0.3)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.error_outline, color: Color(0xffFF3B30), size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  msg,
                                  style: GoogleFonts.inter(color: Color(0xffFF3B30), fontSize: 13),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    // INPUTS (Clean Glassmorphic Input Fields)
                    buildField(
                      hint: 'Full Name',
                      icon: Icons.person_outline_rounded,
                      controller: controller.nameController,
                    ),

                    const SizedBox(height: 12),

                    buildField(
                      hint: 'Email Address',
                      icon: Icons.mail_outline_rounded,
                      controller: controller.emailController,
                    ),

                    const SizedBox(height: 12),

                    Obx(
                      () => buildField(
                        hint: 'Password',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        obscure: controller.obscurePassword.value,
                        onSuffixTap: controller.togglePasswordVisibility,
                        controller: controller.passwordController,
                      ),
                    ),

                    const SizedBox(height: 12),

                    Obx(
                      () => buildField(
                        hint: 'Confirm Password',
                        icon: Icons.lock_outline_rounded,
                        isPassword: true,
                        obscure: controller.obscureConfirmPassword.value,
                        onSuffixTap: controller.toggleConfirmPasswordVisibility,
                        controller: controller.confirmPasswordController,
                      ),
                    ),

                    const SizedBox(height: 14),

                    // TERMS CHECKBOX ROW
                    Row(
                      children: [
                        GestureDetector(
                          onTap: controller.toggleAgreeToTerms,
                          child: Obx(
                            () => Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: const Color(0xffFF00E5),
                                  width: 1.5,
                                ),
                                color: controller.agreeToTerms.value
                                    ? const Color(0xffFF00E5)
                                    : Colors.transparent,
                              ),
                              child: controller.agreeToTerms.value
                                  ? const Icon(
                                      Icons.check_rounded,
                                      size: 13,
                                      color: Colors.white,
                                    )
                                  : null,
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'I agree to the ',
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Terms of Service',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xffFF00E5),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                TextSpan(
                                  text: ' and ',
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: GoogleFonts.inter(
                                    color: const Color(0xffFF00E5),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),

                    // ACTION CAPSULE BUTTON
                    Obx(
                      () => Container(
                        height: 56,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xffB100FF),
                              Color(0xffFF5F6D),
                              Color(0xffFF7A00),
                            ],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xffB100FF).withOpacity(0.35),
                              blurRadius: 15,
                              spreadRadius: 1,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(28),
                            onTap: controller.isLoading.value ? null : () => controller.register(),
                            child: Center(
                              child: controller.isLoading.value
                                  ? const SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.5,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Create Account',
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // OR SIGN UP WITH DIVIDER
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: Divider(
                    //         color: Colors.white.withOpacity(0.12),
                    //         thickness: 1.0,
                    //       ),
                    //     ),
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 16),
                    //       child: Text(
                    //         'OR SIGN UP WITH',
                    //         style: GoogleFonts.inter(
                    //           color: Colors.white.withOpacity(0.40),
                    //           fontSize: 11,
                    //           fontWeight: FontWeight.w700,
                    //           letterSpacing: 1.5,
                    //         ),
                    //       ),
                    //     ),
                    //     Expanded(
                    //       child: Divider(
                    //         color: Colors.white.withOpacity(0.12),
                    //         thickness: 1.0,
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    // const SizedBox(height: 20),

                    // SOCIAL BUTTONS ROW
                    // Row(
                    //   children: [
                    //     Expanded(
                    //       child: socialButton(
                    //         title: 'Google',
                    //         logoWidget: Image.network(
                    //           'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1024px-Google_%22G%22_logo.svg.png',
                    //           height: 18,
                    //           width: 18,
                    //           errorBuilder: (context, error, stackTrace) {
                    //             return Text(
                    //               'G',
                    //               style: GoogleFonts.outfit(
                    //                 color: Colors.redAccent,
                    //                 fontSize: 20,
                    //                 fontWeight: FontWeight.bold,
                    //               ),
                    //             );
                    //           },
                    //         ),
                    //       ),
                    //     ),
                    //     const SizedBox(width: 16),
                    //     Expanded(
                    //       child: socialButton(
                    //         title: 'Apple',
                    //         logoWidget: const Icon(
                    //           Icons.apple_rounded,
                    //           color: Colors.white,
                    //           size: 22,
                    //         ),
                    //       ),
                    //     ),
                    //   ],
                    // ),

                    // const SizedBox(height: 32),

                    // FOOTER LOGIN REDIRECT LINK
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already have an account? ',
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.65),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: 'Log In',
                                style: GoogleFonts.inter(
                                  color: const Color(0xffFF00E5),
                                  fontSize: 14,
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
    bool isPassword = false,
    bool obscure = false,
    VoidCallback? onSuffixTap,
    TextEditingController? controller,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.04),
            border: Border.all(
              color: Colors.white.withOpacity(0.05),
              width: 0.8,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: Colors.white.withOpacity(
                  0.40,
                ), // Premium slate grey icons exactly as requested in mockup
                size: 20,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hint,
                    hintStyle: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.40),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              if (isPassword)
                GestureDetector(
                  onTap: onSuffixTap,
                  child: Icon(
                    obscure
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.white.withOpacity(0.55),
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget socialButton({required String title, required Widget logoWidget}) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.04),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 0.8),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Trigger social sign up
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
                    fontSize: 15,
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
