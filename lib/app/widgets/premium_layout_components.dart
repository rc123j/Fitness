import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

/// A premium, reusable background widget that encapsulates
/// the dark purple canvas color and the glowing radial neon blobs.
class PremiumBackgroundWrapper extends StatelessWidget {
  final Widget child;
  const PremiumBackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff06010F),
      child: Stack(
        children: [
          /// Top-right radial neon glow blob
          Positioned(
            top: -120,
            right: -100,
            child: Container(
              height: 350,
              width: 350,
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

          /// Bottom-left radial neon glow blob
          Positioned(
            bottom: 100,
            left: -150,
            child: Container(
              height: 400,
              width: 400,
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

          /// Content
          child,
        ],
      ),
    );
  }
}

/// A premium, glassmorphic app bar row for sub-pages.
class PremiumAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onBackPressed;

  const PremiumAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          /// Back Button with thin glass border
          GestureDetector(
            onTap: onBackPressed ?? () => Get.back(),
            child: Container(
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
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 14),

          /// Title and subtitle layout
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.50),
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),

          if (trailing != null) trailing!,
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}
