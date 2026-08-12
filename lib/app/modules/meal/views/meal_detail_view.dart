import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/meal_controller.dart';

class MealDetailView extends GetView<MealController> {
  const MealDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Read arguments passed from meal_view.dart
    final Map<String, dynamic> args = Get.arguments ?? {};
    final int dietPlanMealId = args['dietPlanMealId'] ?? 0;
    final int mealId = args['mealId'] ?? 0;
    final String title = args['title'] ?? 'Meal Detail';
    final List foods = args['foods'] ?? [];
    final double targetKcal = args['targetKcal'] ?? 0.0;

    // Calculate total macros from food list
    double totalProtein = 0.0;
    double totalCarbs = 0.0;
    double totalFat = 0.0;
    for (var f in foods) {
      if (f == null) continue;
      totalProtein += double.tryParse(f['protein']?.toString() ?? '0') ?? 0;
      totalCarbs += double.tryParse(f['carbs']?.toString() ?? '0') ?? 0;
      totalFat += double.tryParse(f['fat']?.toString() ?? '0') ?? 0;
    }

    // Map a network photo to make the detail screen look incredibly premium
    String imageUrl = 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80';
    if (title.contains('Breakfast')) {
      imageUrl = 'https://images.unsplash.com/photo-1493770348161-369560ae357d?auto=format&fit=crop&w=800&q=80';
    } else if (title.contains('Lunch')) {
      imageUrl = 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80';
    } else if (title.contains('Dinner')) {
      imageUrl = 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80';
    }

    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Obx(() {
        final bool isCompleted = controller.completedMealIds.contains(mealId);

        return Stack(
          children: [
            // 1. Full-bleed Hero Image at the Top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: const Color(0xff120D23),
                      child: const Icon(Icons.restaurant_rounded, color: Colors.white24, size: 48),
                    ),
                  ),
                  // Dark fading overlay at bottom of image
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          const Color(0xff06010F).withOpacity(0.5),
                          const Color(0xff06010F),
                        ],
                        stops: const [0.6, 0.85, 1.0],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 2. Custom App Bar overlay over the image
            Positioned(
              top: MediaQuery.of(context).padding.top + 8,
              left: 18,
              right: 18,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.12),
                          width: 0.8,
                        ),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 14),
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.4),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.12),
                        width: 0.8,
                      ),
                    ),
                    child: const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),

            // 3. Bottom Sheet-style details content container
            Positioned.fill(
              top: MediaQuery.of(context).size.height * 0.38,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Block
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "A customized meal plan balanced specifically for your goals and symptoms. Loaded with essential micronutrients.",
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Total Calories Summary Badge (Mockup Card style)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                      decoration: BoxDecoration(
                        color: const Color(0xff0B0817).withOpacity(0.7),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.04),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Total calories",
                            style: GoogleFonts.outfit(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "~${targetKcal.toInt()} kcal",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Macro Rows (Vertical table layout)
                    Text(
                      "Macronutrient Distribution",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildMacroDetailsRow("Protein", "${totalProtein.toInt()} g", const Color(0xffFFD166)),
                    const SizedBox(height: 8),
                    _buildMacroDetailsRow("Fat", "${totalFat.toInt()} g", const Color(0xffFF00E5)),
                    const SizedBox(height: 8),
                    _buildMacroDetailsRow("Carbs", "${totalCarbs.toInt()} g", const Color(0xff00FF87)),
                    const SizedBox(height: 28),

                    // Food items Section
                    Text(
                      "Included Items & Swaps",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildFoodItemsSection(foods),
                  ],
                ),
              ),
            ),

            // 4. Fixed Bottom Action Buttons
            Positioned(
              left: 18,
              right: 18,
              bottom: 24,
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        bool success;
                        if (isCompleted) {
                          success = await controller.unmarkMealAsCompleted(dietPlanMealId, mealId);
                          if (success) Get.back();
                        } else {
                          success = await controller.markMealAsCompleted(dietPlanMealId, mealId);
                          if (success) {
                            Get.back();
                            Get.snackbar(
                              "Meal Logged 🥗",
                              "Awesome job! +10 FitCoins added to your wallet.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: const Color(0xff0B0817).withOpacity(0.9),
                              colorText: Colors.white,
                              borderColor: const Color(0xff00FF87).withOpacity(0.2),
                              borderWidth: 1,
                            );
                          }
                        }
                      },
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: isCompleted
                              ? null
                              : const LinearGradient(
                                  colors: [
                                    Color(0xff00FF87),
                                    Color(0xffFFD166),
                                  ],
                                ),
                          color: isCompleted ? Colors.white.withOpacity(0.06) : null,
                          border: isCompleted
                              ? Border.all(color: Colors.white.withOpacity(0.12), width: 1.0)
                              : null,
                          boxShadow: isCompleted
                              ? null
                              : [
                                  BoxShadow(
                                    color: const Color(0xff00FF87).withOpacity(0.25),
                                    blurRadius: 12,
                                    spreadRadius: 1,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isCompleted ? Icons.check_circle_rounded : Icons.check_circle_outline_rounded,
                              color: isCompleted ? const Color(0xff00FF87) : Colors.black,
                              size: 20,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              isCompleted ? "Marked as Eaten" : "Log this Meal",
                              style: GoogleFonts.outfit(
                                color: isCompleted ? Colors.white : Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildMacroDetailsRow(String label, String value, Color accentColor) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xff0B0817).withOpacity(0.4),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.03),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                height: 8,
                width: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItemsSection(List foods) {
    if (foods.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color(0xff0B0817).withOpacity(0.4),
        ),
        alignment: Alignment.center,
        child: Text(
          "No details available.",
          style: GoogleFonts.inter(color: Colors.white30, fontSize: 12),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: foods.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final f = foods[index];
        final String foodName = f['food_details']?['food_name'] ?? 'Food Item';
        final double kcal = double.tryParse(f['calories']?.toString() ?? '0') ?? 0.0;
        final double protein = double.tryParse(f['protein']?.toString() ?? '0') ?? 0.0;
        final double carbs = double.tryParse(f['carbs']?.toString() ?? '0') ?? 0.0;
        final double fat = double.tryParse(f['fat']?.toString() ?? '0') ?? 0.0;
        final String portion = "${f['serving_size']} ${f['unit']}";

        // Parse swap options from notes metadata if present, or suggest intelligent fallback swaps based on food type
        String swapText = "";
        final String? notes = f['notes']?.toString();
        if (notes != null && notes.isNotEmpty) {
          try {
            final Map<String, dynamic> meta = jsonDecode(notes);
            if (meta['swap_recommendation'] != null) {
              swapText = meta['swap_recommendation'];
            }
          } catch (_) {}
        }

        // Robust fallbacks matching your PDF meal plan
        if (swapText.isEmpty) {
          if (foodName.toLowerCase().contains("ghee")) {
            swapText = "Swap with: Olive Oil (1 tsp) OR Mustard Oil (1 tsp)";
          } else if (foodName.toLowerCase().contains("oats")) {
            swapText = "Swap with: Jowar (Sorghum) OR Bajra (Pearl Millet)";
          } else if (foodName.toLowerCase().contains("spinach") || foodName.toLowerCase().contains("palak")) {
            swapText = "Swap with: Cabbage OR Cauliflower (steamed)";
          } else if (foodName.toLowerCase().contains("dal") || foodName.toLowerCase().contains("lentil")) {
            swapText = "Swap with: Toor Dal OR Masoor Dal (½ cup cooked)";
          } else if (foodName.toLowerCase().contains("curd") || foodName.toLowerCase().contains("yogurt")) {
            swapText = "Swap with: Low-fat Butter Milk (1 glass)";
          }
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xff0B0817).withOpacity(0.4),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withOpacity(0.03),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          foodName,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          portion,
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.4),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "${kcal.toInt()} kcal",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "${protein.toInt()}P • ${carbs.toInt()}C • ${fat.toInt()}F",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.35),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (swapText.isNotEmpty) ...[
                const SizedBox(height: 12),
                Divider(color: Colors.white.withOpacity(0.04), height: 1.0),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.swap_horiz_rounded, color: Color(0xffFFD166), size: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        swapText,
                        style: GoogleFonts.inter(
                          color: const Color(0xffFFD166).withOpacity(0.85),
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                          height: 1.3,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
