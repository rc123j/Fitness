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
    {
      'id': 1,
      'label': 'Diabetes',
      'icon': Icons.water_drop_rounded,
      'color': const Color(0xff00E5FF),
      'note': 'Restricts high-GI foods & refined sugars',
    },
    {
      'id': 4,
      'label': 'Pre-Diabetes',
      'icon': Icons.water_drop_rounded,
      'color': const Color(0xff00E5FF),
      'note': 'Restricts high-GI foods & refined sugars',
    },
    {
      'id': 2,
      'label': 'Hypertension (High BP)',
      'icon': Icons.favorite_rounded,
      'color': const Color(0xffFF5F6D),
      'note': 'Reduces sodium-heavy foods & pickles',
    },
  ];

  // Filter conditions
  List<Map<String, dynamic>> get filteredConditions {
    return medicalConditions.where((c) {
      if (c['label']!.toString().contains('PCOS') &&
          widget.gender.toLowerCase() != 'female') {
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
    final themeColor = widget.gender == "Male"
        ? const Color(0xff7B61FF)
        : const Color(0xffFF00E5);

    return Scaffold(
      backgroundColor: const Color(0xff050510),
      body: Stack(
        children: [
          // Background glows
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              height: 240,
              width: 240,
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
            left: -40,
            child: Container(
              height: 200,
              width: 200,
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

          // Centered Clipboard 3D Illustration Graphic (drawn in background)
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Image.asset(
                "assets/new_images/health_profile.png",
                height: 490,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [Color(0xffFF00E5), Color(0xff7B61FF)],
                    ).createShader(bounds),
                    child: const Icon(
                      Icons.assignment_turned_in_rounded,
                      size: 280,
                      color: Colors.white,
                    ),
                  );
                },
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
                              'STEP 5 OF 7',
                              style: GoogleFonts.outfit(
                                color: const Color(0xffFF00E5).withOpacity(0.9),
                                fontSize: 11,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: List.generate(7, (index) {
                                final active = index <= 4; // Steps 1-5 active
                                return Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: index == 6 ? 0 : 4,
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
                          text: 'Your\n',
                          style: GoogleFonts.outfit(
                            height: 1.1,
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(
                          text: 'Health Profile',
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
                    'This helps us create a safe and medically-aware plan for you.',
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.50),
                      fontSize: 13,
                    ),
                  ),

                  const Spacer(flex: 4),

                  // Medical conditions list - full-width vertical layout, overlays background image
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Any medical conditions?",
                        style: GoogleFonts.outfit(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...filteredConditions.map((c) => _buildConditionCard(c)),
                      _buildNoneCard(),
                    ],
                  ),

                  const Spacer(flex: 1),

                  // Continue Button (Aligned to pink/purple/orange gradient theme)
                  AnimatedOpacity(
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

  Widget _buildConditionCard(Map<String, dynamic> condition) {
    final id = condition['id'] as int;
    final isSelected = selectedConditionIds.contains(id);
    final color = condition['color'] as Color;

    return GestureDetector(
      onTap: () => _toggleCondition(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: isSelected
              ? color.withOpacity(0.12)
              : Colors.white.withOpacity(0.05),
          border: Border.all(
            color: isSelected
                ? color.withOpacity(0.6)
                : Colors.white.withOpacity(0.08),
            width: isSelected ? 1.2 : 0.8,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                condition['icon'] as IconData,
                color: color,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                condition['label'] as String,
                style: GoogleFonts.outfit(
                  color: isSelected
                      ? Colors.white
                      : Colors.white.withOpacity(0.7),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? color : Colors.white.withOpacity(0.2),
                  width: 1.2,
                ),
              ),
              child: isSelected
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 12,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoneCard() {
    return GestureDetector(
      onTap: () => _setNoConditions(!noConditions),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: noConditions
              ? const Color(0xffFF7A00).withOpacity(0.12)
              : Colors.white.withOpacity(0.05),
          border: Border.all(
            color: noConditions
                ? const Color(0xffFF7A00).withOpacity(0.6)
                : Colors.white.withOpacity(0.08),
            width: noConditions ? 1.2 : 0.8,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xffFF7A00).withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_outline_rounded,
                color: Color(0xffFF7A00),
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                "None — I have no conditions",
                style: GoogleFonts.outfit(
                  color: noConditions
                      ? Colors.white
                      : Colors.white.withOpacity(0.7),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: noConditions
                    ? const Color(0xffFF7A00)
                    : Colors.transparent,
                border: Border.all(
                  color: noConditions
                      ? const Color(0xffFF7A00)
                      : Colors.white.withOpacity(0.2),
                  width: 1.2,
                ),
              ),
              child: noConditions
                  ? const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 12,
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
