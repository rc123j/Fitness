import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../services/onboarding_draft_service.dart';
import 'health_profile_screen.dart';

class DietaryPreferencesScreen extends StatefulWidget {
  final String goalTitle;
  final int goalId;
  final String gender;
  final int age;
  final int height;
  final double weight;
  final int activityLevelId;
  final String activityLevelName;

  const DietaryPreferencesScreen({
    super.key,
    required this.goalTitle,
    required this.goalId,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.activityLevelId,
    required this.activityLevelName,
  });

  @override
  State<DietaryPreferencesScreen> createState() =>
      _DietaryPreferencesScreenState();
}

class _DietaryPreferencesScreenState extends State<DietaryPreferencesScreen> {
  // Primary diet type — single select (maps to taste_preferences IDs)
  // 1=Vegetarian, 2=Vegan, 3=Keto, 4=Eggitarian, 5=No Seafood, 6=Non-Vegetarian (local-only, no DB entry needed)
  int? selectedDietTypeId; // null means not selected yet
  String? selectedDietLabel;

  // Secondary: food exclusions (multi-select)
  final Set<String> selectedExclusions = {};

  // Diet type options
  final List<Map<String, dynamic>> dietTypes = [
    {
      'id': null, // Non-Veg has no taste_preference row
      'label': 'Non-Vegetarian',
      'image': 'assets/new_images/non-veg.png',
      'desc': 'Includes meat, fish,\neggs & dairy',
      'color': const Color(0xffFF5F6D),
    },
    {
      'id': 4, // Eggitarian
      'label': 'Eggitarian',
      'image': 'assets/new_images/eggeterian.png',
      'desc': 'Vegetarian diet\nthat includes eggs',
      'color': const Color(0xffFF7A00),
    },
    {
      'id': 1, // Vegetarian
      'label': 'Vegetarian',
      'image': 'assets/new_images/vegeterian.png',
      'desc': 'No meat or fish.\nIncludes dairy & eggs',
      'color': const Color(0xff34C759),
    },
    {
      'id': 2, // Vegan
      'label': 'Vegan',
      'image': 'assets/new_images/vegan.png',
      'desc': 'No animal products\nwhatsoever',
      'color': const Color(0xff00E5FF),
    },
    {
      'id': 3, // Keto
      'label': 'Keto / Low-Carb',
      'image': 'assets/new_images/keto.png',
      'desc': 'High fat, very low\ncarbohydrate intake',
      'color': const Color(0xffC026D3),
    },
  ];

  // Conditional food exclusions based on diet selection (localized for India - no beef/pork)
  List<Map<String, dynamic>> get exclusionOptions {
    if (selectedDietLabel == null) return [];

    final List<Map<String, dynamic>> options = [];

    if (selectedDietLabel == 'Non-Vegetarian' ||
        selectedDietLabel == 'Eggitarian') {
      options.addAll([
        {
          'key': 'no_seafood',
          'label': 'No Seafood / Fish',
          'icon': Icons.water_rounded,
        },
        {
          'key': 'no_mutton',
          'label': 'No Mutton',
          'icon': Icons.no_meals_outlined,
        },
        {
          'key': 'no_poultry',
          'label': 'No Chicken / Poultry',
          'icon': Icons.block_rounded,
        },
      ]);
    } else if (selectedDietLabel == 'Vegetarian' || selectedDietLabel == 'Vegan') {
      options.addAll([
        {
          'key': 'no_egg',
          'label': 'No Egg (Strict Veg)',
          'icon': Icons.egg_rounded,
        },
        {
          'key': 'no_gluten',
          'label': 'Gluten Intolerant',
          'icon': Icons.grain_rounded,
        },
        {
          'key': 'no_nuts',
          'label': 'Nut Allergy',
          'icon': Icons.dangerous_rounded,
        },
        {
          'key': 'no_lactose',
          'label': 'Lactose Intolerant',
          'icon': Icons.no_drinks_rounded,
        },
        {
          'key': 'no_soy',
          'label': 'No Soy / Tofu',
          'icon': Icons.block_rounded,
        },
      ]);
    } else if (selectedDietLabel == 'Keto / Low-Carb') {
      options.addAll([
        {
          'key': 'no_seafood',
          'label': 'No Seafood / Fish',
          'icon': Icons.water_rounded,
        },
        {
          'key': 'no_dairy',
          'label': 'No Dairy',
          'icon': Icons.no_drinks_rounded,
        },
        {
          'key': 'no_nuts',
          'label': 'Nut Allergy',
          'icon': Icons.dangerous_rounded,
        },
      ]);
    }

    if (options.isNotEmpty) {
      options.add({
        'key': 'none',
        'label': 'None / No Exclusions',
        'icon': Icons.check_circle_outline_rounded,
      });
    }

    return options;
  }

  bool get canProceed => selectedDietLabel != null && selectedExclusions.isNotEmpty;

  void _selectDietType(Map<String, dynamic> diet) {
    setState(() {
      selectedDietTypeId = diet['id'];
      selectedDietLabel = diet['label'];
      selectedExclusions.clear(); // reset exclusions when diet changes
    });
  }

  void _toggleExclusion(String key) {
    setState(() {
      if (key == 'none') {
        if (selectedExclusions.contains('none')) {
          selectedExclusions.remove('none');
        } else {
          selectedExclusions.clear();
          selectedExclusions.add('none');
        }
      } else {
        selectedExclusions.remove('none');
        if (selectedExclusions.contains(key)) {
          selectedExclusions.remove(key);
        } else {
          selectedExclusions.add(key);
        }
      }
    });
  }

  void _proceed() {
    final List<int> tastePreferenceIds = [];
    if (selectedDietTypeId != null) {
      tastePreferenceIds.add(selectedDietTypeId!);
    }
    if (selectedExclusions.contains('no_seafood')) {
      tastePreferenceIds.add(5); // id 5 = No Seafood in DB
    }

    // Filter out the local 'none' exclusion before saving or passing
    final finalExclusions = selectedExclusions.where((e) => e != 'none').toList();

    OnboardingDraftService.saveStep7(
      tastePreferenceIds: tastePreferenceIds,
      dietLabel: selectedDietLabel ?? 'Standard',
      foodExclusions: finalExclusions,
    );

    Get.to(
      () => HealthProfileScreen(
        goalTitle: widget.goalTitle,
        goalId: widget.goalId,
        gender: widget.gender,
        age: widget.age,
        height: widget.height,
        weight: widget.weight,
        activityLevelId: widget.activityLevelId,
        activityLevelName: widget.activityLevelName,
        tastePreferenceIds: tastePreferenceIds,
        dietLabel: selectedDietLabel!,
        foodExclusions: finalExclusions,
      ),
      transition: Transition.cupertino,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050510),
      body: Stack(
        children: [
          // Background glows (Aligned to purple/pink theme of Steps 1-3)
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              height: 260,
              width: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffFF00E5).withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -60,
            right: -60,
            child: Container(
              height: 220,
              width: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffFF7A00).withOpacity(0.10),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // ── HEADER
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                              width: 0.8,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'STEP 7 OF 10',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 11,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: List.generate(10, (index) {
                                final active = index <= 6; // Steps 1-7 active
                                return Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: index == 9 ? 0 : 4,
                                    ),
                                    height: 3.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      gradient: active
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xffFF00E5),
                                                Color(0xffFF7A00),
                                              ],
                                            )
                                          : null,
                                      color: active
                                          ? null
                                          : Colors.white.withOpacity(0.10),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title (Gradient matching Steps 1-3)
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'What is\nyour ',
                                style: GoogleFonts.outfit(
                                  height: 1.1,
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              TextSpan(
                                text: 'Diet Type?',
                                style: GoogleFonts.outfit(
                                  height: 1.1,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                  foreground: Paint()
                                    ..shader =
                                        const LinearGradient(
                                          colors: [
                                            Color(0xffFF00E5),
                                            Color(0xffFF7A00),
                                          ],
                                        ).createShader(
                                          const Rect.fromLTWH(0, 0, 220, 50),
                                        ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your diet type is the foundation of your meal plan. Choose accurately — this determines every food recommendation we generate for you.',
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.60),
                            fontSize: 12,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Diet type cards
                        Text(
                          'SELECT YOUR DIET TYPE',
                          style: GoogleFonts.outfit(
                            color: const Color(0xffFF00E5).withOpacity(0.85),
                            fontSize: 11,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...dietTypes.map((diet) => _buildDietCard(diet)),

                        // Conditional exclusions section
                        if (exclusionOptions.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          Text(
                            'ANY ADDITIONAL EXCLUSIONS?',
                            style: GoogleFonts.outfit(
                              color: const Color(0xffFF7A00).withOpacity(0.85),
                              fontSize: 11,
                              letterSpacing: 1.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Select any foods you cannot or do not eat. Your meal plan will strictly avoid these.',
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.55),
                              fontSize: 11.5,
                              height: 1.4,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: exclusionOptions
                                .map((exc) => _buildExclusionChip(exc))
                                .toList(),
                          ),
                        ],

                        const SizedBox(height: 28),
                      ],
                    ),
                  ),
                ),

                // Continue button (Cohesive gradient matching Steps 1-3)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  child: AnimatedOpacity(
                    opacity: canProceed ? 1.0 : 0.4,
                    duration: const Duration(milliseconds: 200),
                    child: Container(
                      height: 48,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xffB100FF),
                            Color(0xffFF5F6D),
                            Color(0xffFF7A00),
                          ],
                        ),
                        boxShadow: canProceed
                            ? [
                                BoxShadow(
                                  color: const Color(
                                    0xffB100FF,
                                  ).withOpacity(0.30),
                                  blurRadius: 12,
                                  spreadRadius: 1,
                                  offset: const Offset(0, 3),
                                ),
                              ]
                            : [],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: canProceed ? _proceed : null,
                          child: Center(
                            child: Text(
                              'Continue',
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
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
    );
  }

  Widget _buildDietCard(Map<String, dynamic> diet) {
    final isSelected = selectedDietLabel == diet['label'];
    final color = diet['color'] as Color;

    return GestureDetector(
      onTap: () => _selectDietType(diet),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 12),
        height: 96, // Fixed height keeps cards uniform
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withOpacity(0.25),
            width: 1.0,
          ),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xffFF00E5).withOpacity(0.15),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Container(
          margin: const EdgeInsets.all(1.2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.8),
            color: const Color(0xff151520),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16.8),
            child: Row(
              children: [
                const SizedBox(width: 16),
                // Left Radio Circle
                Container(
                  height: 22,
                  width: 22,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.white : Colors.transparent,
                    border: isSelected
                        ? null
                        : Border.all(
                            color: Colors.white.withOpacity(0.35),
                            width: 1.2,
                          ),
                  ),
                  child: isSelected
                      ? const Icon(
                          Icons.check_rounded,
                          color: Colors.black,
                          size: 15,
                        )
                      : null,
                ),
                const SizedBox(width: 16),

                // Middle Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        diet['label'] as String,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        diet['desc'] as String,
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.60),
                          fontSize: 11.5,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Right Image
                SizedBox(
                  width: 110,
                  height: double.infinity,
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.centerRight,
                    children: [
                      Positioned(
                        right: -25, // Bleed off the right edge intentionally
                        child: Image.asset(
                          diet['image'] as String,
                          width: 160, // Significantly larger image
                          height: 160,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExclusionChip(Map<String, dynamic> exc) {
    final key = exc['key'] as String;
    final isSelected = selectedExclusions.contains(key);

    return GestureDetector(
      onTap: () => _toggleExclusion(key),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isSelected
              ? const Color(0xffFF7A00).withOpacity(0.15)
              : Colors.white.withOpacity(0.05),
          border: Border.all(
            color: isSelected
                ? const Color(0xffFF7A00)
                : Colors.white.withOpacity(0.12),
            width: isSelected ? 1.2 : 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              exc['icon'] as IconData,
              color: isSelected
                  ? const Color(0xffFF7A00)
                  : Colors.white.withOpacity(0.50),
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              exc['label'] as String,
              style: GoogleFonts.inter(
                color: isSelected
                    ? const Color(0xffFF7A00)
                    : Colors.white.withOpacity(0.65),
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress(bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      height: 3,
      width: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.5),
        gradient: active
            ? const LinearGradient(
                colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
              )
            : null,
        color: active ? null : Colors.white.withOpacity(0.12),
      ),
    );
  }
}
