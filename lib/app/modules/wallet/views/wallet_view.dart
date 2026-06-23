import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/wallet_controller.dart';
import '../../../widgets/premium_layout_components.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          /// BACKGROUND BLUR BLOBS
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              height: 320,
              width: 320,
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
          Positioned(
            bottom: 100,
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

          /// BODY CONTAINER
          SafeArea(
            child: Column(
              children: [
                /// HEADER
                buildHeader(),

                /// SCROLLABLE CONTENT
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        /// 1. WALLET/BALANCE CARD
                        buildWalletBalanceCard(),
                        const SizedBox(height: 24),

                        /// 2. EARN FITPOINTS SECTION
                        buildSectionHeader("Earn FitPoints"),
                        const SizedBox(height: 14),
                        buildEarnHorizontalList(),
                        const SizedBox(height: 24),

                        /// 3. LEVEL STATUS CARD
                        buildLevelStatusCard(),
                        const SizedBox(height: 24),

                        /// 4. REDEEM REWARDS SECTION
                        buildSectionHeader("Redeem Rewards"),
                        const SizedBox(height: 14),
                        buildRedeemHorizontalList(),
                        const SizedBox(height: 24),

                        /// 5. RECENT TRANSACTIONS SECTION
                        buildSectionHeader("Recent Transactions"),
                        const SizedBox(height: 14),
                        buildTransactionsList(),
                        const SizedBox(height: 24),
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
      title: "Rewards Hub",
      subtitle: "Earn points, unlock rewards, grow stronger",
      trailing: Row(
        children: [
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
            child: const Icon(Icons.card_giftcard_rounded, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 10),
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
            child: const Icon(Icons.history_rounded, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 1. WALLET/BALANCE CARD
  /// ----------------------------------------------------
  Widget buildWalletBalanceCard() {
    return Container(
      height: 162,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            /// Nebula background gradient
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xffB100FF).withOpacity(0.12),
                      Colors.transparent,
                    ],
                    center: Alignment.center,
                    radius: 0.8,
                  ),
                ),
              ),
            ),

            /// Content Grid
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  /// Left side: FitPoints Balance
                  Expanded(
                    flex: 11,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Your Balance",
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.50),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Obx(() {
                              return Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    numFormat(controller.fitPoints.value),
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      height: 1.0,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Icon(Icons.stars_rounded, color: Color(0xffFFD700), size: 16),
                                ],
                              );
                            }),
                            const SizedBox(height: 4),
                            Text(
                              "FitPoints",
                              style: GoogleFonts.outfit(
                                color: const Color(0xffFF00E5),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Obx(() => Text(
                                  "≈ \$${controller.fitPointsValue.value.toStringAsFixed(2)} Value",
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.40),
                                    fontSize: 8,
                                  ),
                                )),
                          ],
                        ),

                        /// View History Text
                        GestureDetector(
                          onTap: () {},
                          child: Row(
                            children: [
                              const Icon(Icons.history_toggle_off_rounded, color: Color(0xffB100FF), size: 12),
                              const SizedBox(width: 5),
                              Text(
                                "View History",
                                style: GoogleFonts.outfit(
                                  color: const Color(0xffB100FF),
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xffB100FF), size: 8),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Middle Portion: Custom Painted Ring with Icon
                  Expanded(
                    flex: 8,
                    child: Center(
                      child: CustomPaint(
                        size: const Size(82, 82),
                        painter: WalletRingPainter(),
                      ),
                    ),
                  ),

                  /// Right side: Cash balance & Withdraw
                  Expanded(
                    flex: 11,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Cash Balance",
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.50),
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Obx(() => Text(
                                  "\$${controller.cashBalance.value.toStringAsFixed(2)}",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold,
                                    height: 1.0,
                                  ),
                                )),
                            const SizedBox(height: 4),
                            Text(
                              "USD",
                              style: GoogleFonts.outfit(
                                color: const Color(0xffFF7A00),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        /// Withdraw Button
                        Container(
                          height: 34,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xffFF00E5),
                                Color(0xffFF7A00),
                              ],
                            ),
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.account_balance_rounded, color: Colors.white, size: 12),
                                    const SizedBox(width: 5),
                                    Text(
                                      "Withdraw",
                                      style: GoogleFonts.outfit(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 8),
                                  ],
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
            ),
          ],
        ),
      ),
    );
  }

  /// Helper format points
  String numFormat(int val) {
    if (val >= 1000) {
      double d = val / 1000;
      return "${d.toStringAsFixed(1)}k";
    }
    return "$val";
  }

  /// Section Header helper
  Widget buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Row(
            children: [
              Text(
                "View All",
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.40),
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.arrow_forward_ios_rounded, color: Colors.white.withOpacity(0.40), size: 10),
            ],
          ),
        ),
      ],
    );
  }

  /// ----------------------------------------------------
  /// 2. EARN FITPOINTS HORIZONTAL LIST
  /// ----------------------------------------------------
  Widget buildEarnHorizontalList() {
    return SizedBox(
      height: 98,
      child: Obx(() {
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: controller.earnTasks.length,
          itemBuilder: (context, index) {
            final task = controller.earnTasks[index];
            IconData iconData = Icons.star_rounded;
            Color iconClr = Colors.white;

            if (task["icon"] == "flame") {
              iconData = Icons.local_fire_department_rounded;
              iconClr = const Color(0xffFF7A00);
            } else if (task["icon"] == "dumbbell") {
              iconData = Icons.fitness_center_rounded;
              iconClr = const Color(0xffB100FF);
            } else if (task["icon"] == "bowl") {
              iconData = Icons.soup_kitchen_rounded;
              iconClr = const Color(0xffFF7A00);
            } else if (task["icon"] == "target") {
              iconData = Icons.track_changes_rounded;
              iconClr = const Color(0xffFF00E5);
            } else if (task["icon"] == "users") {
              iconData = Icons.groups_rounded;
              iconClr = const Color(0xffB100FF);
            }

            return GestureDetector(
              onTap: () {
                if (task["title"] == "Daily Check-in") {
                  controller.checkIn();
                }
              },
              child: Container(
                width: 96,
                margin: const EdgeInsets.only(right: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xff0B0817).withOpacity(0.55),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.04),
                    width: 0.8,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Circle Icon Wrapper
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: iconClr.withOpacity(0.12),
                      ),
                      child: Icon(iconData, color: iconClr, size: 16),
                    ),

                    /// Task Title
                    Text(
                      task["title"],
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    /// Reward badge
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "+${task["points"]}",
                          style: GoogleFonts.outfit(
                            color: iconClr,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 3),
                        const Icon(Icons.stars_rounded, color: Color(0xffFFD700), size: 10),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  /// ----------------------------------------------------
  /// 3. LEVEL STATUS CARD
  /// ----------------------------------------------------
  Widget buildLevelStatusCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          /// Trophy Icon Illustration
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xffB100FF).withOpacity(0.12),
            ),
            child: const Center(
              child: Icon(
                Icons.emoji_events_rounded,
                color: Color(0xffB100FF),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 14),

          /// Levels & Progress Text details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Level Up & Earn More!",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "The higher your level, the better the rewards.",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),

          /// Current status indicator
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Text(
                    "Current Level: ",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.40),
                      fontSize: 8,
                    ),
                  ),
                  Obx(() => Text(
                        controller.currentLevel.value,
                        style: GoogleFonts.outfit(
                          color: const Color(0xffFF7A00),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      )),
                ],
              ),
              const SizedBox(height: 6),

              /// Slim custom progress bar
              SizedBox(
                width: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: 1250 / 2000,
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xffFF7A00),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Obx(() => Text(
                          "${controller.currentXP.value} / ${controller.nextLevelXP.value} XP",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.40),
                            fontSize: 7,
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),

          /// Right Chevron
          Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white.withOpacity(0.25),
            size: 10,
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 4. REDEEM REWARDS HORIZONTAL CAROUSEL
  /// ----------------------------------------------------
  Widget buildRedeemHorizontalList() {
    return Column(
      children: [
        SizedBox(
          height: 154,
          child: Obx(() {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: controller.rewards.length,
              itemBuilder: (context, index) {
                final reward = controller.rewards[index];

                return Container(
                  width: 120,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xff0B0817).withOpacity(0.55),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.04),
                      width: 0.8,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Brand graphic box
                      buildBrandIcon(reward["brand"]),

                      /// Reward Title details
                      Column(
                        children: [
                          Text(
                            reward["title"],
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            reward["subtitle"],
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.40),
                              fontSize: 7,
                            ),
                          ),
                        ],
                      ),

                      /// FitPoints Cost
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${reward["points"]}",
                            style: GoogleFonts.outfit(
                              color: const Color(0xffFF7A00),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 3),
                          const Icon(Icons.stars_rounded, color: Color(0xffFFD700), size: 11),
                        ],
                      ),

                      /// Redeem button
                      GestureDetector(
                        onTap: () => controller.redeemReward(reward["points"]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white.withOpacity(0.03),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            "Redeem",
                            style: GoogleFonts.outfit(
                              color: const Color(0xffFF00E5),
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }),
        ),
        const SizedBox(height: 12),

        /// Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 5,
              width: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: const Color(0xffFF00E5),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              height: 5,
              width: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
            const SizedBox(width: 4),
            Container(
              height: 5,
              width: 5,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildBrandIcon(String brand) {
    if (brand == "amazon") {
      return Container(
        height: 36,
        width: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white.withOpacity(0.04),
        ),
        child: Center(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "amazon",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "•",
                  style: GoogleFonts.inter(
                    color: const Color(0xffFF7A00),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (brand == "protein") {
      return Container(
        height: 36,
        width: 68,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xffFF7A00).withOpacity(0.10),
        ),
        child: Center(
          child: Text(
            "PROTEIN\nDISCOUNT",
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: const Color(0xffFF7A00),
              fontSize: 7,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
        ),
      );
    } else if (brand == "spotify") {
      return Container(
        height: 36,
        width: 68,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xff1ED760).withOpacity(0.15),
        ),
        child: const Center(
          child: Icon(Icons.music_note_rounded, color: Color(0xff1ED760), size: 18),
        ),
      );
    } else {
      // Diet Plan
      return Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: const Color(0xffFF00E5).withOpacity(0.15),
        ),
        child: const Center(
          child: Icon(Icons.favorite_rounded, color: Color(0xffFF00E5), size: 16),
        ),
      );
    }
  }

  /// ----------------------------------------------------
  /// 5. RECENT TRANSACTIONS VERTICAL LIST
  /// ----------------------------------------------------
  Widget buildTransactionsList() {
    return Obx(() {
      return Column(
        children: controller.transactions.map((tx) {
          IconData iconData = Icons.star_rounded;
          Color accentClr = Colors.white;

          if (tx["icon"] == "workout") {
            iconData = Icons.fitness_center_rounded;
            accentClr = const Color(0xffB100FF);
          } else if (tx["icon"] == "referral") {
            iconData = Icons.card_giftcard_rounded;
            accentClr = const Color(0xffFF7A00);
          } else if (tx["icon"] == "amazon") {
            iconData = Icons.shopping_bag_rounded;
            accentClr = const Color(0xffFF00E5);
          } else {
            iconData = Icons.stars_rounded;
            accentClr = const Color(0xffB100FF);
          }

          final isAdd = tx["isAddition"] as bool;

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: const Color(0xff0B0817).withOpacity(0.55),
              border: Border.all(
                color: Colors.white.withOpacity(0.03),
                width: 0.8,
              ),
            ),
            child: Row(
              children: [
                /// Circle icon representation
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentClr.withOpacity(0.12),
                  ),
                  child: Icon(iconData, color: accentClr, size: 16),
                ),
                const SizedBox(width: 14),

                /// Title descriptions
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        tx["title"],
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        tx["desc"],
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.40),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),
                ),

                /// Value changes & Time
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          isAdd ? "+${tx["points"]}" : "${tx["points"]}",
                          style: GoogleFonts.outfit(
                            color: isAdd ? const Color(0xff00FF87) : const Color(0xffFF00E5),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 3),
                        Icon(
                          Icons.stars_rounded,
                          color: isAdd ? const Color(0xffFFD700) : const Color(0xffFF00E5).withOpacity(0.80),
                          size: 11,
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      tx["time"],
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.30),
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      );
    });
  }

}

/// ----------------------------------------------------
/// CUSTOM PAINTER FOR WALLET RINGS
/// ----------------------------------------------------
class WalletRingPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 3.5;
    double radius = (size.width - strokeWidth) / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    // Glowing border ring - LinearGradient (safe)
    Paint ringPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xffB100FF),
          Color(0xffFF00E5),
          Color(0xffFF7A00),
          Color(0xffB100FF),
        ],
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
          ..strokeWidth = 3.5 + (i * 2.0)
          ..color = const Color(0xffB100FF).withOpacity(0.12 / i),
      );
    }
    canvas.drawCircle(center, radius, ringPaint);

    // Draw solid inner background
    canvas.drawCircle(center, radius - 1.5, Paint()..color = const Color(0xff090414));

    // Wallet Icon (drawn manually or using text symbol to avoid assets dependency issues)
    TextPainter textPainter = TextPainter(
      text: const TextSpan(
        text: "👛",
        style: TextStyle(fontSize: 28),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(
        center.dx - (textPainter.width / 2),
        center.dy - (textPainter.height / 2) - 1,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
