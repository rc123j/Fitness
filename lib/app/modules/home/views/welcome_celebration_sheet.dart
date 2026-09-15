import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeCelebrationSheet extends StatelessWidget {
  final int fitPoints;
  final VoidCallback onExplorePressed;

  const WelcomeCelebrationSheet({
    super.key,
    required this.fitPoints,
    required this.onExplorePressed,
  });

  static Future<void> show(
    BuildContext context, {
    required int fitPoints,
    required VoidCallback onExplorePressed,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.75),
      builder: (context) => WelcomeCelebrationSheet(
        fitPoints: fitPoints > 0 ? fitPoints : 100,
        onExplorePressed: onExplorePressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff9D4EDD), // Bright vibrant purple
            Color(0xff3A0CA3), // Deep rich purple
          ],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.8),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 4),

          // Top Banner Image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              'assets/home/bottom_sheet1.webp',
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),

          // Title
          Text(
            "CONGRATULATIONS!",
            style: GoogleFonts.outfit(
              color: const Color(0xffFFB800),
              fontSize: 14,
              fontWeight: FontWeight.w900,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Welcome Rewards Unlocked",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Here is everything included in your new profile",
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 24),

          // Benefit Card 1: 30 Days Free Trial
          _buildRewardTile(
            iconText: "🎁",
            title: "30 Days Free Premium Access",
            subtitle:
                "Full custom meal plan, macro tracking & daily logs unlocked",
            badgeColor: const Color(0xff00E5FF),
          ),
          const SizedBox(height: 12),

          // Benefit Card 2: 100 Bonus FitPoints
          _buildRewardTile(
            iconText: "🪙",
            title: "$fitPoints Bonus FitPoints Credited",
            subtitle: "Added to your in-app wallet for completing registration",
            badgeColor: const Color(0xffFFB800),
          ),
          const SizedBox(height: 12),

          // Benefit Card 3: Health Metrics & Analytics
          _buildRewardTile(
            iconText: "⚡",
            title: "Unlimited Health Analytics",
            subtitle: "BMI, BMR, TDEE calculations & weight progress tracking",
            badgeColor: const Color(0xffFF00E5),
          ),
          const SizedBox(height: 28),

          // CTA Button
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onExplorePressed();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
              ),
              child: Text(
                "Explore My Day 1 Meal Plan 🚀",
                style: GoogleFonts.outfit(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRewardTile({
    required String iconText,
    required String title,
    required String subtitle,
    required Color badgeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: badgeColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(iconText, style: const TextStyle(fontSize: 20)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11,
                    height: 1.2,
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
