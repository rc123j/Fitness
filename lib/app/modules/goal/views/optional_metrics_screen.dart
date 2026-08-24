import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'screening_report_screen.dart';

class OptionalMetricsScreen extends StatefulWidget {
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
  final String smokingHabit;
  final String alcoholHabit;

  const OptionalMetricsScreen({
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
    required this.smokingHabit,
    required this.alcoholHabit,
  });

  @override
  State<OptionalMetricsScreen> createState() => _OptionalMetricsScreenState();
}

class _OptionalMetricsScreenState extends State<OptionalMetricsScreen> {
  String? selectedWorkoutStyle;
  String? selectedWorkoutTime;
  final TextEditingController waistController = TextEditingController();
  final TextEditingController hipController = TextEditingController();
  final Set<String> selectedDeficiencies = {};

  final List<String> workoutStyles = ['Weightlifting', 'Cardio/Running', 'Yoga/Pilates', 'CrossFit', 'None'];
  final List<String> workoutTimes = ['Morning', 'Afternoon', 'Evening', 'Night'];
  final List<String> deficiencyList = ['Iron', 'Vitamin D', 'Vitamin B12', 'Zinc', 'Calcium'];

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
        medicalConditionIds: widget.medicalConditionIds,
        symptomIds: const [],
        customConditions: const [],
        smokingHabit: widget.smokingHabit,
        alcoholHabit: widget.alcoholHabit,
        workoutStyle: selectedWorkoutStyle,
        workoutTime: selectedWorkoutTime,
        waistCm: double.tryParse(waistController.text),
        hipCm: double.tryParse(hipController.text),
        deficiencies: selectedDeficiencies.toList(),
      ),
      transition: Transition.cupertino,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050510),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
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
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'OPTIONAL DETAILS',
                    style: GoogleFonts.outfit(color: Colors.white, fontSize: 11, letterSpacing: 1.5, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Text(
                'Help the AI perfect your plan',
                style: GoogleFonts.outfit(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, height: 1.2),
              ),
              const SizedBox(height: 10),
              Text(
                'These clinical details are optional but help the AI recommend exact supplements and meal timings.',
                style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.6), fontSize: 15, height: 1.4),
              ),
              const SizedBox(height: 30),
              
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    Text('Known Deficiencies', style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: deficiencyList.map((d) {
                        final isSelected = selectedDeficiencies.contains(d);
                        return ChoiceChip(
                          label: Text(d),
                          selected: isSelected,
                          onSelected: (val) {
                            setState(() {
                              val ? selectedDeficiencies.add(d) : selectedDeficiencies.remove(d);
                            });
                          },
                          backgroundColor: Colors.white.withOpacity(0.05),
                          selectedColor: const Color(0xffFF00E5).withOpacity(0.3),
                          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white54),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                    
                    Text('Workout Style', style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: workoutStyles.map((w) {
                        final isSelected = selectedWorkoutStyle == w;
                        return ChoiceChip(
                          label: Text(w),
                          selected: isSelected,
                          onSelected: (val) => setState(() => selectedWorkoutStyle = val ? w : null),
                          backgroundColor: Colors.white.withOpacity(0.05),
                          selectedColor: const Color(0xff7B61FF).withOpacity(0.5),
                          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white54),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                    
                    Text('Workout Time', style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: workoutTimes.map((t) {
                        final isSelected = selectedWorkoutTime == t;
                        return ChoiceChip(
                          label: Text(t),
                          selected: isSelected,
                          onSelected: (val) => setState(() => selectedWorkoutTime = val ? t : null),
                          backgroundColor: Colors.white.withOpacity(0.05),
                          selectedColor: const Color(0xff7B61FF).withOpacity(0.5),
                          labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.white54),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 30),
                    
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Waist (cm)', style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              TextField(
                                controller: waistController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.05),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Hip (cm)', style: GoogleFonts.outfit(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              TextField(
                                controller: hipController,
                                keyboardType: TextInputType.number,
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.white.withOpacity(0.05),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
              
              // Proceed Button
              GestureDetector(
                onTap: _proceed,
                child: Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: const LinearGradient(
                      colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Generate Plan',
                      style: GoogleFonts.outfit(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
