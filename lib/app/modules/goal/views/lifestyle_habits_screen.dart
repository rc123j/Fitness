import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../services/onboarding_draft_service.dart';
import 'screening_report_screen.dart';

class LifestyleHabitsScreen extends StatefulWidget {
  final String goalTitle;
  final int goalId;
  final String gender;
  final int age;
  final int height;
  final double weight;
  final int activityLevelId;
  final String activityLevelName;
  final List<int> tastePreferenceIds;
  final String dietLabel;
  final List<String> foodExclusions;
  final List<int> medicalConditionIds;

  const LifestyleHabitsScreen({
    super.key,
    required this.goalTitle,
    required this.goalId,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.activityLevelId,
    required this.activityLevelName,
    required this.tastePreferenceIds,
    required this.dietLabel,
    required this.foodExclusions,
    required this.medicalConditionIds,
  });

  @override
  State<LifestyleHabitsScreen> createState() => _LifestyleHabitsScreenState();
}

class _LifestyleHabitsScreenState extends State<LifestyleHabitsScreen> {
  String selectedSmoking = "No, never";
  String selectedAlcohol = "No, never";

  void _proceed() {
    OnboardingDraftService.saveStep9(
      smokingHabit: selectedSmoking,
      alcoholHabit: selectedAlcohol,
    );
    Get.to(
      () => ScreeningReportScreen(
        goalTitle: widget.goalTitle,
        goalId: widget.goalId,
        gender: widget.gender,
        age: widget.age,
        height: widget.height,
        weight: widget.weight,
        activityLevelId: widget.activityLevelId,
        activityLevelName: widget.activityLevelName,
        tastePreferenceIds: widget.tastePreferenceIds,
        dietLabel: widget.dietLabel,
        foodExclusions: widget.foodExclusions,
        medicalConditionIds: widget.medicalConditionIds,
        symptomIds: const [],
        customConditions: const [],
        smokingHabit: selectedSmoking,
        alcoholHabit: selectedAlcohol,
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
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              height: 260,
              width: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffFF00E5).withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60,
            left: -80,
            child: Container(
              height: 260,
              width: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xff00E5FF).withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Row(
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
                              'STEP 9 OF 10',
                              style: GoogleFonts.outfit(
                                color: const Color(0xffFF00E5).withOpacity(0.9),
                                fontSize: 11,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: List.generate(10, (index) {
                                final active = index <= 8; // Steps 1-9 active
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

                  const SizedBox(height: 24),

                  // Title
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'Lifestyle\n',
                          style: GoogleFonts.outfit(
                            height: 1.1,
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(
                          text: 'Habits',
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
                                    const Rect.fromLTWH(0, 0, 240, 50),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your habits affect your health and metabolism.',
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.50),
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          _buildHabitSection(
                            title: "Smoking & Tobacco",
                            imagePath: "assets/new_images/smoking.png",
                            options: [
                              {"label": "No, Never", "value": "No, never"},
                              {
                                "label": "Occasionally",
                                "value": "Occasionally / Socially",
                              },
                              {
                                "label": "Yes, Regularly",
                                "value": "Yes, regularly",
                              },
                            ],
                            selectedValue: selectedSmoking,
                            onSelect: (val) =>
                                setState(() => selectedSmoking = val),
                            imageTop: -28,
                            imageRight: -4,
                            imageHeight: 120,
                          ),
                          const SizedBox(height: 20),
                          _buildHabitSection(
                            title: "Alcohol Consumption",
                            imagePath: "assets/new_images/alcohol.png",
                            options: [
                              {"label": "No, Never", "value": "No, never"},
                              {
                                "label": "Occasionally / Socially",
                                "value": "Occasionally / Socially",
                              },
                              {
                                "label": "Yes, Regularly",
                                "value": "Yes, regularly",
                              },
                            ],
                            selectedValue: selectedAlcohol,
                            onSelect: (val) =>
                                setState(() => selectedAlcohol = val),
                            imageTop: -20,
                            imageRight: 4,
                            imageHeight: 115,
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),

                  // Next Button
                  Container(
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
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffB100FF).withOpacity(0.30),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: _proceed,
                        child: Center(
                          child: Text(
                            'Next',
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
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitSection({
    required String title,
    required String imagePath,
    required List<Map<String, String>> options,
    required String selectedValue,
    required Function(String) onSelect,
    double imageTop = -10,
    double imageRight = -5,
    double imageHeight = 110,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xff151520), // Matches the dark card background
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              top: 24,
              bottom: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                ...List.generate(options.length, (index) {
                  final option = options[index];
                  final label = option["label"]!;
                  final value = option["value"]!;
                  final isSelected = selectedValue == value;
                  final icon = label.contains("Never")
                      ? Icons.check_box_outlined
                      : Icons.person_outline;

                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == options.length - 1 ? 0 : 12,
                    ),
                    child: _buildHabitOption(
                      label: label,
                      icon: icon,
                      isSelected: isSelected,
                      onTap: () => onSelect(value),
                    ),
                  );
                }),
              ],
            ),
          ),
          Positioned(
            top: imageTop,
            right: imageRight,
            child: Image.asset(
              imagePath,
              height: imageHeight,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHabitOption({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xffB100FF).withOpacity(0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xffB100FF).withOpacity(0.4)
                : Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white.withOpacity(0.4),
              size: 20,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.outfit(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.7),
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ),
            if (isSelected)
              Container(
                height: 22,
                width: 22,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.check, color: Colors.black, size: 15),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
