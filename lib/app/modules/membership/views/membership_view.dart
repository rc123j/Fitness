import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/membership_controller.dart';

class MembershipView extends GetView<MembershipController> {
  const MembershipView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050510),
      body: Stack(
        children: [
          /// 1. Background Image
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.7,
            child: ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                  stops: [0.3, 1.0],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/new_images1/congratulation_screen.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          /// 2. Foreground Content
          SafeArea(
            child: Column(
              children: [
                buildAppBar(),
                const Spacer(),
                buildHeaderTitles(),
                const Spacer(),
                buildStackedCarousel(),
                const SizedBox(height: 24),
                // buildCountdownTimerCard(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// App Bar
  Widget buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                shape: BoxShape.circle,
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
          Text(
            "Upgrade Plan",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 48), // Balance spacing
        ],
      ),
    );
  }

  /// Header Titles
  Widget buildHeaderTitles() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          Text(
            "BECOME YOUR",
            style: GoogleFonts.outfit(
              color: Colors.white.withOpacity(0.7),
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            "BEST VERSION",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 42,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 0.8,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  "UNLIMITED HEALTH METRICS",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper metadata mapper based on plan duration
  String getSubtitle(String duration) {
    switch (duration) {
      case 'WEEKLY': return 'Try it out';
      case 'MONTHLY': return 'Flexible & Easy';
      case 'QUARTERLY': return 'Great Value';
      case 'ANNUAL': return 'Most Popular';
      case 'LIFETIME': return 'One-Time Payment';
      default: return 'Premium Access';
    }
  }

  String getPriceSub(String duration) {
    switch (duration) {
      case 'WEEKLY': return '/week';
      case 'MONTHLY': return '/month';
      case 'QUARTERLY': return '/3 months';
      case 'ANNUAL': return '/year';
      case 'LIFETIME': return ' forever';
      default: return '';
    }
  }

  List<String> getBullets(String duration) {
    switch (duration) {
      case 'WEEKLY':
        return [
          'Full Access to Workouts',
          'Basic Meal Suggestions',
          'Progress Tracking',
        ];
      case 'MONTHLY':
      case 'QUARTERLY':
        return [
          'Full Access to Workouts',
          'Custom Meal Plans',
          'Progress Tracking',
          'Expert Support',
        ];
      case 'ANNUAL':
      case 'LIFETIME':
        return [
          'Full Access to Workouts',
          'Custom Meal Plans',
          'Progress Tracking',
          'Expert Support',
          'Priority Coach Access',
          'Nutrition Guidance',
        ];
      default:
        return ['Premium Workouts', 'Custom Meal Plans', 'Progress Tracking'];
    }
  }

  String? getBadge(String duration) {
    if (duration == 'ANNUAL') return 'BEST VALUE';
    if (duration == 'QUARTERLY') return 'POPULAR';
    if (duration == 'LIFETIME') return 'BEST DEAL';
    return null;
  }

  String? getDiscount(String duration) {
    if (duration == 'ANNUAL') return 'Save 44%';
    if (duration == 'QUARTERLY') return 'Save 16%';
    return null;
  }

  /// Stacked Carousel Layout
  Widget buildStackedCarousel() {
    return SizedBox(
      height: 460,
      child: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xffFF00E5)),
          );
        }

        final plans = controller.plans;
        if (plans.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "No plans available right now.",
                  style: GoogleFonts.inter(color: Colors.white.withOpacity(0.5)),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => controller.refreshPlans(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.08),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Retry"),
                )
              ],
            ),
          );
        }

        final page = controller.pageOffset.value;

        return Stack(
          alignment: Alignment.center,
          children: [
            // 1. Z-indexed Visible Cards
            Builder(builder: (context) {
              List<MapEntry<double, Widget>> cardEntries = [];

              for (int i = 0; i < plans.length; i++) {
                final diff = (i - page);
                final absDiff = diff.abs();

                // Only render nearby cards for performance
                if (absDiff > 2.5) continue;

                final scale = (1.0 - absDiff * 0.15).clamp(0.6, 1.0);
                final opacity = (1.0 - absDiff * 0.35).clamp(0.0, 1.0);

                // Translate cards by 150px per page to create a strong overlap.
                final translate = diff * 150.0;

                final plan = plans[i];
                final String duration = plan['duration'] as String;

                cardEntries.add(
                  MapEntry(
                    absDiff,
                    Transform.translate(
                      offset: Offset(translate, 0),
                      child: Transform.scale(
                        scale: scale,
                        child: Opacity(
                          opacity: opacity,
                          child: SizedBox(
                            width: 290,
                            child: buildPlanCard(
                              index: i,
                              title: plan['title'] as String,
                              subtitle: getSubtitle(duration),
                              price: plan['price'] as String,
                              priceSub: getPriceSub(duration),
                              badgeText: getBadge(duration),
                              discountText: getDiscount(duration),
                              bullets: getBullets(duration),
                              isSelected: controller.selectedPlanIndex.value == i,
                              isHighlighted: duration == 'ANNUAL' || plans.length == 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }

              // Draw furthest cards first (bottom of stack)
              cardEntries.sort((a, b) => b.key.compareTo(a.key));

              return Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: cardEntries.map((e) => e.value).toList(),
              );
            }),

            // 2. Invisible PageView to capture scrolling and taps
            PageView.builder(
              controller: controller.pageController,
              clipBehavior: Clip.none,
              itemCount: plans.length,
              onPageChanged: (i) => controller.selectPlan(i),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    controller.selectPlan(index);
                    controller.pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: const SizedBox.expand(),
                );
              },
            ),
          ],
        );
      }),
    );
  }

  /// Helper Plan Card Builder
  Widget buildPlanCard({
    required int index,
    required String title,
    required String subtitle,
    required String price,
    required String priceSub,
    required List<String> bullets,
    required bool isSelected,
    String? badgeText,
    String? discountText,
    bool isHighlighted = false,
  }) {
    Color borderClr = isSelected
        ? const Color(0xffFF00E5)
        : Colors.white.withOpacity(0.04);

    return GestureDetector(
      onTap: () => controller.selectPlan(index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(horizontal: 10),
            padding: const EdgeInsets.only(
              top: 28,
              left: 20,
              right: 20,
              bottom: 24,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: isHighlighted
                  ? const Color(0xff140E26)
                  : const Color(0xff0B0817),
              border: Border.all(
                color: borderClr,
                width: isSelected ? 2.0 : 1.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: const Color(0xffFF00E5).withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.4),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      price,
                      style: GoogleFonts.outfit(
                        color: isHighlighted
                            ? const Color(0xffFFB800)
                            : Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      priceSub,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.4),
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                if (discountText != null) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffFF7A00).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      discountText,
                      style: GoogleFonts.inter(
                        color: const Color(0xffFF7A00),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 24),

                /// Bullet Points
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bullets.length,
                    itemBuilder: (context, idx) {
                      final bullet = bullets[idx];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(
                              Icons.check_circle_rounded,
                              color: Colors.white,
                              size: 14,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                bullet,
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 12,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                /// Button inside card
                GestureDetector(
                  onTap: () {
                    if (isSelected) {
                      controller.purchaseSelectedPlan();
                    } else {
                      controller.selectPlan(index);
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: isSelected
                          ? Colors.white
                          : Colors.white.withOpacity(0.04),
                      border: isSelected
                          ? null
                          : Border.all(
                              color: Colors.white.withOpacity(0.12),
                              width: 1.0,
                            ),
                    ),
                    child: Center(
                      child: Text(
                        isSelected ? "Proceed with Plan" : "Select Plan",
                        style: GoogleFonts.outfit(
                          color: isSelected ? Colors.black : Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Plan Badge (Best Value)
          if (badgeText != null)
            Positioned(
              top: -12,
              left: 26,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xffFFB800),
                ),
                child: Text(
                  badgeText,
                  style: GoogleFonts.outfit(
                    color: Colors.black,
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
}
