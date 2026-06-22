import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/health_tips_controller.dart';

class HealthTipsView extends GetView<HealthTipsController> {
  const HealthTipsView({super.key});

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

          /// MAIN SCROLLABLE UI
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

                        /// 1. SEARCH INPUT BAR
                        buildSearchBar(),
                        const SizedBox(height: 20),

                        /// 2. CATEGORIES SELECTOR
                        buildCategoryTabs(),
                        const SizedBox(height: 20),

                        /// 3. ARTICLES/TIPS LIST
                        Obx(() {
                          final items = controller.filteredTips;
                          if (items.isEmpty) {
                            return buildEmptyState();
                          }
                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.65,
                            ),
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return buildArticleCard(context, item);
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
                  "Health Insights",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Science-based tips & lifestyle guides",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 10,
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
  /// 1. SEARCH INPUT BAR
  /// ----------------------------------------------------
  Widget buildSearchBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          Icon(Icons.search_rounded, color: Colors.white.withOpacity(0.40), size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              onChanged: (val) => controller.searchQuery.value = val,
              style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: "Search protein, keto, progressive overload...",
                hintStyle: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 2. CATEGORY TABS
  /// ----------------------------------------------------
  Widget buildCategoryTabs() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final cat = controller.categories[index];
          return Obx(() {
            final isActive = controller.selectedCategory.value == cat;
            Color activeColor = const Color(0xffFF00E5);
            if (cat == "Nutrition") activeColor = const Color(0xff00FF87);
            if (cat == "Workouts") activeColor = const Color(0xffFF7A00);
            if (cat == "Mental Health") activeColor = const Color(0xff00E5FF);
            if (cat == "Sleep") activeColor = const Color(0xffB100FF);

            return GestureDetector(
              onTap: () => controller.selectedCategory.value = cat,
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
  /// 3. ARTICLE CARD
  /// ----------------------------------------------------
  Widget buildArticleCard(BuildContext context, Map<String, dynamic> item) {
    final int id = item["id"] as int;
    final String title = item["title"] as String;
    final String subtitle = item["subtitle"] as String;
    final String category = item["category"] as String;
    final String readTime = item["readTime"] as String;
    final String imageUrl = item["image"] as String;
    final RxBool isLiked = item["isLiked"] as RxBool;

    Color accentColor = const Color(0xffFF00E5);
    if (category == "Nutrition") accentColor = const Color(0xff00FF87);
    if (category == "Workouts") accentColor = const Color(0xffFF7A00);
    if (category == "Mental Health") accentColor = const Color(0xff00E5FF);
    if (category == "Sleep") accentColor = const Color(0xffB100FF);

    return GestureDetector(
      onTap: () => showArticleDetailsModal(context, item, accentColor),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xff0B0817).withOpacity(0.55),
          border: Border.all(
            color: Colors.white.withOpacity(0.04),
            width: 1.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Article Image Header with category badge
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.02),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.article_rounded,
                            color: Colors.white24,
                            size: 32,
                          ),
                        ),
                      ),
                    ),

                    /// Category Badge overlay
                    Positioned(
                      top: 6,
                      left: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: accentColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: accentColor.withOpacity(0.35), width: 0.8),
                        ),
                        child: Text(
                          category,
                          style: GoogleFonts.outfit(
                            color: accentColor,
                            fontSize: 7.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              /// Read Time
              Text(
                readTime.toUpperCase(),
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 7.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),

              /// Article Title
              Text(
                title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 4),

              /// Subtitle
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 9.5,
                ),
              ),
              const SizedBox(height: 8),

              /// Footer: Likes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Obx(() {
                    final liked = isLiked.value;
                    return GestureDetector(
                      onTap: () => controller.toggleLike(id),
                      child: Row(
                        children: [
                          Icon(
                            liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            color: liked ? const Color(0xffFF00E5) : Colors.white24,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "${item['likes']}",
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.40),
                              fontSize: 9,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white.withOpacity(0.20),
                    size: 13,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ----------------------------------------------------
  /// DETAILED SHEET MODAL
  /// ----------------------------------------------------
  void showArticleDetailsModal(BuildContext context, Map<String, dynamic> item, Color accentColor) {
    final int id = item["id"] as int;
    final List<String> takeaways = List<String>.from(item["takeaways"]);

    Get.bottomSheet(
      Container(
        height: Get.height * 0.85,
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
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Cover Photo Banner
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        width: double.infinity,
                        foregroundDecoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              const Color(0xff090414).withOpacity(0.95),
                            ],
                          ),
                        ),
                        child: Image.network(item["image"], fit: BoxFit.cover),
                      ),

                      /// Drag pill
                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            height: 4,
                            width: 36,
                            decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),

                      /// Back arrow overlay
                      Positioned(
                        top: 20,
                        left: 16,
                        child: GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black45,
                              border: Border.all(color: Colors.white10),
                            ),
                            child: const Icon(Icons.close_rounded, color: Colors.white, size: 18),
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// Category and Time row
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: accentColor.withOpacity(0.35), width: 0.8),
                              ),
                              child: Text(
                                item["category"].toString().toUpperCase(),
                                style: GoogleFonts.outfit(
                                  color: accentColor,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Text(
                              item["readTime"],
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.40),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        /// Title
                        Text(
                          item["title"],
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 6),

                        /// Subtitle description
                        Text(
                          item["subtitle"],
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.50),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(height: 20),

                        /// Key takeaways checklist card
                        Text(
                          "KEY TAKEAWAYS",
                          style: GoogleFonts.outfit(
                            color: Colors.white.withOpacity(0.40),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.01),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white.withOpacity(0.04), width: 0.8),
                          ),
                          child: Column(
                            children: takeaways.map((point) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.check_circle_outline_rounded, color: Color(0xff00FF87), size: 14),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        point,
                                        style: GoogleFonts.inter(
                                          color: Colors.white.withOpacity(0.70),
                                          fontSize: 10.5,
                                          height: 1.35,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 24),

                        /// Main Paragraph Content
                        Text(
                          item["content"],
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.75),
                            fontSize: 12.5,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 35),

                        /// Footer Actions row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Obx(() {
                              final liked = (item["isLiked"] as RxBool).value;
                              return GestureDetector(
                                onTap: () => controller.toggleLike(id),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                  decoration: BoxDecoration(
                                    color: liked ? const Color(0xffFF00E5).withOpacity(0.08) : Colors.white.withOpacity(0.02),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: liked ? const Color(0xffFF00E5).withOpacity(0.35) : Colors.white.withOpacity(0.05),
                                      width: 0.8,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                                        color: liked ? const Color(0xffFF00E5) : Colors.white38,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        liked ? "Liked!" : "Like Article",
                                        style: GoogleFonts.outfit(
                                          color: liked ? Colors.white : Colors.white.withOpacity(0.50),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                            GestureDetector(
                              onTap: () {
                                Get.snackbar(
                                  "Share Article",
                                  "Copied research article link to clipboard.",
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.02),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.05),
                                    width: 0.8,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.share_rounded, color: Colors.white54, size: 15),
                                    const SizedBox(width: 8),
                                    Text(
                                      "Share Insight",
                                      style: GoogleFonts.outfit(
                                        color: Colors.white.withOpacity(0.70),
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
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

  /// Empty State Display
  Widget buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          const Icon(Icons.lightbulb_outline_rounded, color: Colors.white24, size: 48),
          const SizedBox(height: 14),
          Text(
            "No articles found",
            style: GoogleFonts.outfit(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Try adjusting your filters or search query.",
            style: GoogleFonts.inter(color: Colors.white30, fontSize: 10),
          ),
        ],
      ),
    );
  }
}
