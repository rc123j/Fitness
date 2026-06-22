import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          /// BACKGROUND NEON BLOBS
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
                    const Color(0xffB100FF).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -120,
            child: Container(
              height: 380,
              width: 380,
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

          /// MAIN LAYOUT
          SafeArea(
            child: Column(
              children: [
                /// HEADER
                buildHeader(),

                /// BODY
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        /// 1. UNREAD ALERTS OVERVIEW
                        buildUnreadStatusBanner(),
                        const SizedBox(height: 20),

                        /// 2. FILTER CATEGORIES
                        buildFilterChips(),
                        const SizedBox(height: 20),

                        /// 3. NOTIFICATION FEED LIST
                        Obx(() {
                          final items = controller.filteredNotifications;
                          if (items.isEmpty) {
                            return buildEmptyState();
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return buildNotificationCard(context, item);
                            },
                          );
                        }),
                        const SizedBox(height: 30),
                      ],
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
        children: [
          /// Back Button
          GestureDetector(
            onTap: () => Get.back(),
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
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 14),

          /// Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Notification Hub",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Updates, streaks, and plan highlights",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          /// Quick Actions: Read All & Clear All
          Obx(() {
            final hasItems = controller.notificationsList.isNotEmpty;
            if (!hasItems) return const SizedBox.shrink();

            return Row(
              children: [
                /// Mark Read Icon
                GestureDetector(
                  onTap: () => controller.markAllAsRead(),
                  child: Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: const Icon(Icons.done_all_rounded, color: Colors.white54, size: 16),
                  ),
                ),
                const SizedBox(width: 8),

                /// Clear all text CTA
                GestureDetector(
                  onTap: () => controller.clearAll(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.withOpacity(0.20)),
                    ),
                    child: Text(
                      "Clear",
                      style: GoogleFonts.outfit(
                        color: Colors.red,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 1. UNREAD STATUS BANNER CARD
  /// ----------------------------------------------------
  Widget buildUnreadStatusBanner() {
    return Obx(() {
      final unread = controller.unreadCount;
      if (unread == 0) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: const Color(0xff0B0817).withOpacity(0.40),
            border: Border.all(color: Colors.white.withOpacity(0.03)),
          ),
          child: Row(
            children: [
              const Icon(Icons.check_circle_outline_rounded, color: Color(0xff00FF87), size: 18),
              const SizedBox(width: 12),
              Text(
                "You're all caught up! Zero unread notifications.",
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.60),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }

      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xff0B0817).withOpacity(0.55),
          border: Border.all(
            color: const Color(0xffFF00E5).withOpacity(0.20),
            width: 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xffFF00E5).withOpacity(0.12),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xffFF00E5).withOpacity(0.20),
                    blurRadius: 10,
                  )
                ],
              ),
              child: const Icon(Icons.mail_outline_rounded, color: Color(0xffFF00E5), size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$unread New Notifications",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Review recent workouts, nutritional details, and social activities.",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.50),
                      fontSize: 9.5,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  /// ----------------------------------------------------
  /// 2. FILTER CATEGORY CHIPS
  /// ----------------------------------------------------
  Widget buildFilterChips() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.filtersList.length,
        itemBuilder: (context, index) {
          final filter = controller.filtersList[index];
          return Obx(() {
            final isActive = controller.selectedFilter.value == filter;
            Color activeColor = const Color(0xffB100FF);
            if (filter == "Workouts") activeColor = const Color(0xffFF7A00);
            if (filter == "Nutrition") activeColor = const Color(0xff00FF87);
            if (filter == "Social") activeColor = const Color(0xffFF00E5);
            if (filter == "Alerts") activeColor = const Color(0xffB100FF);

            return GestureDetector(
              onTap: () => controller.selectedFilter.value = filter,
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isActive ? activeColor.withOpacity(0.08) : const Color(0xff0B0817).withOpacity(0.55),
                  border: Border.all(
                    color: isActive ? activeColor : Colors.white.withOpacity(0.04),
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    filter,
                    style: GoogleFonts.outfit(
                      color: isActive ? Colors.white : Colors.white.withOpacity(0.40),
                      fontSize: 11,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  /// ----------------------------------------------------
  /// 3. NOTIFICATION CARD (WITH DISMISSIBLE SWIPE ACTION)
  /// ----------------------------------------------------
  Widget buildNotificationCard(BuildContext context, Map<String, dynamic> item) {
    final int id = item["id"] as int;
    final String title = item["title"] as String;
    final String body = item["body"] as String;
    final String timestamp = item["timestamp"] as String;
    final String category = item["category"] as String;
    final RxBool isRead = item["isRead"] as RxBool;

    Color categoryColor = const Color(0xffB100FF);
    IconData categoryIcon = Icons.notifications_rounded;

    if (category == "Workouts") {
      categoryColor = const Color(0xffFF7A00);
      categoryIcon = Icons.fitness_center_rounded;
    } else if (category == "Nutrition") {
      categoryColor = const Color(0xff00FF87);
      categoryIcon = Icons.restaurant_menu_rounded;
    } else if (category == "Social") {
      categoryColor = const Color(0xffFF00E5);
      categoryIcon = Icons.chat_bubble_outline_rounded;
    } else if (category == "Alerts") {
      categoryColor = const Color(0xffB100FF);
      categoryIcon = Icons.warning_amber_rounded;
    }

    return Dismissible(
      key: Key(id.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (dir) => controller.deleteNotification(id),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(Icons.delete_sweep_rounded, color: Colors.white, size: 24),
      ),
      child: GestureDetector(
        onTap: () => controller.markAsRead(id),
        child: Obx(() {
          final read = isRead.value;
          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xff0B0817).withOpacity(0.55),
              border: Border.all(
                color: read ? Colors.white.withOpacity(0.04) : categoryColor.withOpacity(0.20),
                width: 1.0,
              ),
            ),
            child: Stack(
              children: [
                /// Left glow indicator edge if unread
                if (!read)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: 4,
                      decoration: BoxDecoration(
                        color: categoryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Glowing Category Icon
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: read ? Colors.white.withOpacity(0.02) : categoryColor.withOpacity(0.08),
                          border: Border.all(
                            color: read ? Colors.white.withOpacity(0.05) : categoryColor.withOpacity(0.20),
                          ),
                        ),
                        child: Icon(
                          categoryIcon,
                          color: read ? Colors.white.withOpacity(0.40) : categoryColor,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 14),

                      /// Notification texts
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Header row: Timestamp + Unread Dot
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  timestamp,
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.30),
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (!read)
                                  Container(
                                    height: 7,
                                    width: 7,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: categoryColor,
                                      boxShadow: [
                                        BoxShadow(
                                          color: categoryColor,
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            /// Title
                            Text(
                              title,
                              style: GoogleFonts.outfit(
                                color: read ? Colors.white.withOpacity(0.70) : Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),

                            /// Body Description
                            Text(
                              body,
                              style: GoogleFonts.inter(
                                color: read ? Colors.white.withOpacity(0.40) : Colors.white.withOpacity(0.60),
                                fontSize: 10.5,
                                height: 1.35,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  /// Empty State Widget
  Widget buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 70),
      child: Column(
        children: [
          const Icon(Icons.notifications_off_rounded, color: Colors.white24, size: 48),
          const SizedBox(height: 14),
          Text(
            "Clear notifications logs",
            style: GoogleFonts.outfit(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "You have removed all alerts and updates.",
            style: GoogleFonts.inter(color: Colors.white30, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
