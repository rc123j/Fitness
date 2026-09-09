import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/progress_controller.dart';
import '../../main_navigation/controllers/main_navigation_controller.dart';

class NewWidgetsHelper extends GetView<ProgressController> {
  const NewWidgetsHelper({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Widget buildGreeting(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good Morning,",
                  style: GoogleFonts.outfit(
                    color: const Color(0xffB100FF),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      "${controller.userName.value.isNotEmpty ? controller.userName.value.split(' ')[0] : 'Rahul'}!",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      "👋",
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Small steps today,\nstronger you tomorrow.",
                  style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 120,
            width: 120,
            child: Image.asset(
              'assets/home/ChatGPT Image Aug 12, 2026, 12_42_22 PM.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  'assets/profile/avatar.png',
                  fit: BoxFit.contain,
                  errorBuilder: (c, e, s) => const Icon(Icons.person, size: 80, color: Colors.white),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildJourneyProgressCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18.0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xff1C1533),
            Color(0xff0D0818),
          ],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Your Journey Progress",
            style: GoogleFonts.outfit(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "${controller.daysRemaining.value}",
                          style: GoogleFonts.outfit(
                            color: const Color(0xffFF00E5),
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          "Days Left",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "of your 30-day goal",
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Stack(
                      children: [
                        Container(
                          height: 8,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        FractionallySizedBox(
                          widthFactor: controller.currentDay.value / 30,
                          child: Container(
                            height: 8,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xffB100FF), Color(0xffFF7A00)],
                              ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${controller.currentDay.value} Days Completed",
                          style: GoogleFonts.outfit(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "${((controller.currentDay.value / 30) * 100).toInt()}%",
                          style: GoogleFonts.outfit(
                            color: const Color(0xffFF7A00),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffB100FF).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xffB100FF).withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "View Plan",
                            style: GoogleFonts.outfit(
                              color: const Color(0xffB100FF),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xffB100FF),
                            size: 16,
                          ),  
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: 120,
                        width: 120,
                        child: CircularProgressIndicator(
                          value: controller.currentDay.value / 30,
                          strokeWidth: 8,
                          backgroundColor: Colors.white.withOpacity(0.1),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Color(0xffFF7A00),
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                "${((controller.currentDay.value / 30) * 100).toInt()}",
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "%",
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            "Complete",
                            style: GoogleFonts.outfit(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildDisciplineBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18.0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xff1C1533),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xffFF7A00).withOpacity(0.2),
            ),
            child: const Icon(
              Icons.track_changes_rounded,
              color: Color(0xffFF7A00),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Discipline today, results tomorrow.",
              style: GoogleFonts.outfit(
                color: Colors.white.withOpacity(0.9),
                fontSize: 14,
              ),
            ),
          ),
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: Colors.white54,
            size: 14,
          ),
        ],
      ),
    );
  }

  Widget buildNewNutritionCards() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Row(
        children: [
          Expanded(
            child: buildMacroCard(
              icon: Icons.local_fire_department_rounded,
              iconColor: const Color(0xffFF7A00),
              title: "Calories",
              value: "${controller.todayConsumedCalories.value.toInt()}/${controller.targetCalories.value.toInt()}",
              unit: "kcal",
              progress: controller.targetCalories.value > 0
                  ? (controller.todayConsumedCalories.value / controller.targetCalories.value).clamp(0.0, 1.0)
                  : 0.0,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: buildMacroCard(
              icon: Icons.fitness_center_rounded,
              iconColor: const Color(0xffB100FF),
              title: "Protein",
              value: "${controller.todayConsumedProtein.value.toInt()}/${controller.todayTargetProtein.value.toInt()}",
              unit: "g",
              progress: controller.todayTargetProtein.value > 0
                  ? (controller.todayConsumedProtein.value / controller.todayTargetProtein.value).clamp(0.0, 1.0)
                  : 0.0,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: buildMacroCard(
              icon: Icons.grass_rounded,
              iconColor: const Color(0xffFFD166),
              title: "Carbs",
              value: "${controller.todayConsumedCarbs.value.toInt()}/${controller.todayTargetCarbs.value.toInt()}",
              unit: "g",
              progress: controller.todayTargetCarbs.value > 0
                  ? (controller.todayConsumedCarbs.value / controller.todayTargetCarbs.value).clamp(0.0, 1.0)
                  : 0.0,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: buildMacroCard(
              icon: Icons.water_drop_rounded,
              iconColor: const Color(0xff00FF87),
              title: "Fats",
              value: "${controller.todayConsumedFat.value.toInt()}/${controller.todayTargetFat.value.toInt()}",
              unit: "g",
              progress: controller.todayTargetFat.value > 0
                  ? (controller.todayConsumedFat.value / controller.todayTargetFat.value).clamp(0.0, 1.0)
                  : 0.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMacroCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String unit,
    required double progress,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xff120D23),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 28),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: GoogleFonts.outfit(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: GoogleFonts.outfit(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 10,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 4,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(2),
            ),
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  color: iconColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
