import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/profile_controller.dart';
import '../../../widgets/app_shimmer.dart';
import '../../../widgets/scroll_nav_bar_binder.dart';
import 'coming_soon_view.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          /// Background Glow Blobs
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffFF00E5).withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffB100FF).withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// Scrollable Profile Content
          SafeArea(
            child: Column(
              children: [
                /// Header Row
                buildHeader(),

                /// Body Content
                Expanded(
                  child: ScrollNavBarBinder(
                    builder: (context, scrollController) =>
                        SingleChildScrollView(
                          controller: scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Obx(
                            () => AppShimmer(
                              enabled: controller.isLoading.value,
                              child: Column(
                                children: [
                                  const SizedBox(height: 10),
                                  buildUserInfoCard(),
                                  const SizedBox(height: 20),
                                  buildStatsGridBox(),
                                  const SizedBox(height: 20),
                                  buildPremiumCard(),
                                  const SizedBox(height: 20),
                                  buildOptionsList(),
                                  const SizedBox(height: 24),
                                ],
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

  /// ----------------------------------------------------
  /// HEADER WIDGET
  /// ----------------------------------------------------
  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => Get.back(),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              const SizedBox(width: 16),
              Text(
                "Profile",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Row(
            children: [
              /// Notification Icon
              GestureDetector(
                onTap: () {},
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
                    Icons.notifications_none_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 10),

              /// Settings Gear Icon
              GestureDetector(
                onTap: () => Get.toNamed('/settings'),
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
                    Icons.settings_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 1. USER INFO CARD
  /// ----------------------------------------------------
  Widget buildUserInfoCard() {
    return Obx(() {
      return Column(
        children: [
          /// Glowing circular avatar wrapper
          CustomPaint(
            size: const Size(100, 100),
            painter: AvatarGlowPainter(),
            child: SizedBox(
              height: 100,
              width: 100,
              child: Center(
                child: Container(
                  height: 86,
                  width: 86,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(43),
                    child: Image.network(
                      "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),

          /// User name & verified badge
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                controller.username.value,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.verified, color: Color(0xffB100FF), size: 16),
            ],
          ),
          const SizedBox(height: 4),

          /// Subtitle Member info
          Text(
            controller.userClass.value,
            style: GoogleFonts.inter(
              color: const Color(0xffB100FF),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),

          /// Streak Container Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xffFF7A00).withOpacity(0.08),
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color: const Color(0xffFF7A00).withOpacity(0.30),
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("🔥", style: TextStyle(fontSize: 12)),
                const SizedBox(width: 6),
                Text(
                  "${controller.streakCount.value} Days Streak",
                  style: GoogleFonts.inter(
                    color: const Color(0xffFF7A00),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }

  /// ----------------------------------------------------
  /// 2. STATS GRID BOX
  /// ----------------------------------------------------
  Widget buildStatsGridBox() {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xff0B0817).withOpacity(0.55),
          border: Border.all(color: Colors.white.withOpacity(0.04), width: 1.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildSingleStatItem(
              icon: Icons.fitness_center_rounded,
              value: "${controller.workoutsCount.value}",
              label: "Workouts",
              color: const Color(0xffB100FF),
            ),
            buildStatDivider(),
            buildSingleStatItem(
              icon: Icons.restaurant_rounded,
              value: "${controller.mealsLogged.value}",
              label: "Meals Logged",
              color: const Color(0xffFF00E5),
            ),
            buildStatDivider(),
            buildSingleStatItem(
              icon: Icons.scale_rounded,
              value: "${controller.weightChange.value.toStringAsFixed(1)} kg",
              label: "Weight Lost",
              color: const Color(0xffFF7A00),
            ),
            buildStatDivider(),
            buildSingleStatItem(
              icon: Icons.emoji_events_rounded,
              value: controller.fitPoints.value.toString().replaceAllMapped(
                RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                (Match m) => '${m[1]},',
              ),
              label: "FitPoints",
              color: const Color(0xff00FF87),
            ),
          ],
        ),
      );
    });
  }

  Widget buildStatDivider() {
    return Container(
      height: 35,
      width: 0.8,
      color: Colors.white.withOpacity(0.06),
    );
  }

  Widget buildSingleStatItem({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.40),
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 3. PREMIUM CARD
  /// ----------------------------------------------------
  Widget buildPremiumCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: const Color(0xffB100FF).withOpacity(0.12),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          /// Glowing Purple Crown Icon Container
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xffB100FF).withOpacity(0.12),
            ),
            child: const Icon(
              Icons.workspace_premium_rounded,
              color: Color(0xffB100FF),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),

          /// Description text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "NutriFit Premium",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "You are on Premium Plan\nNext billing on 25 May 2024",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 9,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),

          /// Manage Plan Button
          GestureDetector(
            onTap: () => Get.toNamed('/membership'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xffFF7A00).withOpacity(0.60),
                  width: 0.8,
                ),
              ),
              child: Text(
                "Manage Plan",
                style: GoogleFonts.outfit(
                  color: const Color(0xffFF7A00),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// OPTIONS LIST
  /// ----------------------------------------------------
  Widget buildOptionsList() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0B0817).withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 1.0),
      ),
      child: Column(
        children: [
          buildOptionRowItem(
            icon: Icons.trending_up_rounded,
            title: "My Progress",
            subtitle: "Track your fitness journey",
            onTap: () => Get.toNamed('/progress'),
          ),
          buildDivider(),
          buildOptionRowItem(
            icon: Icons.emoji_events_rounded,
            title: "My Achievements",
            subtitle: "View your badges and rewards",
            onTap: () => Get.toNamed('/rewards-hub'),
          ),
          buildDivider(),
          buildOptionRowItem(
            icon: Icons.calendar_today_outlined,
            title: "My Bookings",
            subtitle: "View your expert bookings",
            onTap: () => Get.toNamed('/booking'),
          ),
          buildDivider(),
          buildOptionRowItem(
            icon: Icons.straighten_rounded,
            title: "My Measurements",
            subtitle: "Track your body measurements",
            onTap: () =>
                Get.to(() => const ComingSoonView(title: "My Measurements")),
          ),
          buildDivider(),
          buildOptionRowItem(
            icon: Icons.photo_library_outlined,
            title: "Progress Photos",
            subtitle: "View your transformation",
            onTap: () => Get.toNamed('/progress-photos'),
          ),
        ],
      ),
    );
  }

  Widget buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(color: Colors.white.withOpacity(0.12), height: 1),
    );
  }

  Widget buildOptionRowItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.40),
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.20),
                size: 11,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ----------------------------------------------------
/// AVATAR GLOW PAINTER
/// ----------------------------------------------------
class AvatarGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 3.0;
    double radius = (size.width - strokeWidth) / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Glowing shadow - concentric circles (safe)
    for (double i = 1; i <= 3; i++) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth + (i * 2.0)
          ..color = const Color(0xffFF00E5).withOpacity(0.12 / i),
      );
    }
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
