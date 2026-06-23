import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/family_controller.dart';
import '../../../widgets/premium_layout_components.dart';

class FamilyView extends GetView<FamilyController> {
  const FamilyView({super.key});

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
                    const Color(0xffFF00E5).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 100,
            left: -150,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xff00A3FF).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// SCROLLABLE VIEW CONTENT
          SafeArea(
            child: Column(
              children: [
                /// HEADER
                buildHeader(context),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// 1. DISCOUNT / SAVINGS HUB CARD
                        buildDiscountHubCard(),
                        const SizedBox(height: 24),

                        /// SECTION TITLE
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Family Members",
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Obx(() => Text(
                                  "${controller.familyMembers.length} Profiles Registered",
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.40),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                          ],
                        ),
                        const SizedBox(height: 14),

                        /// 2. FAMILY CARDS LIST
                        Obx(() {
                          final members = controller.familyMembers;
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: members.length,
                            itemBuilder: (context, index) {
                              final member = members[index];
                              return buildFamilyMemberCard(context, member);
                            },
                          );
                        }),
                        const SizedBox(height: 20),
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
  Widget buildHeader(BuildContext context) {
    return PremiumAppBar(
      title: "Family Hub",
      subtitle: "Manage family plans & goals",
      trailing: GestureDetector(
        onTap: () => showAddMemberSheet(context),
        child: Container(
          height: 40,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xffFF00E5).withOpacity(0.25), width: 1),
            color: const Color(0xffFF00E5).withOpacity(0.04),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add_rounded, color: Color(0xffFF00E5), size: 16),
              const SizedBox(width: 4),
              Text(
                "Add",
                style: GoogleFonts.outfit(
                  color: const Color(0xffFF00E5),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ----------------------------------------------------
  /// 1. DISCOUNT / SAVINGS HUB CARD
  /// ----------------------------------------------------
  Widget buildDiscountHubCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: const Color(0xff00A3FF).withOpacity(0.20),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.stars_rounded, color: Color(0xff00A3FF), size: 16),
                        const SizedBox(width: 8),
                        Text(
                          "FAMILY DISCOUNT CENTER",
                          style: GoogleFonts.outfit(
                            color: const Color(0xff00A3FF),
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      double saved = controller.totalSavedAmount.toDouble();
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xff00FF87).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xff00FF87).withOpacity(0.35), width: 0.8),
                        ),
                        child: Text(
                          "₹${saved.toInt()} Saved",
                          style: GoogleFonts.outfit(
                            color: const Color(0xff00FF87),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 14),

                /// Total Cost Calculation Details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Family Plan Tier",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.40),
                            fontSize: 9,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(() {
                          double disc = controller.additionalPlanDiscountFraction * 100;
                          return Text(
                            "${disc.toInt()}% Off Additional Plans",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          );
                        }),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "Total Monthly Cost",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.40),
                            fontSize: 9,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Obx(() {
                          int total = controller.totalFamilyCost;
                          return Text(
                            "₹$total",
                            style: GoogleFonts.outfit(
                              color: const Color(0xff00A3FF),
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          );
                        }),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                /// Interactive Tier visual scale bar
                buildDiscountTierBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Visual builder for the tier slider
  Widget buildDiscountTierBar() {
    return Obx(() {
      int count = controller.familyMembers.length;
      double progress = 0.0;
      if (count == 1) progress = 0.33;
      if (count == 2) progress = 0.66;
      if (count >= 3) progress = 1.0;

      return Column(
        children: [
          /// Slim progressive slider bar
          SizedBox(
            height: 8,
            width: double.infinity,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white.withOpacity(0.06),
                  ),
                ),
                FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: progress,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xff00A3FF),
                          Color(0xffFF00E5),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          /// Indicators row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildTierIndicator("1 Member", "0% Off", count == 1),
              buildTierIndicator("2 Members", "20% Off", count == 2),
              buildTierIndicator("3+ Members", "40% Off", count >= 3),
            ],
          ),
        ],
      );
    });
  }

  Widget buildTierIndicator(String members, String disc, bool isActive) {
    Color labelColor = isActive ? const Color(0xffFF00E5) : Colors.white.withOpacity(0.35);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          members,
          style: GoogleFonts.inter(
            color: labelColor,
            fontSize: 8,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          disc,
          style: GoogleFonts.outfit(
            color: labelColor,
            fontSize: 9,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  /// ----------------------------------------------------
  /// 2. DETAILED FAMILY MEMBER CARD
  /// ----------------------------------------------------
  Widget buildFamilyMemberCard(BuildContext context, Map<String, dynamic> member) {
    bool hasActivePlan = member["hasActivePlan"] as bool;
    Color glowColor = hasActivePlan ? const Color(0xff00FF87) : const Color(0xffB100FF);

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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PROFILE HEADER (Avatar + Info + Delete button)
              Row(
                children: [
                  /// Avatar surrounded by pulsing glow border ring
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: glowColor.withOpacity(0.35), width: 1.5),
                          boxShadow: [
                            BoxShadow(
                              color: glowColor.withOpacity(0.08),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(22),
                        child: SizedBox(
                          height: 44,
                          width: 44,
                          child: Image.network(
                            member["image"],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),

                  /// Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              member["name"],
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),

                            /// Relationship Badge
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: glowColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: glowColor.withOpacity(0.20), width: 0.8),
                              ),
                              child: Text(
                                member["relationship"],
                                style: GoogleFonts.inter(
                                  color: glowColor,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "${member['gender']}  •  Age ${member['age']}",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.40),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Delete Card Trigger
                  IconButton(
                    onPressed: () => controller.removeMember(member["id"]),
                    icon: Icon(Icons.delete_outline_rounded, color: Colors.red.withOpacity(0.60), size: 18),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              /// ACTIVE PLAN SECTION vs ASSESSMENT PENDING
              if (hasActivePlan) ...[
                /// Active Plan Label & Days Left
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      member["activePlanName"],
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${member['daysLeft']} Days Left",
                      style: GoogleFonts.inter(
                        color: const Color(0xff00FF87),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                /// Mini progressive slider bar
                SizedBox(
                  height: 5,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white.withOpacity(0.06),
                        ),
                      ),
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: member["planProgressPercent"],
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xff00FF87),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                /// STATS ROW: Calorie targets, Water Goals, Compliance, Sparkline weight chart
                Row(
                  children: [
                    /// Stats Columns
                    Expanded(
                      flex: 4,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildMiniStatColumn("Intake", member["caloriesGoal"], Icons.local_fire_department_rounded),
                          buildMiniStatColumn("Hydration", member["waterGoal"], Icons.water_drop_rounded),
                          buildMiniStatColumn("Compliance", "${member['compliancePercent']}%", Icons.check_circle_rounded),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),

                    /// Weight Sparkline chart
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 46,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.01),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.white.withOpacity(0.03), width: 0.8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: CustomPaint(
                                painter: SparklineChartPainter(
                                  points: member["weightHistory"] as List<double>,
                                  color: const Color(0xff00FF87),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${(member['weightHistory'] as List<double>).last} kg",
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Weight",
                                  style: GoogleFonts.inter(
                                    color: Colors.white.withOpacity(0.35),
                                    fontSize: 7.5,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                /// Button controls (Fork, Clock, Chart)
                Row(
                  children: [
                    Expanded(
                      child: buildSmallCardAction(
                        Icons.restaurant_rounded,
                        "View Meals",
                        () => Get.toNamed('/meal-plan'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: buildSmallCardAction(
                        Icons.access_time_rounded,
                        "Reminders",
                        () => Get.toNamed('/reminders'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: buildSmallCardAction(
                        Icons.bar_chart_rounded,
                        "Progress",
                        () => Get.toNamed('/progress'),
                      ),
                    ),
                  ],
                ),
              ] else ...[
                /// PLAN INACTIVE - ASSESSMENT PENDING / INCOMPLETE
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline_rounded, color: Colors.white.withOpacity(0.30), size: 14),
                        const SizedBox(width: 8),
                        Text(
                          "No Active Plan for this Profile",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.50),
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    /// Activation CTA Trigger
                    Container(
                      height: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xffB100FF),
                            Color(0xffFF00E5),
                          ],
                        ),
                      ),
                      child: TextButton(
                        onPressed: () => controller.activatePlanForMember(member["id"]),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        child: Text(
                          "Unlock Plan",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMiniStatColumn(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.30), size: 10),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.35),
                fontSize: 7.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 3),
        Text(
          value,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget buildSmallCardAction(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white.withOpacity(0.02),
          border: Border.all(color: Colors.white.withOpacity(0.04), width: 0.8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xff00A3FF), size: 12),
            const SizedBox(width: 6),
            Text(
              title,
              style: GoogleFonts.outfit(
                color: Colors.white.withOpacity(0.85),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ----------------------------------------------------
  /// ADD MEMBER SHEET MODAL (Form entry)
  /// ----------------------------------------------------
  void showAddMemberSheet(BuildContext context) {
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

                  Text(
                    "Add Family Profile",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Create a profile to unlock personalized plan discounts.",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.40),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// 1. Name Field
                  Text(
                    "FULL NAME",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.40),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.05), width: 0.8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: TextField(
                      onChanged: (val) => controller.nameInput.value = val,
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter full name",
                        hintStyle: GoogleFonts.inter(color: Colors.white30, fontSize: 13),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  /// Row: Age & Gender
                  Row(
                    children: [
                      /// Age
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "AGE",
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.40),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              height: 48,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.02),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: Colors.white.withOpacity(0.05), width: 0.8),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: TextField(
                                keyboardType: TextInputType.number,
                                onChanged: (val) => controller.ageInput.value = int.tryParse(val) ?? 0,
                                style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "e.g. 28",
                                  hintStyle: GoogleFonts.inter(color: Colors.white30, fontSize: 13),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),

                      /// Gender
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "GENDER",
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.40),
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Obx(() {
                              final gender = controller.genderInput.value;
                              return Row(
                                children: [
                                  Expanded(
                                    child: buildGenderSelector("Female", gender == "Female"),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: buildGenderSelector("Male", gender == "Male"),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  /// 3. Relationship Dropdown
                  Text(
                    "RELATIONSHIP",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.40),
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.05), width: 0.8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        canvasColor: const Color(0xff090414),
                      ),
                      child: Obx(() => DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: controller.relationshipInput.value,
                              onChanged: (val) {
                                if (val != null) controller.relationshipInput.value = val;
                              },
                              style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white30),
                              items: controller.relationshipsList.map((String rel) {
                                return DropdownMenuItem<String>(
                                  value: rel,
                                  child: Text(rel),
                                );
                              }).toList(),
                            ),
                          )),
                    ),
                  ),
                  const SizedBox(height: 28),

                  /// Submit CTA
                  Container(
                    height: 46,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(23),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xffFF00E5),
                          Color(0xffFF7A00),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffFF00E5).withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextButton(
                      onPressed: () {
                        controller.addFamilyMember();
                        if (controller.nameInput.value.trim().isNotEmpty && controller.ageInput.value > 0) {
                          Get.back();
                        }
                      },
                      child: Text(
                        "Add Member & Get Discount",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  Widget buildGenderSelector(String title, bool isSelected) {
    Color selectedColor = const Color(0xff00A3FF);
    return GestureDetector(
      onTap: () => controller.genderInput.value = title,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isSelected ? selectedColor.withOpacity(0.08) : Colors.white.withOpacity(0.02),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.white.withOpacity(0.05),
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            title,
            style: GoogleFonts.outfit(
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.40),
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

}

/// ----------------------------------------------------
/// CUSTOM SPARKLINE WEIGHT CHART PAINTER
/// ----------------------------------------------------
class SparklineChartPainter extends CustomPainter {
  final List<double> points;
  final Color color;

  SparklineChartPainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final pathPaint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    double maxVal = points.reduce((curr, next) => curr > next ? curr : next);
    double minVal = points.reduce((curr, next) => curr < next ? curr : next);
    double range = maxVal - minVal;
    if (range == 0) range = 1.0;

    double spacing = size.width / (points.length == 1 ? 1 : points.length - 1);

    final path = Path();
    List<Offset> coordinates = [];

    for (int i = 0; i < points.length; i++) {
      double x = spacing * i;
      // invert scale: high weight = higher point visually (so subtract from height)
      double pct = (points[i] - minVal) / range;
      double y = size.height * 0.85 - (size.height * 0.7 * pct);
      coordinates.add(Offset(x, y));

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw the sparkline path
    canvas.drawPath(path, pathPaint);

    // Draw solid dot for the final/current weight point
    if (coordinates.isNotEmpty) {
      canvas.drawCircle(coordinates.last, 3.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
