import 'dart:ui';
import 'package:flutter/material.dart';
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

  final List<Map<String, dynamic>> smokingOptions = [
    {"label": "No, never", "icon": Icons.smoke_free_rounded, "color": const Color(0xff00E5FF), "desc": "Clean respiratory health"},
    {"label": "Occasionally / Socially", "icon": Icons.smoking_rooms_rounded, "color": const Color(0xffFF7A00), "desc": "Moderate antioxidant needs"},
    {"label": "Yes, regularly", "icon": Icons.warning_amber_rounded, "color": const Color(0xffFF5F6D), "desc": "High antioxidant & Vitamin C focus"},
  ];

  final List<Map<String, dynamic>> alcoholOptions = [
    {"label": "No, never", "icon": Icons.no_drinks_rounded, "color": const Color(0xff00E5FF), "desc": "Optimal metabolic function"},
    {"label": "Occasionally / Socially", "icon": Icons.wine_bar_rounded, "color": const Color(0xffFF7A00), "desc": "Standard liver processing"},
    {"label": "Yes, regularly", "icon": Icons.local_bar_rounded, "color": const Color(0xffFF5F6D), "desc": "Extra hydration & liver support"},
  ];

  void _proceed() {
    OnboardingDraftService.saveStep6(
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
            top: -80, right: -80,
            child: Container(
              height: 260, width: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [const Color(0xffFF00E5).withOpacity(0.18), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 60, left: -80,
            child: Container(
              height: 260, width: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [const Color(0xff00E5FF).withOpacity(0.12), Colors.transparent],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
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
                            border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.8),
                          ),
                          child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('STEP 6 OF 7',
                            style: GoogleFonts.outfit(
                              color: const Color(0xffFF00E5).withOpacity(0.9),
                              fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(children: [
                            _buildProgress(true), _buildProgress(true),
                            _buildProgress(true), _buildProgress(true),
                            _buildProgress(true), _buildProgress(true),
                            _buildProgress(false),
                          ]),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: 'Lifestyle\n',
                              style: GoogleFonts.outfit(
                                height: 1.1, color: Colors.white,
                                fontSize: 32, fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(
                              text: 'Habits',
                              style: GoogleFonts.outfit(
                                height: 1.1, fontSize: 32, fontWeight: FontWeight.w900,
                                foreground: Paint()..shader = const LinearGradient(
                                  colors: [Color(0xffFF00E5), Color(0xff00E5FF)],
                                ).createShader(const Rect.fromLTWH(0, 0, 240, 50)),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Understanding your smoking and alcohol consumption helps our AI tailor your daily hydration and antioxidant nutrient requirements.',
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.60), fontSize: 12, height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _buildSectionHeader(
                          'SMOKING & TOBACCO USE',
                          'Helps adjust antioxidant & Vitamin C targets.',
                          const Color(0xff00E5FF),
                          Icons.smoking_rooms_rounded,
                        ),
                        const SizedBox(height: 12),
                        ...smokingOptions.map((opt) => _buildOptionCard(
                          option: opt,
                          isSelected: selectedSmoking == opt['label'],
                          onTap: () => setState(() => selectedSmoking = opt['label'] as String),
                        )),
                        const SizedBox(height: 24),
                        _buildSectionHeader(
                          'ALCOHOL CONSUMPTION',
                          'Helps calibrate hydration & liver support nutrients.',
                          const Color(0xffFF7A00),
                          Icons.wine_bar_rounded,
                        ),
                        const SizedBox(height: 12),
                        ...alcoholOptions.map((opt) => _buildOptionCard(
                          option: opt,
                          isSelected: selectedAlcohol == opt['label'],
                          onTap: () => setState(() => selectedAlcohol = opt['label'] as String),
                        )),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
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
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffB100FF).withOpacity(0.30),
                          blurRadius: 12, spreadRadius: 1, offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: _proceed,
                        child: Center(
                          child: Text('View My Assessment Report',
                            style: GoogleFonts.outfit(
                              color: Colors.white, fontSize: 16,
                              fontWeight: FontWeight.bold, letterSpacing: 0.5,
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

  Widget _buildSectionHeader(String title, String subtitle, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.20), width: 0.8),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                  style: GoogleFonts.outfit(
                    color: color, fontSize: 11, letterSpacing: 1.4, fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(subtitle,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.60), fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionCard({
    required Map<String, dynamic> option,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final color = option['color'] as Color;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.12) : const Color(0xff0A0A16),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.10),
            width: isSelected ? 1.5 : 0.8,
          ),
          boxShadow: isSelected ? [
            BoxShadow(color: color.withOpacity(0.20), blurRadius: 10, spreadRadius: 1),
          ] : [],
        ),
        child: Row(
          children: [
            Container(
              height: 42, width: 42,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(option['icon'] as IconData, color: color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(option['label'] as String,
                    style: GoogleFonts.outfit(
                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.9),
                      fontSize: 15, fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(option['desc'] as String,
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.55), fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 22, width: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? color : Colors.white.withOpacity(0.25), width: 1.5,
                 ),
              ),
              child: isSelected ? const Icon(Icons.check_rounded, color: Colors.black, size: 14) : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress(bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      height: 3, width: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.5),
        gradient: active ? const LinearGradient(
          colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
        ) : null,
        color: active ? null : Colors.white.withOpacity(0.12),
      ),
    );
  }
}
