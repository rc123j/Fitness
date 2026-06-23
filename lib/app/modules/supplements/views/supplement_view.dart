import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/supplement_controller.dart';
import '../../../widgets/premium_layout_components.dart';

class SupplementView extends GetView<SupplementController> {
  const SupplementView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          /// BACKGROUND GLOW BLOBS
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

          /// SCROLLABLE UI CONTENT
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

                        /// 1. SEARCH BAR
                        buildSearchBar(),
                        const SizedBox(height: 20),

                        /// 2. CATEGORIES SELECTOR ROW
                        buildCategoryTabs(),
                        const SizedBox(height: 20),

                        /// 3. DYNAMIC PRODUCTS GRID
                        Obx(() {
                          final items = controller.filteredSupplements;
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
                              return buildSupplementCard(context, item);
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
    return PremiumAppBar(
      title: "Smart Supplements",
      subtitle: "Goal-driven nutrition recommendations",
      trailing: Container(
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
        child: const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 18),
      ),
    );
  }

  /// ----------------------------------------------------
  /// 1. SEARCH BAR
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
                hintText: "Search protein, creatine, fish oil...",
                hintStyle: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 2. CATEGORIES SELECTOR
  /// ----------------------------------------------------
  Widget buildCategoryTabs() {
    final categories = ["All", "Protein", "Performance", "Wellness", "Essentials"];
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Obx(() {
            final isActive = controller.selectedCategory.value == cat;
            Color activeColor = const Color(0xffFF00E5);
            if (cat == "Performance") activeColor = const Color(0xffB100FF);
            if (cat == "Wellness") activeColor = const Color(0xffFF7A00);
            if (cat == "Essentials") activeColor = const Color(0xff00E5FF);

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
  /// 3. SUPPLEMENT CARD
  /// ----------------------------------------------------
  Widget buildSupplementCard(BuildContext context, Map<String, dynamic> item) {
    Color accentColor = const Color(0xffFF00E5);
    if (item["category"] == "Performance") accentColor = const Color(0xffB100FF);
    if (item["category"] == "Wellness") accentColor = const Color(0xffFF7A00);
    if (item["category"] == "Essentials") accentColor = const Color(0xff00E5FF);

    return GestureDetector(
      onTap: () => showDetailsModal(context, item, accentColor),
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
              /// Image Box
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
                          item["image"]!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.fitness_center_rounded,
                            color: Colors.white24,
                            size: 32,
                          ),
                        ),
                      ),
                    ),

                    /// Category Badge
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
                          item["category"],
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

              /// Brand Name
              Text(
                item["brand"].toString().toUpperCase(),
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 7.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 3),

              /// Product Name
              Text(
                item["name"],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),

              /// Ratings Row
              Row(
                children: [
                  const Icon(Icons.star_rounded, color: Color(0xffFFD700), size: 10),
                  const SizedBox(width: 2),
                  Text(
                    "${item['rating']} (${item['reviews']})",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.40),
                      fontSize: 8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              /// Price & CTA
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "₹${item['price']}",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.purchaseSupplement(item["name"], item["price"]),
                    child: Container(
                      height: 26,
                      width: 26,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [accentColor, accentColor.withOpacity(0.6)],
                        ),
                      ),
                      child: const Icon(Icons.add_rounded, color: Colors.white, size: 16),
                    ),
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
  void showDetailsModal(BuildContext context, Map<String, dynamic> item, Color accentColor) {
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
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22.0),
              child: Column(
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
                  const SizedBox(height: 18),

                  /// Header Info (Image + Title)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.white.withOpacity(0.02),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.network(item["image"], fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["brand"].toString().toUpperCase(),
                              style: GoogleFonts.inter(
                                color: accentColor,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item["name"],
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(Icons.star_rounded, color: Color(0xffFFD700), size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  "${item['rating']} (${item['reviews']} Reviews)",
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.50),
                                    fontSize: 10,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  item["servings"],
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.40),
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// Description
                  Text(
                    "Description",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item["desc"],
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.60),
                      fontSize: 11,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Recommended Dosage
                  Text(
                    "Recommended Intake",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.04), width: 0.8),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: accentColor, size: 16),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item["dosage"],
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 11,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Price & Action Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Total Price",
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.40),
                              fontSize: 9,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "₹${item['price']}",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 44,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          gradient: LinearGradient(
                            colors: [accentColor, accentColor.withOpacity(0.8)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextButton(
                          onPressed: () {
                            controller.purchaseSupplement(item["name"], item["price"]);
                            Get.back();
                          },
                          child: Text(
                            "Order Now",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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

  /// Empty state display
  Widget buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          const Icon(Icons.fitness_center_rounded, color: Colors.white24, size: 48),
          const SizedBox(height: 14),
          Text(
            "No supplements found",
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
