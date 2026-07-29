import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../services/onboarding_draft_service.dart';
import 'lifestyle_habits_screen.dart';

class HealthProfileScreen extends StatefulWidget {
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

  const HealthProfileScreen({
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
  });

  @override
  State<HealthProfileScreen> createState() => _HealthProfileScreenState();
}

class _HealthProfileScreenState extends State<HealthProfileScreen> {
  // Multi-select set for master conditions
  final Set<int> selectedConditionIds = {};
  bool noConditions = false;

  // Expanded master medical conditions
  final List<Map<String, dynamic>> medicalConditions = [
    {'id': 1, 'label': 'Diabetes / Pre-Diabetes', 'icon': Icons.water_drop_rounded, 'color': const Color(0xffFF5F6D), 'note': 'Restricts high-GI foods & refined sugars'},
    {'id': 2, 'label': 'Hypertension (High BP)', 'icon': Icons.favorite_rounded, 'color': const Color(0xffFF7A00), 'note': 'Reduces sodium-heavy foods & pickles'},
  ];

  // Filter conditions: PCOS only visible for females
  List<Map<String, dynamic>> get filteredConditions {
    return medicalConditions.where((c) {
      if (c['label']!.toString().contains('PCOS') && widget.gender.toLowerCase() != 'female') {
        return false;
      }
      return true;
    }).toList();
  }

  void _toggleCondition(int id) {
    setState(() {
      noConditions = false;
      if (selectedConditionIds.contains(id)) {
        selectedConditionIds.remove(id);
      } else {
        selectedConditionIds.add(id);
      }
    });
  }

  void _setNoConditions(bool val) {
    setState(() {
      noConditions = val;
      if (val) {
        selectedConditionIds.clear();
      }
    });
  }

  bool get canProceed => selectedConditionIds.isNotEmpty || noConditions;

  void _proceed() {
    OnboardingDraftService.saveStep8(
      medicalConditionIds: selectedConditionIds.toList(),
    );
    Get.to(
      () => LifestyleHabitsScreen(
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
        medicalConditionIds: selectedConditionIds.toList(),
      ),
      transition: Transition.cupertino,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050510),
      body: Stack(
        children: [
          // Background glows (Aligned to purple/pink theme of Steps 1-3)
          Positioned(
            top: -80, right: -80,
            child: Container(
              height: 240, width: 240,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xffFF00E5).withOpacity(0.12), Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: -60, left: -40,
            child: Container(
              height: 200, width: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  const Color(0xffFF7A00).withOpacity(0.10), Colors.transparent,
                ]),
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
                            Text('STEP 8 OF 10',
                              style: GoogleFonts.outfit(
                                color: const Color(0xffFF00E5).withOpacity(0.9),
                                fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(children: List.generate(10, (index) {
                              final active = index <= 7; // Steps 1-8 active
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
                            })),
                          ],
                        ),
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
                              text: 'Your\n',
                              style: GoogleFonts.outfit(
                                height: 1.1, color: Colors.white,
                                fontSize: 32, fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(
                              text: 'Health Profile',
                              style: GoogleFonts.outfit(
                                height: 1.1, fontSize: 32, fontWeight: FontWeight.w900,
                                foreground: Paint()..shader = const LinearGradient(
                                  colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
                                ).createShader(const Rect.fromLTWH(0, 0, 240, 50)),
                              ),
                            ),
                          ]),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'This helps us generate a safe, customized and medically-aware meal plan. Your data is private and never shared.',
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.60), fontSize: 12, height: 1.45,
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ── SECTION 1: Medical Conditions
                        _buildSectionHeader(
                          'ANY MEDICAL CONDITIONS?',
                          'We will filter out foods that may aggravate your condition.',
                          const Color(0xffFF00E5),
                          Icons.local_hospital_rounded,
                        ),
                        const SizedBox(height: 12),
                        ...filteredConditions.map((c) => _buildConditionCard(c)),
                        
                        const SizedBox(height: 12),
                        _buildNoneOption(
                          label: 'None — I have no medical conditions',
                          isSelected: noConditions,
                          onTap: () => _setNoConditions(!noConditions),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),

                // Continue Button (Aligned to pink/purple/orange gradient theme)
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
                        boxShadow: canProceed ? [
                          BoxShadow(
                            color: const Color(0xffB100FF).withOpacity(0.30),
                            blurRadius: 12, spreadRadius: 1, offset: const Offset(0, 3),
                          ),
                        ] : [],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(24),
                          onTap: canProceed ? _proceed : null,
                          child: Center(
                            child: Text('Continue',
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
                const SizedBox(height: 3),
                Text(subtitle,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.55), fontSize: 11, height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionCard(Map<String, dynamic> condition) {
    final id = condition['id'] as int;
    final isSelected = selectedConditionIds.contains(id);
    final color = condition['color'] as Color;

    return GestureDetector(
      onTap: () => _toggleCondition(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isSelected ? color.withOpacity(0.12) : Colors.white.withOpacity(0.04),
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.10),
            width: isSelected ? 1.2 : 0.8,
          ),
        ),
        child: Row(
          children: [
            Icon(condition['icon'] as IconData,
              color: isSelected ? color : Colors.white.withOpacity(0.40),
              size: 18,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(condition['label'] as String,
                    style: GoogleFonts.outfit(
                      color: isSelected ? color : Colors.white,
                      fontSize: 13.5, fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 2),
                    Text(condition['note'] as String,
                      style: GoogleFonts.inter(
                        color: color.withOpacity(0.70), fontSize: 10.5, height: 1.3,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 20, width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? color : Colors.white.withOpacity(0.25), width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, color: Colors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoneOption({required String label, required bool isSelected, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.white.withOpacity(0.10) : Colors.transparent,
          border: Border.all(
            color: isSelected ? Colors.white.withOpacity(0.4) : Colors.white.withOpacity(0.12),
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 18, width: 18,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.white : Colors.transparent,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.3), width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check_rounded, color: Colors.black, size: 11)
                  : null,
            ),
            const SizedBox(width: 12),
            Text(label,
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(isSelected ? 0.90 : 0.55),
                fontSize: 13, fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
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
