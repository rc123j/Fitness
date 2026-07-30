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
                  colors: [const Color(0xffFF00E5).withOpacity(0.18), Colors.transparent],
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
                  colors: [const Color(0xff00E5FF).withOpacity(0.12), Colors.transparent],
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
                            border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.8),
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
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
                                    margin: EdgeInsets.only(right: index == 9 ? 0 : 4),
                                    height: 3.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      gradient: active ? const LinearGradient(colors: [Color(0xffFF00E5), Color(0xffFF7A00)]) : null,
                                      color: active ? null : Colors.white.withOpacity(0.10),
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
                    text: TextSpan(children: [
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
                            ..shader = const LinearGradient(
                              colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
                            ).createShader(const Rect.fromLTWH(0, 0, 240, 50)),
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your habits affect your health and metabolism.',
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.50),
                      fontSize: 13,
                    ),
                  ),

                  const Spacer(),

                  // 1. Smoking & Tobacco Section
                  Text(
                    "Smoking & Tobacco",
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            _buildHabitCard(
                              label: "No, Never",
                              isSelected: selectedSmoking == "No, never",
                              color: const Color(0xffFF00E5),
                              onTap: () => setState(() => selectedSmoking = "No, never"),
                            ),
                            _buildHabitCard(
                              label: "Occasionally",
                              isSelected: selectedSmoking == "Occasionally / Socially",
                              color: const Color(0xffFF00E5),
                              onTap: () => setState(() => selectedSmoking = "Occasionally / Socially"),
                            ),
                            _buildHabitCard(
                              label: "Yes, Regularly",
                              isSelected: selectedSmoking == "Yes, regularly",
                              color: const Color(0xffFF00E5),
                              onTap: () => setState(() => selectedSmoking = "Yes, regularly"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Image.asset(
                            "assets/new_images/smoking_habit.png",
                            height: 90,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xffFF00E5).withOpacity(0.08),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xffFF00E5).withOpacity(0.2), width: 1),
                                ),
                                child: const Icon(
                                  Icons.smoke_free_rounded,
                                  color: Color(0xffFF00E5),
                                  size: 36,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  // 2. Alcohol Section
                  Text(
                    "Alcohol Consumption",
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          children: [
                            _buildHabitCard(
                              label: "No, Never",
                              isSelected: selectedAlcohol == "No, never",
                              color: const Color(0xffFF7A00),
                              onTap: () => setState(() => selectedAlcohol = "No, never"),
                            ),
                            _buildHabitCard(
                              label: "Occasionally / Socially",
                              isSelected: selectedAlcohol == "Occasionally / Socially",
                              color: const Color(0xffFF7A00),
                              onTap: () => setState(() => selectedAlcohol = "Occasionally / Socially"),
                            ),
                            _buildHabitCard(
                              label: "Yes, Regularly",
                              isSelected: selectedAlcohol == "Yes, regularly",
                              color: const Color(0xffFF7A00),
                              onTap: () => setState(() => selectedAlcohol = "Yes, regularly"),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 4,
                        child: Center(
                          child: Image.asset(
                            "assets/new_images/alcohol_habit.png",
                            height: 90,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: const Color(0xffFF7A00).withOpacity(0.08),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xffFF7A00).withOpacity(0.2), width: 1),
                                ),
                                child: const Icon(
                                  Icons.wine_bar_rounded,
                                  color: Color(0xffFF7A00),
                                  size: 36,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(flex: 2),

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

  Widget _buildHabitCard({
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white.withOpacity(0.04) : const Color(0xff0D0D1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color.withOpacity(0.6) : Colors.white.withOpacity(0.05),
            width: isSelected ? 1.2 : 0.8,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 18,
              width: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? color : Colors.white.withOpacity(0.2),
                  width: 1.2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 10)
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.outfit(
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
