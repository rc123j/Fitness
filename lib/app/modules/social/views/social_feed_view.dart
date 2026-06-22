import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/social_controller.dart';

class SocialFeedView extends GetView<SocialController> {
  const SocialFeedView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          /// BACKGROUND NEON BLOBS
          Positioned(
            top: -120,
            left: -100,
            child: Container(
              height: 320,
              width: 320,
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
            bottom: -50,
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

          /// SCROLL BODY
          SafeArea(
            child: Column(
              children: [
                /// HEADER
                buildHeader(),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        /// 1. CREATE POST TRIGGER CARD (Glassmorphic)
                        buildCreatePostTrigger(),
                        const SizedBox(height: 20),

                        /// 2. FILTER CATEGORY ROW
                        buildCategoryTabs(),
                        const SizedBox(height: 20),

                        /// 3. SOCIAL POSTS LIST
                        Obx(() {
                          final items = controller.posts;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final post = items[index];
                              return buildPostCard(context, post);
                            },
                          );
                        }),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),

                /// BOTTOM NAVIGATION
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
        children: [
          /// Back button
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

          /// Titles
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Social Room",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Share transformations & motivate others",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          /// Search / Moderation action
          Container(
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
            child: const Icon(Icons.search_rounded, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 1. CREATE POST TRIGGER WIDGET
  /// ----------------------------------------------------
  Widget buildCreatePostTrigger() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: const Color(0xffFF00E5).withOpacity(0.18),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffFF00E5).withOpacity(0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          /// Active profile avatar (Arjun)
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: SizedBox(
              height: 36,
              width: 36,
              child: Image.network(
                "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=150",
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 14),

          /// Mimic Compose Box
          Expanded(
            child: GestureDetector(
              onTap: () => Get.toNamed('/create-post'),
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.02),
                  border: Border.all(color: Colors.white.withOpacity(0.05), width: 0.8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Share your daily transformation win...",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.35),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),

          /// Image upload shortcut
          GestureDetector(
            onTap: () => Get.toNamed('/create-post'),
            child: Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xffFF00E5).withOpacity(0.08),
              ),
              child: const Icon(Icons.add_photo_alternate_rounded, color: Color(0xffFF00E5), size: 18),
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 2. FILTER CATEGORY TABS
  /// ----------------------------------------------------
  Widget buildCategoryTabs() {
    final categories = ["Trending", "Recent", "Transformations"];
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Obx(() {
            final isActive = controller.activeTab.value == cat;
            Color activeColor = const Color(0xffFF00E5);
            if (cat == "Recent") activeColor = const Color(0xff00E5FF);
            if (cat == "Transformations") activeColor = const Color(0xffFF7A00);

            return GestureDetector(
              onTap: () => controller.activeTab.value = cat,
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 18),
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
                    cat,
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
  /// 3. SOCIAL POST CARD
  /// ----------------------------------------------------
  Widget buildPostCard(BuildContext context, Map<String, dynamic> post) {
    bool isLiked = post["isLikedByUser"] as bool;
    String? badge = post["achievementBadge"] as String?;
    Color badgeColor = badge != null ? Color(int.parse(post["badgeColor"] as String)) : Colors.white;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Card Header (Author details)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: SizedBox(
                    height: 36,
                    width: 36,
                    child: Image.network(post["authorAvatar"], fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post["authorName"],
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            post["postTime"],
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.35),
                              fontSize: 9,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            height: 3,
                            width: 3,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.20),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            post["postType"].toString().toUpperCase(),
                            style: GoogleFonts.outfit(
                              color: const Color(0xffFF00E5).withOpacity(0.70),
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(Icons.more_horiz_rounded, color: Colors.white.withOpacity(0.30), size: 18),
              ],
            ),
          ),

          /// Caption text
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              post["caption"],
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.80),
                fontSize: 11.5,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 12),

          /// Visual Image Attach + Floating Badge
          Stack(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.white.withOpacity(0.01),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(post["image"], fit: BoxFit.cover),
                ),
              ),

              /// Achievement Badge Floating label
              if (badge != null)
                Positioned(
                  top: 12,
                  right: 28,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: badgeColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: badgeColor.withOpacity(0.35), width: 0.8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.emoji_events_rounded, color: badgeColor, size: 12),
                            const SizedBox(width: 6),
                            Text(
                              badge,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),

          /// Interaction panel (Likes, Comments, Shares)
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    /// Like Trigger
                    GestureDetector(
                      onTap: () => controller.toggleLike(post["id"] as int),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: isLiked ? const Color(0xffFF00E5).withOpacity(0.10) : Colors.white.withOpacity(0.02),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isLiked ? const Color(0xffFF00E5).withOpacity(0.35) : Colors.white.withOpacity(0.04),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              isLiked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                              color: isLiked ? const Color(0xffFF00E5) : Colors.white.withOpacity(0.40),
                              size: 14,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "${post['likesCount']}",
                              style: GoogleFonts.outfit(
                                color: isLiked ? Colors.white : Colors.white.withOpacity(0.60),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    /// Comment Sheet Trigger
                    GestureDetector(
                      onTap: () => showCommentsSheet(context, post),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.02),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.04), width: 0.8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.chat_bubble_outline_rounded, color: Colors.white.withOpacity(0.40), size: 14),
                            const SizedBox(width: 6),
                            Text(
                              "${post['commentsCount']}",
                              style: GoogleFonts.outfit(
                                color: Colors.white.withOpacity(0.60),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                /// Share Shortcut
                GestureDetector(
                  onTap: () {
                    Get.snackbar(
                      "Share Achievement",
                      "External sharing link copied to clipboard successfully!",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.04), width: 0.8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.share_outlined, color: Colors.white.withOpacity(0.40), size: 14),
                        const SizedBox(width: 6),
                        Text(
                          "Share",
                          style: GoogleFonts.outfit(
                            color: Colors.white.withOpacity(0.60),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
  /// DETAILED COMMENTS SHEET MODAL
  /// ----------------------------------------------------
  void showCommentsSheet(BuildContext context, Map<String, dynamic> post) {
    final commentController = TextEditingController();

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: const Color(0xff090414),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.0),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Pill drag handle
                  Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    "Discussion Thread",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// Comments List
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemCount: (post["comments"] as List).length,
                      itemBuilder: (context, idx) {
                        final comment = Map<String, dynamic>.from(post["comments"][idx] as Map);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: SizedBox(
                                  height: 28,
                                  width: 28,
                                  child: Image.network(comment["avatar"] ?? "", fit: BoxFit.cover),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      comment["author"] ?? "",
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      comment["text"] ?? "",
                                      style: GoogleFonts.inter(
                                        color: Colors.white.withOpacity(0.60),
                                        fontSize: 10.5,
                                        height: 1.3,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Type comment input field
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withOpacity(0.05), width: 0.8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          child: TextField(
                            controller: commentController,
                            style: GoogleFonts.inter(color: Colors.white, fontSize: 12),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Add your voice to this streak...",
                              hintStyle: GoogleFonts.inter(color: Colors.white30, fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          controller.addComment(post["id"] as int, commentController.text);
                          Get.back(); // close modal sheet
                        },
                        child: Container(
                          height: 44,
                          width: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: const Color(0xffFF00E5),
                          ),
                          child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
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
          navItem(Icons.person_outline_rounded, "Profile", false, onTap: () => Get.offNamed('/profile')),
        ],
      ),
    );
  }

  Widget navItem(IconData icon, String label, bool active, {VoidCallback? onTap}) {
    Color activeColor = const Color(0xffFF00E5);
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
