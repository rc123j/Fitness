import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/profile_controller.dart';

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
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),

                        /// 1. User Info Header Card
                        buildUserInfoCard(),
                        const SizedBox(height: 20),

                        /// 2. User Stats Grid Box
                        buildStatsGridBox(),
                        const SizedBox(height: 20),

                        /// 3. NutriFit Premium Banner
                        buildPremiumCard(),
                        const SizedBox(height: 20),

                        /// 4. My Progress Metrics (Indicator Rings)
                        buildProgressSection(),
                        const SizedBox(height: 20),

                        /// 5. My Achievements (Hexagonal Badges)
                        buildAchievementsSection(),
                        const SizedBox(height: 20),

                        /// 6. Action List Options
                        buildOptionsList(),
                        const SizedBox(height: 16),

                        /// 7. Need Help? Card
                        buildNeedHelpCard(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                /// Bottom Navigation Bar
                buildBottomNav(),
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
          Text(
            "Profile",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
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
                  child: const Icon(Icons.notifications_none_rounded, color: Colors.white, size: 20),
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
                  child: const Icon(Icons.settings_outlined, color: Colors.white, size: 20),
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
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
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
              const Icon(
                Icons.verified,
                color: Color(0xffB100FF),
                size: 16,
              ),
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
                const Text(
                  "🔥",
                  style: TextStyle(fontSize: 12),
                ),
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
          border: Border.all(
            color: Colors.white.withOpacity(0.04),
            width: 1.0,
          ),
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
            onTap: () {},
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
  /// 4. MY PROGRESS SECTION
  /// ----------------------------------------------------
  Widget buildProgressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Progress",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed('/progress'),
              child: Row(
                children: [
                  Text(
                    "View All",
                    style: GoogleFonts.inter(
                      color: const Color(0xffFF00E5),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xffFF00E5), size: 10),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        /// Row of Progress Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildProgressIndicatorRing(
              value: "72.8 kg",
              label: "Weight",
              progress: 0.728,
              color: const Color(0xffFF7A00),
              icon: Icons.scale_rounded,
            ),
            buildProgressIndicatorRing(
              value: "16.2%",
              label: "Body Fat",
              progress: 0.55,
              color: const Color(0xffFF00E5),
              icon: Icons.accessibility_new_rounded,
            ),
            buildProgressIndicatorRing(
              value: "34.5 kg",
              label: "Muscle Mass",
              progress: 0.65,
              color: const Color(0xffB100FF),
              icon: Icons.fitness_center_rounded,
            ),
            buildProgressIndicatorRing(
              value: "23.4",
              label: "BMI",
              progress: 0.45,
              color: const Color(0xff00E5FF),
              icon: Icons.person_outline_rounded,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildProgressIndicatorRing({
    required String value,
    required String label,
    required double progress,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Column(
        children: [
          CustomPaint(
            size: const Size(60, 60),
            painter: ProgressRingPainter(progress: progress, color: color),
            child: SizedBox(
              height: 60,
              width: 60,
              child: Center(
                child: Icon(icon, color: color, size: 16),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.40),
              fontSize: 9,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 5. MY ACHIEVEMENTS SECTION
  /// ----------------------------------------------------
  Widget buildAchievementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Achievements",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () => Get.toNamed('/rewards-hub'),
              child: Row(
                children: [
                  Text(
                    "View All",
                    style: GoogleFonts.inter(
                      color: const Color(0xffFF00E5),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xffFF00E5), size: 10),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        /// Row of Hexagonal Badges
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            buildHexagonBadgeItem(
              title: "First Step",
              subtitle: "Complete\nYour Profile",
              color: const Color(0xffB100FF),
              icon: Icons.person_add_rounded,
            ),
            buildHexagonBadgeItem(
              title: "Consistent",
              subtitle: "7 Days\nStreak",
              color: const Color(0xffFF7A00),
              icon: Icons.whatshot_rounded,
            ),
            buildHexagonBadgeItem(
              title: "Dedicated",
              subtitle: "25 Workouts\nCompleted",
              color: const Color(0xffFF00E5),
              icon: Icons.fitness_center_rounded,
            ),
            buildHexagonBadgeItem(
              title: "Champion",
              subtitle: "50 Days\nStreak",
              color: const Color(0xffFFC700),
              icon: Icons.emoji_events_rounded,
            ),
          ],
        ),
      ],
    );
  }

  Widget buildHexagonBadgeItem({
    required String title,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    return Expanded(
      child: Column(
        children: [
          CustomPaint(
            size: const Size(54, 60),
            painter: HexagonBadgePainter(color: color),
            child: SizedBox(
              height: 60,
              width: 54,
              child: Center(
                child: Icon(icon, color: color, size: 18),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.40),
              fontSize: 7,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 6. OPTIONS LIST
  /// ----------------------------------------------------
  Widget buildOptionsList() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0B0817).withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          buildOptionRowItem(
            icon: Icons.shopping_bag_outlined,
            title: "My Orders",
            subtitle: "View your plans, orders & history",
            onTap: () {},
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
            icon: Icons.bookmark_border_rounded,
            title: "Saved Posts",
            subtitle: "Posts you've saved",
            onTap: () {},
          ),
          buildDivider(),
          buildOptionRowItem(
            icon: Icons.straighten_rounded,
            title: "My Measurements",
            subtitle: "Track your body measurements",
            onTap: () {},
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
      child: Divider(color: Colors.white.withOpacity(0.04), height: 1),
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
              Icon(icon, color: const Color(0xffFF00E5), size: 18),
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

  /// ----------------------------------------------------
  /// 7. NEED HELP? CARD
  /// ----------------------------------------------------
  Widget buildNeedHelpCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0B0817).withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.headset_mic_outlined, color: Color(0xffFF00E5), size: 18),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Need Help?",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Visit our Help Center",
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
      ),
    );
  }

  /// ----------------------------------------------------
  /// BOTTOM NAVIGATION BAR
  /// ----------------------------------------------------
  Widget buildBottomNav() {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: const Color(0xff090414),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border.all(color: Colors.white.withOpacity(0.04), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          navItem(Icons.home_outlined, "Home", false, onTap: () => Get.offNamed('/home')),
          navItem(Icons.restaurant_rounded, "Meal Plan", false, onTap: () => Get.offNamed('/meal-plan')),
          navItem(Icons.bar_chart_rounded, "Progress", false, onTap: () => Get.offNamed('/progress')),
          navItem(Icons.groups_rounded, "Experts", false, onTap: () => Get.offNamed('/booking')),
          navItem(Icons.person_rounded, "Profile", true, onTap: () {}),
        ],
      ),
    );
  }

  Widget navItem(IconData icon, String label, bool active, {VoidCallback? onTap}) {
    Color activeColor = const Color(0xffB100FF);
    Color inactiveColor = Colors.white.withOpacity(0.40);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: active ? activeColor : inactiveColor, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: active ? activeColor : inactiveColor,
              fontSize: 9,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
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

/// ----------------------------------------------------
/// PROGRESS RING PAINTER
/// ----------------------------------------------------
class ProgressRingPainter extends CustomPainter {
  final double progress; // 0.0 to 1.0
  final Color color;

  ProgressRingPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double stroke = 3.0;
    double radius = (size.width - stroke) / 2;
    Offset center = Offset(size.width / 2, size.height / 2);
    Rect rect = Rect.fromCircle(center: center, radius: radius);

    // Track ring
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = Colors.white.withOpacity(0.04)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke,
    );

    // Progress segment
    Paint arcPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, arcPaint);

    // Concentric glow arcs
    for (double i = 1; i <= 2; i++) {
      canvas.drawArc(
        rect,
        -pi / 2,
        2 * pi * progress,
        false,
        Paint()
          ..color = color.withOpacity(0.12 / i)
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke + (i * 2.0)
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ----------------------------------------------------
/// HEXAGON BADGE PAINTER
/// ----------------------------------------------------
class HexagonBadgePainter extends CustomPainter {
  final Color color;

  HexagonBadgePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;

    Path path = Path();
    path.moveTo(w * 0.5, 2);
    path.lineTo(w - 2, h * 0.25 + 1);
    path.lineTo(w - 2, h * 0.75 - 1);
    path.lineTo(w * 0.5, h - 2);
    path.lineTo(2, h * 0.75 - 1);
    path.lineTo(2, h * 0.25 + 1);
    path.close();

    // Background fill
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withOpacity(0.06)
        ..style = PaintingStyle.fill,
    );

    // Glowing border outline
    Paint borderPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    for (double i = 1; i <= 2; i++) {
      canvas.drawPath(
        path,
        Paint()
          ..color = color.withOpacity(0.12 / i)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5 + (i * 2.0),
      );
    }
    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
