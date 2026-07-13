import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import 'screening_report_screen.dart';

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
  // Multi-select sets for master conditions and symptoms
  final Set<int> selectedConditionIds = {};
  final Set<int> selectedSymptomIds = {};
  bool noConditions = false;
  bool noSymptoms = false;

  // Custom medical conditions entered by user
  final List<String> customConditionsList = [];
  final Set<String> selectedCustomConditions = {};
  final TextEditingController _customConditionController = TextEditingController();

  // Expanded master medical conditions (Common in India)
  final List<Map<String, dynamic>> medicalConditions = [
    {'id': 1, 'label': 'Diabetes / Pre-Diabetes', 'icon': Icons.water_drop_rounded, 'color': const Color(0xffFF5F6D), 'note': 'Restricts high-GI foods & refined sugars'},
    {'id': 2, 'label': 'Hypertension (High BP)', 'icon': Icons.favorite_rounded, 'color': const Color(0xffFF7A00), 'note': 'Reduces sodium-heavy foods & pickles'},
    {'id': 3, 'label': 'PCOS / PCOD', 'icon': Icons.settings_rounded, 'color': const Color(0xffC026D3), 'note': 'Hormone-balancing, low-glycemic foods'},
    {'id': 4, 'label': 'Thyroid (Hypo/Hyper)', 'icon': Icons.energy_savings_leaf_rounded, 'color': const Color(0xff7B61FF), 'note': 'Filters thyroid-affecting goitrogen foods'},
    {'id': 5, 'label': 'GERD / Acid Reflux', 'icon': Icons.local_fire_department_rounded, 'color': const Color(0xffFF9500), 'note': 'Avoids deep-fried, spicy and heavy foods'},
    {'id': 6, 'label': 'Heart Disease', 'icon': Icons.healing_rounded, 'color': const Color(0xffFF2D55), 'note': 'Low cholesterol, low trans-fat recommendations'},
    {'id': 7, 'label': 'High Cholesterol', 'icon': Icons.speed_rounded, 'color': const Color(0xffFFCC00), 'note': 'Prioritizes fiber-rich whole grains & oats'},
    {'id': 8, 'label': 'Fatty Liver (NAFLD)', 'icon': Icons.spa_rounded, 'color': const Color(0xff4CD964), 'note': 'Focuses on antioxidants & low simple carbs'},
    {'id': 9, 'label': 'Kidney Disease (CKD)', 'icon': Icons.bubble_chart_rounded, 'color': const Color(0xff5AC8FA), 'note': 'Regulates protein, potassium & sodium levels'},
    {'id': 10, 'label': 'Uric Acid / Gout', 'icon': Icons.insights_rounded, 'color': const Color(0xff5856D6), 'note': 'Restricts purine-rich foods & lentils'},
    {'id': 11, 'label': 'IBS / Sensitive Gut', 'icon': Icons.summarize_rounded, 'color': const Color(0xffFF9500), 'note': 'Low FODMAP / highly-digestible foods priority'},
    {'id': 12, 'label': 'Gluten Allergy / Celiac', 'icon': Icons.grain_rounded, 'color': const Color(0xffFF8F00), 'note': 'Strict wheat, barley & rye exclusions'},
  ];

  // Master symptoms list
  final List<Map<String, dynamic>> symptoms = [
    {'id': 1, 'label': 'Chronic Fatigue', 'icon': Icons.battery_0_bar_rounded, 'color': const Color(0xffFF5F6D)},
    {'id': 2, 'label': 'Bloating / Digestion', 'icon': Icons.bubble_chart_rounded, 'color': const Color(0xffFF7A00)},
    {'id': 3, 'label': 'Hair Loss', 'icon': Icons.air_rounded, 'color': const Color(0xff7B61FF)},
    {'id': 4, 'label': 'Poor Sleep / Insomnia', 'icon': Icons.bedtime_rounded, 'color': const Color(0xff00E5FF)},
    {'id': 5, 'label': 'Sugar / Carb Cravings', 'icon': Icons.local_cafe_rounded, 'color': const Color(0xffC026D3)},
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

  void _toggleSymptom(int id) {
    setState(() {
      noSymptoms = false;
      if (selectedSymptomIds.contains(id)) {
        selectedSymptomIds.remove(id);
      } else {
        selectedSymptomIds.add(id);
      }
    });
  }

  void _setNoConditions(bool val) {
    setState(() {
      noConditions = val;
      if (val) {
        selectedConditionIds.clear();
        selectedCustomConditions.clear();
      }
    });
  }

  void _setNoSymptoms(bool val) {
    setState(() {
      noSymptoms = val;
      if (val) selectedSymptomIds.clear();
    });
  }

  void _addCustomCondition() {
    final text = _customConditionController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      noConditions = false;
      if (!customConditionsList.contains(text)) {
        customConditionsList.add(text);
      }
      selectedCustomConditions.add(text);
      _customConditionController.clear();
    });
  }

  void _toggleCustomCondition(String text) {
    setState(() {
      noConditions = false;
      if (selectedCustomConditions.contains(text)) {
        selectedCustomConditions.remove(text);
      } else {
        selectedCustomConditions.add(text);
      }
    });
  }

  bool get canProceed =>
      (selectedConditionIds.isNotEmpty || selectedCustomConditions.isNotEmpty || noConditions) &&
      (selectedSymptomIds.isNotEmpty || noSymptoms);

  void _proceed() {
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
        medicalConditionIds: selectedConditionIds.toList(),
        symptomIds: selectedSymptomIds.toList(),
        customConditions: selectedCustomConditions.toList(),
      ),
      transition: Transition.cupertino,
    );
  }

  @override
  void dispose() {
    _customConditionController.dispose();
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('STEP 5 OF 6',
                            style: GoogleFonts.outfit(
                              color: const Color(0xffFF00E5).withOpacity(0.9),
                              fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(children: [
                            _buildProgress(true), _buildProgress(true),
                            _buildProgress(true), _buildProgress(true),
                            _buildProgress(true), _buildProgress(false),
                          ]),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => Get.find<AuthService>().logout(),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.8),
                          ),
                          child: const Icon(Icons.logout_rounded, color: Colors.white, size: 16),
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
                        
                        // ── CUSTOM MEDICAL CONDITION INPUT
                        const SizedBox(height: 10),
                        Text('ADD OTHER CONDITION (CUSTOM)',
                          style: GoogleFonts.outfit(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 42,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.04),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white.withOpacity(0.1), width: 0.8),
                                ),
                                child: TextField(
                                  controller: _customConditionController,
                                  style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                                  decoration: InputDecoration(
                                    hintText: 'e.g. Migraine, Kidney Stones, Asthma',
                                    hintStyle: GoogleFonts.inter(color: Colors.white.withOpacity(0.3), fontSize: 13),
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  ),
                                  onSubmitted: (_) => _addCustomCondition(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: _addCustomCondition,
                              child: Container(
                                height: 42, width: 42,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xffFF00E5).withOpacity(0.2),
                                      blurRadius: 6, spreadRadius: 1,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),

                        // Render Custom Conditions Chips
                        if (customConditionsList.isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8, runSpacing: 8,
                            children: customConditionsList.map((cond) {
                              final isSelected = selectedCustomConditions.contains(cond);
                              return GestureDetector(
                                onTap: () => _toggleCustomCondition(cond),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 180),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: isSelected ? const Color(0xffFF00E5).withOpacity(0.15) : Colors.white.withOpacity(0.04),
                                    border: Border.all(
                                      color: isSelected ? const Color(0xffFF00E5) : Colors.white.withOpacity(0.12),
                                      width: isSelected ? 1.2 : 0.8,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.label_rounded,
                                        color: isSelected ? const Color(0xffFF00E5) : Colors.white.withOpacity(0.4),
                                        size: 13,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(cond,
                                        style: GoogleFonts.inter(
                                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                                          fontSize: 12, fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            customConditionsList.remove(cond);
                                            selectedCustomConditions.remove(cond);
                                          });
                                        },
                                        child: Icon(Icons.close_rounded,
                                          color: Colors.white.withOpacity(isSelected ? 0.8 : 0.4),
                                          size: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],

                        const SizedBox(height: 12),
                        _buildNoneOption(
                          label: 'None — I have no medical conditions',
                          isSelected: noConditions,
                          onTap: () => _setNoConditions(!noConditions),
                        ),

                        const SizedBox(height: 28),

                        // ── SECTION 2: Symptoms
                        _buildSectionHeader(
                          'CURRENT SYMPTOMS?',
                          'Select all that you experience regularly. We\'ll prioritize nutrients that address these.',
                          const Color(0xffFF7A00),
                          Icons.monitor_heart_rounded,
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 10, runSpacing: 10,
                          children: symptoms.map((s) => _buildSymptomChip(s)).toList(),
                        ),
                        const SizedBox(height: 12),
                        _buildNoneOption(
                          label: 'None — No significant symptoms',
                          isSelected: noSymptoms,
                          onTap: () => _setNoSymptoms(!noSymptoms),
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
                            child: Text('Generate My Plan',
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

  Widget _buildSymptomChip(Map<String, dynamic> symptom) {
    final id = symptom['id'] as int;
    final isSelected = selectedSymptomIds.contains(id);
    final color = symptom['color'] as Color;

    return GestureDetector(
      onTap: () => _toggleSymptom(id),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: isSelected ? color.withOpacity(0.15) : Colors.white.withOpacity(0.05),
          border: Border.all(
            color: isSelected ? color : Colors.white.withOpacity(0.12),
            width: isSelected ? 1.2 : 0.8,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(symptom['icon'] as IconData,
              color: isSelected ? color : Colors.white.withOpacity(0.45),
              size: 14,
            ),
            const SizedBox(width: 7),
            Text(symptom['label'] as String,
              style: GoogleFonts.inter(
                color: isSelected ? color : Colors.white.withOpacity(0.65),
                fontSize: 12.5, fontWeight: FontWeight.w500,
              ),
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
      margin: const EdgeInsets.only(right: 4),
      height: 3, width: 28,
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
