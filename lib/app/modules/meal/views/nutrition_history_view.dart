import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/meal_controller.dart';

class NutritionHistoryView extends GetView<MealController> {
  const NutritionHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          /// BACKGROUND GLOW BLOBS
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xff00FF87).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 50,
            left: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffB100FF).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// CONTENT
          SafeArea(
            child: Column(
              children: [
                /// Custom Header
                buildHeader(),

                /// Meal Attendance Log — the only thing this screen shows now
                /// (weekly calorie trend moved to the Progress screen).
                Expanded(
                  child: RefreshIndicator(
                    color: const Color(0xff00FF87),
                    backgroundColor: const Color(0xff121220),
                    onRefresh: () async {
                      await controller.fetchMealData();
                      await controller.fetchCalorieHistory();
                    },
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight:
                              MediaQuery.of(context).size.height -
                              200, // fills the screen below the header
                        ),
                        child: buildMealAttendanceCard(),
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

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 0.8,
                ),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Nutrition History",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "Which meals you've completed, day by day",
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.50),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Meal-type id -> real name, taken directly from this user's own
  /// scheduled meals (`mealTimeline`, already populated from the backend's
  /// `meal_type.name` per meal). No hardcoded meal list — a user without
  /// workout nutrition simply won't have 6/7 in here at all.
  Map<int, String> _scheduledMealNames() {
    final map = <int, String>{};
    for (final m in controller.mealTimeline) {
      final id = int.tryParse(m['meal_id']?.toString() ?? '');
      final title = m['title']?.toString();
      if (id != null && title != null && title.isNotEmpty) {
        map[id] = title;
      }
    }
    return map;
  }

  Widget buildMealAttendanceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(color: Colors.white.withOpacity(0.04), width: 1.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Meal Attendance Log",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Visual check of marked vs missed meals",
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.40),
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 32),
          Obx(() {
            final list = controller.calorieHistoryList.toList();
            if (list.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: Text("No logs to show")),
              );
            }

            // Only show meal-type rows this user's plan actually has — e.g.
            // Pre/Post-Workout only appear if their plan includes workout
            // nutrition — taken directly from their own scheduled meals,
            // never a fixed list assumed for every user.
            final mealTypes = _scheduledMealNames().entries
                .map((e) => {"id": e.key, "name": e.value})
                .toList();
            if (mealTypes.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 60),
                child: Center(child: Text("Today's plan hasn't loaded yet")),
              );
            }

            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Table(
                columnWidths: {
                  0: const FixedColumnWidth(130),
                  for (int i = 1; i <= list.length; i++)
                    i: const FixedColumnWidth(64),
                },
                children: [
                  // Table Header Row
                  TableRow(
                    children: [
                      const TableCell(child: SizedBox.shrink()),
                      ...list.map((day) {
                        final dateStr = day['date'] as String;
                        final parts = dateStr.split('-');
                        final dayLabel = parts.length == 3
                            ? "${parts[2]}/${parts[1]}"
                            : "";
                        return TableCell(
                          child: Center(
                            child: Text(
                              dayLabel,
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.60),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),

                  // Table Data Rows
                  ...mealTypes.map((type) {
                    final typeId = type['id'] as int;
                    final typeName = type['name'] as String;

                    return TableRow(
                      children: [
                        // Leftmost column: Meal type name
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 14.0),
                            child: Text(
                              typeName,
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.75),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        // Daily columns
                        ...list.map((day) {
                          final List mealsLogged = day['meals_logged'] ?? [];
                          final bool isLogged = mealsLogged.contains(typeId);
                          final String dayStr = day['date'] as String;
                          final bool isPast = DateTime.parse(dayStr).isBefore(
                            DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                            ),
                          );

                          Widget icon = const SizedBox.shrink();
                          if (isLogged) {
                            icon = const Icon(
                              Icons.check_circle_rounded,
                              color: Color(0xff00FF87),
                              size: 22,
                            );
                          } else if (isPast) {
                            icon = Icon(
                              Icons.cancel_rounded,
                              color: Colors.white.withOpacity(0.15),
                              size: 22,
                            );
                          } else {
                            icon = const Icon(
                              Icons.radio_button_unchecked_rounded,
                              color: Colors.white24,
                              size: 18,
                            );
                          }

                          return TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14.0,
                                ),
                                child: icon,
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
