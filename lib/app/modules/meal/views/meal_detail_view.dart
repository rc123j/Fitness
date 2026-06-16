import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/meal_controller.dart';

class MealDetailView extends GetView<MealController> {
  const MealDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          /// BACKGROUND GLOW BLOBS
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              height: 300,
              width: 300,
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
            right: -50,
            child: Container(
              height: 300,
              width: 300,
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

          /// MAIN SCREEN CONTENT
          SafeArea(
            child: Column(
              children: [
                /// HEADER
                buildHeader(),

                /// SCROLLABLE DETAILS
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Column(
                      children: [
                        /// 1. MEAL SUMMARY TOP CARD
                        buildMealSummaryCard(),
                        const SizedBox(height: 14),

                        /// 2. MACROS DONUT CARD
                        buildMacrosDonutCard(),
                        const SizedBox(height: 14),

                        /// 3. MACRONUTRIENT BALANCE PROGRESS BAR
                        buildMacronutrientBalanceCard(),
                        const SizedBox(height: 14),

                        /// 4. FOOD ITEMS LIST
                        buildFoodItemsSection(),
                        const SizedBox(height: 14),

                        /// 5. NOTES CARD WITH NEON ICON
                        buildNotesCard(),
                        const SizedBox(height: 14),

                        /// 6. CALORIES SUMMARY ROW
                        buildCalorieSummaryRow(),
                        const SizedBox(height: 20),

                        /// 7. BOTTOM ACTIONS BAR
                        buildBottomActionsBar(),
                        const SizedBox(height: 12),
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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

          /// Center Title
          Text(
            "Meal Details",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          /// More Menu
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
            child: const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 18),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 1. MEAL SUMMARY TOP CARD
  /// ----------------------------------------------------
  Widget buildMealSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(18),
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
          /// Glowing Food Icon Circle
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xffFF7A00).withOpacity(0.20),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
              Container(
                height: 56,
                width: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xffFF7A00).withOpacity(0.3),
                    width: 1.2,
                  ),
                ),
              ),
              Container(
                height: 44,
                width: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xff090414),
                ),
                child: const Icon(
                  Icons.soup_kitchen_rounded,
                  color: Color(0xffFF7A00),
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(width: 14),

          /// Meal Title, Subtitle, and Time
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lunch",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Grilled Chicken Bowl",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.60),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time_rounded,
                      color: Color(0xffFF7A00),
                      size: 13,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "12:30 PM",
                      style: GoogleFonts.inter(
                        color: const Color(0xffFF7A00),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// Right Actions (Planned Pill & Edit Meal)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /// Planned Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: const Color(0xffFF7A00).withOpacity(0.35),
                    width: 0.8,
                  ),
                  color: const Color(0xffFF7A00).withOpacity(0.04),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 5,
                      width: 5,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffFF7A00),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      "Planned",
                      style: GoogleFonts.inter(
                        color: const Color(0xffFF7A00),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// Edit Meal Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xffB100FF).withOpacity(0.35),
                    width: 0.8,
                  ),
                  color: Colors.white.withOpacity(0.02),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.edit_outlined,
                      color: Color(0xffB100FF),
                      size: 11,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      "Edit Meal",
                      style: GoogleFonts.outfit(
                        color: const Color(0xffB100FF),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 2. MACROS DONUT CARD
  /// ----------------------------------------------------
  Widget buildMacrosDonutCard() {
    return Container(
      padding: const EdgeInsets.all(18),
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
          /// Macronutrients Grid
          Expanded(
            child: Row(
              children: [
                /// Col 1: Calories & Carbs
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildMacroItem(
                        icon: Icons.local_fire_department_rounded,
                        iconColor: const Color(0xffFF7A00),
                        value: "550",
                        unit: "kcal",
                        label: "Calories",
                        labelColor: const Color(0xffFF7A00),
                      ),
                      const SizedBox(height: 16),
                      buildMacroItem(
                        icon: Icons.grass_rounded,
                        iconColor: const Color(0xffFF00E5),
                        value: "60g",
                        unit: "Carbs",
                        label: "44%",
                        labelColor: const Color(0xffFF00E5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),

                /// Col 2: Protein & Fat
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildMacroItem(
                        icon: Icons.fitness_center_rounded,
                        iconColor: const Color(0xffB100FF),
                        value: "40g",
                        unit: "Protein",
                        label: "29%",
                        labelColor: const Color(0xffB100FF),
                      ),
                      const SizedBox(height: 16),
                      buildMacroItem(
                        icon: Icons.water_drop_rounded,
                        iconColor: const Color(0xffFF7A00),
                        value: "15g",
                        unit: "Fat",
                        label: "27%",
                        labelColor: const Color(0xffFF7A00),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          /// Right: Multi-segment Donut Chart (29% Protein, 44% Carbs, 27% Fat)
          CustomPaint(
            size: const Size(86, 86),
            painter: MultiSegmentDonutPainter(
              proteinPercent: 0.29,
              carbsPercent: 0.44,
              fatPercent: 0.27,
              centerValue: "550",
              centerUnit: "kcal\nTotal",
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMacroItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String unit,
    required String label,
    required Color labelColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 18),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      height: 1.1,
                    ),
                  ),
                  TextSpan(
                    text: " $unit",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.40),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.inter(
                color: labelColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ----------------------------------------------------
  /// 3. MACRONUTRIENT BALANCE PROGRESS BAR
  /// ----------------------------------------------------
  Widget buildMacronutrientBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Macronutrient Balance",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// Legend
              Row(
                children: [
                  buildLegendItem(const Color(0xffB100FF), "Protein"),
                  const SizedBox(width: 8),
                  buildLegendItem(const Color(0xffFF00E5), "Carbs"),
                  const SizedBox(width: 8),
                  buildLegendItem(const Color(0xffFF7A00), "Fat"),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),

          /// Multi-colored segmented horizontal bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 8,
              child: Row(
                children: [
                  Expanded(
                    flex: 29, // 29% Protein
                    child: Container(color: const Color(0xffB100FF)),
                  ),
                  Expanded(
                    flex: 44, // 44% Carbs
                    child: Container(color: const Color(0xffFF00E5)),
                  ),
                  Expanded(
                    flex: 27, // 27% Fat
                    child: Container(color: const Color(0xffFF7A00)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLegendItem(Color dotColor, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 6,
          width: 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: dotColor,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.50),
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// ----------------------------------------------------
  /// 4. FOOD ITEMS LIST SECTION
  /// ----------------------------------------------------
  Widget buildFoodItemsSection() {
    final List<Map<String, dynamic>> items = [
      {
        "name": "Grilled Chicken Breast",
        "detail": "150g • Medium",
        "kcal": "220",
        "img": "https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?w=150",
      },
      {
        "name": "Brown Rice",
        "detail": "1 cup • Cooked",
        "kcal": "180",
        "img": "https://images.unsplash.com/photo-1586201375761-83865001e31c?w=150",
      },
      {
        "name": "Mixed Vegetables",
        "detail": "1 cup • Steamed",
        "kcal": "80",
        "img": "https://images.unsplash.com/photo-1540420773420-3366772f4999?w=150",
      },
      {
        "name": "Avocado",
        "detail": "1/4 piece",
        "kcal": "70",
        "img": "https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=150",
      },
    ];

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Food Items",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

              /// + Add Food Button
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: const Color(0xffB100FF).withOpacity(0.35),
                    width: 0.8,
                  ),
                  color: Colors.white.withOpacity(0.02),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      color: Color(0xffB100FF),
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      "Add Food",
                      style: GoogleFonts.outfit(
                        color: const Color(0xffB100FF),
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          /// Food Item list
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Divider(color: Colors.white.withOpacity(0.04), height: 0.8),
            ),
            itemBuilder: (context, index) {
              final item = items[index];
              return Row(
                children: [
                  /// Circular Image
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                        width: 0.8,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          item["img"],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.white.withOpacity(0.05),
                            child: const Icon(Icons.restaurant_menu, color: Colors.white24),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item["name"],
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          item["detail"],
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Calorie count
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item["kcal"],
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "kcal",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.40),
                          fontSize: 9,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white.withOpacity(0.20),
                    size: 12,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 5. NOTES CARD WITH NEON CUSTOM PAINT ICON
  /// ----------------------------------------------------
  Widget buildNotesCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Notes",
                  style: GoogleFonts.outfit(
                    color: const Color(0xffB100FF),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "High protein, balanced meal to keep you full and energized throughout the day.",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.70),
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          /// Neon notepad icon
          CustomPaint(
            size: const Size(48, 56),
            painter: NeonNotepadPainter(),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 6. CALORIES SUMMARY ROW
  /// ----------------------------------------------------
  Widget buildCalorieSummaryRow() {
    return Row(
      children: [
        /// Card 1: Calorie Goal
        Expanded(
          child: buildSummaryMiniCard(
            title: "Calorie Goal",
            value: "2,300",
            unit: "kcal",
            icon: Icons.track_changes_rounded,
            iconColor: const Color(0xffB100FF),
            valueColor: Colors.white,
          ),
        ),
        const SizedBox(width: 8),

        /// Card 2: Calories Left
        Expanded(
          child: buildSummaryMiniCard(
            title: "Calories Left",
            value: "1,150",
            unit: "kcal",
            icon: Icons.speed_rounded,
            iconColor: const Color(0xff00FF87),
            valueColor: const Color(0xff00FF87),
          ),
        ),
        const SizedBox(width: 8),

        /// Card 3: This Meal
        Expanded(
          child: buildSummaryMiniCard(
            title: "This Meal",
            value: "550",
            unit: "kcal",
            icon: Icons.dinner_dining_rounded,
            iconColor: const Color(0xffFF7A00),
            valueColor: const Color(0xffFF7A00),
          ),
        ),
      ],
    );
  }

  Widget buildSummaryMiniCard({
    required String title,
    required String value,
    required String unit,
    required IconData icon,
    required Color iconColor,
    required Color valueColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: Colors.white.withOpacity(0.03),
          width: 0.8,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Icon Header
          Container(
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: iconColor.withOpacity(0.10),
            ),
            child: Icon(icon, color: iconColor, size: 14),
          ),
          const SizedBox(height: 12),

          /// Title
          Text(
            title,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.40),
              fontSize: 8,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),

          /// Value
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: value,
                  style: GoogleFonts.outfit(
                    color: valueColor,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: " $unit",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.40),
                    fontSize: 8,
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
  /// 7. BOTTOM ACTIONS BAR (BUTTONS ROW)
  /// ----------------------------------------------------
  Widget buildBottomActionsBar() {
    return Row(
      children: [
        /// Replace Meal (Outline)
        Expanded(
          flex: 4,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xffB100FF).withOpacity(0.40),
                width: 1.0,
              ),
              color: Colors.white.withOpacity(0.01),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () {
                // Mock Action
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.swap_horiz_rounded,
                    color: Color(0xffB100FF),
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Replace Meal",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 14),

        /// Mark as Done (Gradient filled)
        Expanded(
          flex: 6,
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: const LinearGradient(
                colors: [
                  Color(0xffFF00E5),
                  Color(0xffFF7A00),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffFF00E5).withOpacity(0.30),
                  blurRadius: 10,
                  spreadRadius: 1,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => Get.back(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Mark as Done",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ----------------------------------------------------
/// CUSTOM PAINTERS FOR GRAPHICS
/// ----------------------------------------------------

/// 1. Multi-segment Macro Donut Painter
class MultiSegmentDonutPainter extends CustomPainter {
  final double proteinPercent;
  final double carbsPercent;
  final double fatPercent;
  final String centerValue;
  final String centerUnit;

  MultiSegmentDonutPainter({
    required this.proteinPercent,
    required this.carbsPercent,
    required this.fatPercent,
    required this.centerValue,
    required this.centerUnit,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 8.0;
    double radius = (size.width - strokeWidth) / 2;
    Offset center = Offset(size.width / 2, size.height / 2);
    Rect rect = Rect.fromCircle(center: center, radius: radius);

    Paint basePaint = Paint()
      ..color = Colors.white.withOpacity(0.04)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, basePaint);

    double startAngle = -pi / 2;

    /// 1. Protein Segment (Purple)
    if (proteinPercent > 0) {
      double sweep = 2 * pi * proteinPercent;
      Paint pPaint = Paint()
        ..color = const Color(0xffB100FF)
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawArc(rect, startAngle, sweep, false, pPaint);
      startAngle += sweep;
    }

    /// 2. Carbs Segment (Pink)
    if (carbsPercent > 0) {
      double sweep = 2 * pi * carbsPercent;
      Paint cPaint = Paint()
        ..color = const Color(0xffFF00E5)
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawArc(rect, startAngle, sweep, false, cPaint);
      startAngle += sweep;
    }

    /// 3. Fat Segment (Yellow/Orange)
    if (fatPercent > 0) {
      double sweep = 2 * pi * fatPercent;
      Paint fPaint = Paint()
        ..color = const Color(0xffFF7A00)
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawArc(rect, startAngle, sweep, false, fPaint);
    }

    /// Center Text (550 kcal Total)
    TextPainter textPainter = TextPainter(
      text: TextSpan(
        children: [
          TextSpan(
            text: "$centerValue\n",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
          TextSpan(
            text: centerUnit,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.40),
              fontSize: 8,
              height: 1.1,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0, maxWidth: size.width);
    textPainter.paint(
      canvas,
      Offset(
        center.dx - (textPainter.width / 2),
        center.dy - (textPainter.height / 2),
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 2. Neon Notes Notepad & Pencil Painter
class NeonNotepadPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;

    Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xffB100FF);

    /// Draw Notepad Outline
    Path notepad = Path();
    notepad.moveTo(w * 0.15, h * 0.15);
    notepad.lineTo(w * 0.75, h * 0.15);
    notepad.lineTo(w * 0.75, h * 0.55);
    notepad.moveTo(w * 0.75, h * 0.75);
    notepad.lineTo(w * 0.75, h * 0.85);
    notepad.lineTo(w * 0.15, h * 0.85);
    notepad.lineTo(w * 0.15, h * 0.15);

    /// Top clips/rings
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(w * 0.25, h * 0.08, w * 0.35, h * 0.18),
        const Radius.circular(2),
      ),
      strokePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTRB(w * 0.55, h * 0.08, w * 0.65, h * 0.18),
        const Radius.circular(2),
      ),
      strokePaint,
    );

    /// Lines inside notepad
    canvas.drawLine(Offset(w * 0.25, h * 0.32), Offset(w * 0.65, h * 0.32), strokePaint);
    canvas.drawLine(Offset(w * 0.25, h * 0.48), Offset(w * 0.50, h * 0.48), strokePaint);
    canvas.drawLine(Offset(w * 0.25, h * 0.64), Offset(w * 0.45, h * 0.64), strokePaint);

    /// Draw Pencil
    Path pencil = Path();
    pencil.moveTo(w * 0.82, h * 0.35);
    pencil.lineTo(w * 0.94, h * 0.42);
    pencil.lineTo(w * 0.60, h * 0.80);
    pencil.lineTo(w * 0.46, h * 0.80);
    pencil.lineTo(w * 0.46, h * 0.66);
    pencil.close();

    Paint pencilPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..color = const Color(0xffFF00E5);

    canvas.drawPath(notepad, strokePaint);
    canvas.drawPath(pencil, pencilPaint);

    /// Notepad & Pencil Glow Shadow - concentric lines (safe)
    for (double i = 1; i <= 3; i++) {
      canvas.drawPath(
        notepad,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8 + (i * 1.5)
          ..strokeCap = StrokeCap.round
          ..color = const Color(0xffB100FF).withOpacity(0.12 / i),
      );
      canvas.drawPath(
        pencil,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8 + (i * 1.5)
          ..color = const Color(0xffFF00E5).withOpacity(0.12 / i),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
