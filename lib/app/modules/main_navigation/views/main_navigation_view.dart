import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/main_navigation_controller.dart';
import '../../home/views/home_view.dart';
import '../../meal/views/meal_view.dart';
import '../../progress/views/progress_view.dart';
import '../../profile/views/profile_view.dart';
import '../../../services/auth_service.dart';
import '../../booking/views/expert_dashboard_view.dart';
import '../../booking/views/expert_slots_view.dart';

class MainNavigationView extends GetView<MainNavigationController> {
  const MainNavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    final isExpert =
        authService.userRole == 'CONSULTANT' || authService.userRole == 'ADMIN';

    final List<Widget> pages = isExpert
        ? [const ExpertDashboardView(), const ExpertSlotsView()]
        : [
            const HomeView(),
            const MealView(),
            const ProgressView(),
            const ProfileView(),
          ];

    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          // Render active tab page
          Obx(
            () => IndexedStack(
              index: controller.selectedIndex.value,
              children: pages,
            ),
          ),
        ],
      ),
      bottomNavigationBar: buildBottomNavigationBar(context, isExpert),
    );
  }

  static const double _navBarHeight = 76;
  static const double _navBarRadius = 40;

  Widget buildBottomNavigationBar(BuildContext context, bool isExpert) {
    // Extend the bar's fill down through the OS gesture-safe-area inset too,
    // so that strip shows the bar's own color instead of the bare Scaffold
    // background peeking out beneath it.
    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return Obx(() {
      final activeIndex = controller.selectedIndex.value;
      final visible = controller.isNavBarVisible.value;
      final double totalHeight = _navBarHeight + bottomInset;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        height: visible ? totalHeight : 0,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(),
        child: OverflowBox(
          minHeight: totalHeight,
          maxHeight: totalHeight,
          alignment: Alignment.topCenter,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: visible ? 1.0 : 0.0,
            child: Container(
              width: double.infinity,
              height: totalHeight,
              padding: EdgeInsets.only(bottom: bottomInset),
              decoration: const BoxDecoration(
                color: Color(0xff0D0620),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(_navBarRadius),
                  topRight: Radius.circular(_navBarRadius),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: isExpert
                    ? [
                        navItem(
                          Icons.dashboard_outlined,
                          Icons.dashboard_rounded,
                          "Sessions",
                          activeIndex == 0,
                          0,
                        ),
                        navItem(
                          Icons.calendar_month_outlined,
                          Icons.calendar_month_rounded,
                          "Slots",
                          activeIndex == 1,
                          1,
                        ),
                      ]
                    : [
                        navItem(
                          Icons.home_outlined,
                          Icons.home_rounded,
                          "Dashboard",
                          activeIndex == 0,
                          0,
                        ),
                        navItem(
                          Icons.restaurant_outlined,
                          Icons.restaurant_rounded,
                          "Meals",
                          activeIndex == 1,
                          1,
                        ),
                        navItem(
                          Icons.bar_chart_outlined,
                          Icons.bar_chart_rounded,
                          "Progress",
                          activeIndex == 2,
                          2,
                        ),
                      ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget navItem(
    IconData outlineIcon,
    IconData filledIcon,
    String label,
    bool active,
    int index,
  ) {
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
                          backgroundColor: const Color(
                            0xff00E5FF,
                          ).withOpacity(0.15),
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
                          backgroundColor: const Color(
                            0xffFF7A00,
                          ).withOpacity(0.15),
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
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
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
