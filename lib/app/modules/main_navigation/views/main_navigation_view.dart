import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/main_navigation_controller.dart';
import '../../home/views/home_view.dart';
import '../../meal/views/meal_view.dart';
import '../../progress/views/progress_view.dart';
// import '../../social/views/social_feed_view.dart';
import '../../profile/views/profile_view.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeView(),
      const MealView(),
      const ProgressView(),
      // const SocialFeedView(), // Excluded for Phase 1
      const ProfileView(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          // Render active tab page
          Obx(() => IndexedStack(
                index: controller.selectedIndex.value,
                children: pages,
              )),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(),
    );
  }

  Widget buildBottomNavigationBar() {
    return Obx(() {
      final activeIndex = controller.selectedIndex.value;

      return Container(
        height: 76,
        decoration: BoxDecoration(
          color: const Color(0xff090414).withOpacity(0.85),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          border: Border.all(color: Colors.white.withOpacity(0.04), width: 1),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                navItem(Icons.home_outlined, Icons.home_rounded, "Dashboard", activeIndex == 0, 0),
                navItem(Icons.restaurant_outlined, Icons.restaurant_rounded, "Meals", activeIndex == 1, 1),
                navItem(Icons.bar_chart_outlined, Icons.bar_chart_rounded, "Progress", activeIndex == 2, 2),
                // navItem(Icons.groups_outlined, Icons.groups_rounded, "Social", activeIndex == 3, 3), // Excluded for Phase 1
                navItem(Icons.person_outline_rounded, Icons.person_rounded, "Profile", activeIndex == 3, 3),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget navItem(IconData outlineIcon, IconData filledIcon, String label, bool active, int index) {
    Color activeColor = const Color(0xffFF00E5);
    Color inactiveColor = Colors.white.withOpacity(0.40);

    return GestureDetector(
      onTap: () => controller.changeTab(index),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              active ? filledIcon : outlineIcon,
              color: active ? activeColor : inactiveColor,
              size: 22,
            ),
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
      ),
    );
  }

  void showQuickLogSheet(BuildContext context) {
    Get.bottomSheet(
      ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xff090414).withOpacity(0.85),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(28),
                topRight: Radius.circular(28),
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.06),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top drag handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // Header
                Text(
                  "Quick Actions",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Log your daily metrics instantly",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 28),

                // Grid of actions
                GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    quickActionItem(
                      icon: Icons.local_drink_rounded,
                      color: const Color(0xff00E5FF),
                      title: "Log Water",
                      subtitle: "+250 ml",
                      onTap: () {
                        Get.back();
                        Get.snackbar(
                          "Water Logged",
                          "You logged +250ml of water. Stay hydrated! 💧",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: const Color(0xff00E5FF).withOpacity(0.15),
                          colorText: Colors.white,
                          borderColor: const Color(0xff00E5FF).withOpacity(0.3),
                          borderWidth: 1,
                        );
                      },
                    ),
                    quickActionItem(
                      icon: Icons.scale_rounded,
                      color: const Color(0xffFF7A00),
                      title: "Log Weight",
                      subtitle: "Track progress",
                      onTap: () {
                        Get.back();
                        controller.changeTab(2); // Progress tab
                        Get.snackbar(
                          "Progress Tracker",
                          "Redirected to Progress tab. View weight trend! 📈",
                          snackPosition: SnackPosition.TOP,
                          backgroundColor: const Color(0xffFF7A00).withOpacity(0.15),
                          colorText: Colors.white,
                          borderColor: const Color(0xffFF7A00).withOpacity(0.3),
                          borderWidth: 1,
                        );
                      },
                    ),
                    quickActionItem(
                      icon: Icons.rate_review_rounded,
                      color: const Color(0xffFF00E5),
                      title: "Create Post",
                      subtitle: "Share achievement",
                      onTap: () {
                        Get.back();
                        Get.toNamed('/create-post');
                      },
                    ),
                    quickActionItem(
                      icon: Icons.notifications_active_rounded,
                      color: const Color(0xff00FF87),
                      title: "Add Reminder",
                      subtitle: "Stay consistent",
                      onTap: () {
                        Get.back();
                        Get.toNamed('/reminders');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Close Button
                GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.06),
                        width: 0.8,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.outfit(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.6),
      isScrollControlled: true,
    );
  }

  Widget quickActionItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.03),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.05),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
