import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/meal_controller.dart';
import '../../progress/controllers/progress_controller.dart';
import '../../../widgets/app_shimmer.dart';
import '../../../widgets/scroll_nav_bar_binder.dart';

class _InsightTab {
  final String label;
  final IconData icon;
  final Widget Function() builder;
  const _InsightTab({
    required this.label,
    required this.icon,
    required this.builder,
  });
}

class MealView extends GetView<MealController> {
  const MealView({super.key});

  // Hero image based on user's progress or generic healthy lifestyle theme
  String _getHeroImageUrl() {
    return 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=1200&q=80';
  }

  String _getMealImageUrl(String title) {
    final t = title.toLowerCase();
    if (t.contains('breakfast')) {
      return 'https://images.unsplash.com/photo-1493770348161-369560ae357d?auto=format&fit=crop&w=600&q=80';
    } else if (t.contains('lunch')) {
      return 'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=600&q=80';
    } else if (t.contains('dinner')) {
      return 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=600&q=80';
    } else {
      return 'https://images.unsplash.com/photo-1490885578174-acda8905c2c6?auto=format&fit=crop&w=600&q=80';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          // Background Glow Blobs
          Positioned(
            top: -120,
            left: -80,
            child: Container(
              height: 350,
              width: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffB100FF).withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              height: 300,
              width: 300,
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
            bottom: 100,
            left: -150,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffB100FF).withOpacity(0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main scrollable content
          Positioned.fill(
            child: ScrollNavBarBinder(
              builder: (context, scrollController) => RefreshIndicator(
                color: const Color(0xffB100FF),
                backgroundColor: const Color(0xff121220),
                onRefresh: () async {
                  await controller.fetchMealData();
                  await controller.fetchCalorieHistory();
                },
                child: CustomScrollView(
                  controller: scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    // 1. COLLAPSIBLE APP BAR
                    _buildSliverAppBar(),

                    // 2. MAIN SCROLLABLE BODY
                    SliverPadding(
                      padding: const EdgeInsets.only(top: 16, bottom: 100),
                      sliver: SliverToBoxAdapter(
                        child: Obx(
                          () => AppShimmer(
                            enabled: controller.isLoading.value,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Weekly Calendar Timeline
                                      _buildWeeklyCalendar(),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Unified card-style tab switcher: Meal / Macros /
                                // Deficiency / Anthropometric / Disease / Life
                                // Stage / Fiber & Protein / Advice / Body Snapshot.
                                // Only the selected card's info is shown below it;
                                // "Meal" is the default.
                                _buildInfoCardSwitcher(context),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 1. SLIVER APP BAR
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: const Color(0xff06010F),
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Get.back(),
        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 0.8,
            ),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 14,
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          width: 40,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withOpacity(0.12),
              width: 0.8,
            ),
          ),
          child: const Icon(
            Icons.more_horiz_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.zoomBackground],
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(_getHeroImageUrl(), fit: BoxFit.cover),
            // Gradient Overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.2),
                    const Color(0xff06010F).withOpacity(0.6),
                    const Color(0xff06010F),
                  ],
                  stops: const [0.4, 0.8, 1.0],
                ),
              ),
            ),
          ],
        ),
        title: Text(
          "Nutrition Plan",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 18, bottom: 16),
      ),
    );
  }

  // 2. WEEKLY CALENDAR
  Widget _buildWeeklyCalendar() {
    return Obx(() {
      final rawNow = DateTime.now();
      final now = DateTime(rawNow.year, rawNow.month, rawNow.day);
      final DateTime anchor = now.add(
        Duration(days: 7 * controller.weekOffset.value),
      );
      final int anchorWeekday = anchor.weekday; // 1 = Monday, 7 = Sunday
      final List<DateTime> weekDates = List.generate(7, (index) {
        return anchor.subtract(Duration(days: anchorWeekday - 1 - index));
      });

      // Matches weekDates, which always starts on Monday.
      final List<String> weekdays = ["Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"];

      final bool isCurrentWeek = controller.weekOffset.value == 0;
      final bool hasCustomSelection =
          controller.selectedQueryDate.value.isNotEmpty;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isCurrentWeek ? "This Week" : _formatWeekRange(weekDates),
                style: GoogleFonts.outfit(
                  color: Colors.white.withOpacity(0.85),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  if (!isCurrentWeek || hasCustomSelection)
                    GestureDetector(
                      onTap: controller.jumpToToday,
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xffFF00E5).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: const Color(0xffFF00E5).withOpacity(0.25),
                            width: 0.8,
                          ),
                        ),
                        child: Text(
                          "Today",
                          style: GoogleFonts.inter(
                            color: const Color(0xffFF00E5),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  _weekNavButton(
                    Icons.chevron_left_rounded,
                    controller.goToPreviousWeek,
                  ),
                  const SizedBox(width: 6),
                  _weekNavButton(
                    Icons.chevron_right_rounded,
                    controller.goToNextWeek,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final DateTime date = weekDates[index];
              final String dayName = weekdays[index];
              final String dayNum = date.day.toString();
              final String dateStr =
                  "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

              return Obx(() {
                final isSelected =
                    controller.selectedQueryDate.value == dateStr ||
                    (controller.selectedQueryDate.value.isEmpty &&
                        date.day == now.day &&
                        date.month == now.month &&
                        date.year == now.year);

                final bool hasLoggedMeals = controller.calorieHistoryList.any(
                  (day) =>
                      day['date'] == dateStr &&
                      (day['meals_logged'] as List?)?.isNotEmpty == true,
                );

                // Detect if this calendar cell is a future date
                final bool isFuture = date.isAfter(
                  DateTime(now.year, now.month, now.day),
                );

                return GestureDetector(
                  onTap: isSelected
                      ? null
                      : () => controller.selectDate(dateStr),
                  child: SizedBox(
                    width: 40,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          dayName.toUpperCase(),
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(
                              isSelected
                                  ? 0.7
                                  : isFuture
                                  ? 0.2
                                  : 0.35,
                            ),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.4,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              height: 40,
                              width: 40,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isSelected
                                    ? const Color(0xffFF5A5F)
                                    : isFuture
                                    ? const Color(0xffB100FF).withOpacity(0.06)
                                    : Colors.transparent,
                                border: isSelected
                                    ? null
                                    : Border.all(
                                        color: isFuture
                                            ? const Color(
                                                0xffB100FF,
                                              ).withOpacity(0.18)
                                            : hasLoggedMeals
                                            ? const Color(
                                                0xff00FF87,
                                              ).withOpacity(0.6)
                                            : Colors.white.withOpacity(0.14),
                                        width: hasLoggedMeals && !isFuture
                                            ? 1.6
                                            : 1.0,
                                      ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: const Color(
                                            0xffFF5A5F,
                                          ).withOpacity(0.35),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Text(
                                dayNum,
                                style: GoogleFonts.outfit(
                                  color: isSelected
                                      ? Colors.white
                                      : isFuture
                                      ? Colors.white.withOpacity(0.3)
                                      : Colors.white.withOpacity(0.85),
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w600,
                                ),
                              ),
                            ),
                            // Small lock badge on future dates
                            if (isFuture && !isSelected)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0xffB100FF,
                                    ).withOpacity(0.8),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.lock_rounded,
                                    color: Colors.white,
                                    size: 8,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              });
            }),
          ),
        ],
      );
    });
  }

  Widget _weekNavButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28,
        width: 28,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.8),
        ),
        child: Icon(icon, color: Colors.white.withOpacity(0.6), size: 18),
      ),
    );
  }

  String _formatWeekRange(List<DateTime> weekDates) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    final start = weekDates.first;
    final end = weekDates.last;
    if (start.month == end.month) {
      return "${start.day} - ${end.day} ${months[start.month - 1]}";
    }
    return "${start.day} ${months[start.month - 1]} - ${end.day} ${months[end.month - 1]}";
  }

  // 4. DAILY MEALS — full-bleed section (matches the "Today's Meal Plan"
  // block on the home screen: same background + title style). The purple
  // fill eases in from the background at the top and eases back out at the
  /// Unified switcher: a row of card-style buttons (Meal / Macros /
  /// Deficiency / Anthropometric / Disease / Life Stage / Fiber & Protein /
  /// Advice / Body Snapshot). Only cards with real data for this user show
  /// up at all. "Meal" is first and selected by default — tapping any other
  /// card swaps the content below to just that section.
  Widget _buildInfoCardSwitcher(BuildContext context) {
    final tabs = _buildInsightTabs(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SizedBox(
            height: 56,
            child: Obx(() {
              final selectedIndex = controller.selectedInsightTab.value.clamp(
                0,
                tabs.length - 1,
              );
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (context, i) {
                  final selected = i == selectedIndex;
                  return GestureDetector(
                    onTap: () => controller.selectedInsightTab.value = i,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        gradient: selected
                            ? const LinearGradient(
                                colors: [Color(0xffB100FF), Color(0xffFF00E5)],
                              )
                            : null,
                        color: selected ? null : const Color(0xff17141F),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected
                              ? Colors.transparent
                              : Colors.white.withOpacity(0.12),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            tabs[i].icon,
                            size: 18,
                            color: selected ? Colors.white : Colors.white70,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            tabs[i].label,
                            style: GoogleFonts.outfit(
                              color: selected ? Colors.white : Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ),
        const SizedBox(height: 20),
        Obx(() {
          final selectedIndex = controller.selectedInsightTab.value.clamp(
            0,
            tabs.length - 1,
          );
          return tabs[selectedIndex].builder();
        }),
      ],
    );
  }

  /// The "Meal" card's content — the existing full-bleed daily meal timeline,
  /// unchanged, just now shown only when that card is selected.
  Widget _buildMealCardContent(BuildContext context) {
    return _buildDailyMealsSection(context);
  }

  /// Any non-meal card's content — wrapped in a bordered info card so it
  /// reads as a distinct panel, matching the section's data.
  Widget _buildInfoCardContent(Widget child) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff151520),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xffFF00E5).withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffFF00E5).withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  /// Builds the dynamic list of insight tabs — only sections with real data
  /// for this specific user appear; nothing is shown as filler.
  List<_InsightTab> _buildInsightTabs(BuildContext context) {
    // Locked days (future or before the plan's activation) have no real
    // insight data to show — keep only the "Meal" tab, which already
    // renders the lock screen, instead of leaving Macros/Advice/etc. open.
    if (controller.isLockedDate) {
      return [
        _InsightTab(
          label: "Meal",
          icon: Icons.restaurant_menu_rounded,
          builder: () => _buildMealCardContent(context),
        ),
      ];
    }

    final tabs = <_InsightTab>[
      // Always first and selected by default.
      _InsightTab(
        label: "Meal",
        icon: Icons.restaurant_menu_rounded,
        builder: () => _buildMealCardContent(context),
      ),
      _InsightTab(
        label: "Macros",
        icon: Icons.pie_chart_rounded,
        builder: () => _buildInfoCardContent(_buildMacrosTab()),
      ),
    ];

    if (controller.priorityNutrients != null) {
      tabs.add(
        _InsightTab(
          label: "Deficiency",
          icon: Icons.spa_outlined,
          builder: () => _buildInfoCardContent(_buildPriorityNutrientsTab()),
        ),
      );
    }

    if (controller.anthropometrics != null) {
      tabs.add(
        _InsightTab(
          label: "Anthropometric",
          icon: Icons.straighten_rounded,
          builder: () => _buildInfoCardContent(_buildAnthropometricTab()),
        ),
      );
    }

    if (controller.diseaseGuidance.isNotEmpty) {
      tabs.add(
        _InsightTab(
          label: "Disease Guidance",
          icon: Icons.health_and_safety_outlined,
          builder: () => _buildInfoCardContent(_buildDiseaseGuidanceTab()),
        ),
      );
    }

    if (controller.lifeStageGuidance != null) {
      tabs.add(
        _InsightTab(
          label: "Life Stage",
          icon: Icons.accessibility_new_rounded,
          builder: () => _buildInfoCardContent(_buildLifeStageTab()),
        ),
      );
    }

    if (controller.suggestedFiberFoods.isNotEmpty ||
        controller.suggestedProteinPowder != null) {
      tabs.add(
        _InsightTab(
          label: "Fiber & Protein",
          icon: Icons.eco_outlined,
          builder: () => _buildInfoCardContent(_buildFiberProteinTab()),
        ),
      );
    }

    if (controller.adviceList.isNotEmpty) {
      tabs.add(
        _InsightTab(
          label: "Advice",
          icon: Icons.lightbulb_outline_rounded,
          builder: () => _buildInfoCardContent(_buildAdviceTab()),
        ),
      );
    }

    tabs.add(
      _InsightTab(
        label: "Body Snapshot",
        icon: Icons.monitor_heart_outlined,
        builder: () => _buildInfoCardContent(_buildBodySnapshotTab()),
      ),
    );

    return tabs;
  }

  // ---- Shared small building blocks for insight tab content ----

  Widget _insightSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          color: Colors.white70,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _insightBodyText(String text) {
    return Text(
      text,
      style: GoogleFonts.outfit(color: Colors.white, fontSize: 14, height: 1.4),
    );
  }

  Widget _insightBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items
          .map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xffFF00E5),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(child: _insightBodyText(item)),
                ],
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _insightChips(
    List<String> items, {
    Color color = const Color(0xff00FF87),
  }) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (item) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: color.withOpacity(0.3)),
              ),
              child: Text(
                item,
                style: GoogleFonts.outfit(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _insightInfoCard({
    required String title,
    List<Widget> children = const [],
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }

  // ---- Macros tab ----
  Widget _buildMacrosTab() {
    final achieved = controller.macroAchieved;

    Widget statTile(
      String label,
      int target,
      num? achievedVal,
      Color color, {
      String unit = 'g',
    }) {
      final achievedInt = achievedVal?.round() ?? target;
      final delta = achievedInt - target;
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Column(
            children: [
              Text(
                "$achievedInt$unit",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "of $target$unit",
                style: GoogleFonts.outfit(color: Colors.white38, fontSize: 9),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              if (delta != 0)
                Text(
                  "${delta > 0 ? '+' : ''}$delta $unit",
                  style: GoogleFonts.outfit(color: Colors.white38, fontSize: 9),
                ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            statTile(
              "Calories",
              controller.targetCalories.value,
              achieved?['kcal'],
              const Color(0xff00FF87),
              unit: 'kcal',
            ),
            statTile(
              "Carbs",
              controller.targetCarbs.value,
              achieved?['carb_g'],
              const Color(0xffFF7A00),
            ),
            statTile(
              "Protein",
              controller.targetProtein.value,
              achieved?['protein_g'],
              const Color(0xff00A2FF),
            ),
            statTile(
              "Fat",
              controller.targetFat.value,
              achieved?['fat_g'],
              const Color(0xffFF00E5),
            ),
          ],
        ),
        if (controller.accuracyNote.isNotEmpty) ...[
          const SizedBox(height: 14),
          _insightSectionLabel("Plan Accuracy"),
          _insightBodyText(controller.accuracyNote),
        ],
      ],
    );
  }

  // ---- Advice tab ----
  Widget _buildAdviceTab() {
    return _insightBulletList(controller.adviceList);
  }

  // ---- Body Snapshot tab (from ProgressController — already fetched app-wide) ----
  Widget _buildBodySnapshotTab() {
    if (!Get.isRegistered<ProgressController>()) {
      return _insightBodyText("Body metrics aren't available yet.");
    }
    final progress = Get.find<ProgressController>();

    Widget metric(String label, String value, Color color) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.08),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withOpacity(0.25)),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Obx(
      () => Column(
        children: [
          Row(
            children: [
              metric(
                "BMI",
                progress.bmi.value.toStringAsFixed(1),
                const Color(0xffFF00E5),
              ),
              metric(
                "BMR",
                "${progress.bmr.value} kcal",
                const Color(0xffFF7A00),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              metric(
                "TDEE",
                "${progress.tdee.value} kcal",
                const Color(0xff00A2FF),
              ),
              metric(
                "Ideal Weight",
                "${progress.ibw.value.toStringAsFixed(1)} kg",
                const Color(0xff00FF87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---- Anthropometric Result tab ----
  Widget _buildAnthropometricTab() {
    final data = controller.anthropometrics;
    if (data == null) {
      return _insightBodyText("No anthropometric data available.");
    }

    final waistCm = (data['waist_cm'] as num?)?.toDouble() ?? 0;
    final hipCm = (data['hip_cm'] as num?)?.toDouble() ?? 0;
    final whr = (data['whr'] as num?)?.toDouble() ?? 0;
    final whtr = (data['whtr'] as num?)?.toDouble() ?? 0;
    final waistCutoff = (data['waist_cutoff'] as num?)?.toDouble() ?? 0;
    final whrCutoff = (data['whr_cutoff'] as num?)?.toDouble() ?? 0;
    final whtrStatus = data['whtr_status']?.toString() ?? 'Healthy';
    final alerts =
        (data['alerts'] as List?)?.map((e) => e.toString()).toList() ?? [];

    final waistAtRisk = alerts.any((a) => a.contains('Visceral'));
    final whrAtRisk = alerts.any((a) => a.contains('Central Obesity'));
    final whtrHealthy = whtrStatus == 'Healthy';

    TextStyle headerStyle = GoogleFonts.outfit(
      color: Colors.white54,
      fontSize: 11,
      fontWeight: FontWeight.w600,
    );

    Widget row(
      String label,
      String value,
      String cutoff,
      String status,
      bool atRisk,
    ) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                label,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                value,
                style: GoogleFonts.outfit(color: Colors.white70, fontSize: 13),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                cutoff,
                style: GoogleFonts.outfit(color: Colors.white38, fontSize: 12),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                status,
                style: GoogleFonts.outfit(
                  color: atRisk
                      ? const Color(0xffFF3E3E)
                      : const Color(0xff00FF87),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(flex: 3, child: Text("MEASUREMENT", style: headerStyle)),
            Expanded(flex: 2, child: Text("VALUE", style: headerStyle)),
            Expanded(flex: 2, child: Text("CUT-OFF", style: headerStyle)),
            Expanded(flex: 3, child: Text("STATUS", style: headerStyle)),
          ],
        ),
        Divider(color: Colors.white.withOpacity(0.1), height: 1),
        row(
          "Waist Circumference",
          "${waistCm.toStringAsFixed(0)} cm",
          "< ${waistCutoff.toStringAsFixed(0)} cm",
          waistAtRisk ? "Visceral Fat Built Up" : "Healthy Range",
          waistAtRisk,
        ),
        Divider(color: Colors.white.withOpacity(0.06), height: 1),
        row(
          "Hip Circumference",
          "${hipCm.toStringAsFixed(0)} cm",
          "N/A",
          "Healthy Range",
          false,
        ),
        Divider(color: Colors.white.withOpacity(0.06), height: 1),
        row(
          "Waist-to-Hip (WHR)",
          whr.toStringAsFixed(2),
          "< ${whrCutoff.toStringAsFixed(2)}",
          whrAtRisk ? "Central Obesity Diagnosed" : "Healthy Range",
          whrAtRisk,
        ),
        Divider(color: Colors.white.withOpacity(0.06), height: 1),
        row(
          "Waist-to-Height (WHtR)",
          whtr.toStringAsFixed(2),
          "< 0.50",
          whtrHealthy ? "Healthy Range" : "Cardio Metabolic Risk ($whtrStatus)",
          !whtrHealthy,
        ),
        if (alerts.isNotEmpty) ...[
          const SizedBox(height: 16),
          _insightSectionLabel("Indicated Cardio-Metabolic & Visceral Risks"),
          _insightChips(alerts, color: const Color(0xffFF3E3E)),
        ],
      ],
    );
  }

  // ---- Priority Nutrients tab ----
  Widget _buildPriorityNutrientsTab() {
    final data = controller.priorityNutrients;
    if (data == null)
      return _insightBodyText("No flagged nutrients right now.");

    final deficiencyDetails =
        (data['deficiency_details'] as List?)
            ?.whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList() ??
        [];
    final topFoodsByNutrient = data['top_foods_by_nutrient'] is Map
        ? Map<String, dynamic>.from(data['top_foods_by_nutrient'])
        : <String, dynamic>{};

    if (deficiencyDetails.isEmpty) {
      return _insightBodyText("No flagged nutrients right now.");
    }

    final targetingNames = deficiencyDetails
        .map((n) => n['micronutrient']?.toString() ?? '')
        .where((s) => s.isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (targetingNames.isNotEmpty) ...[
          Text(
            "Targeting: ${targetingNames.join(', ')}",
            style: GoogleFonts.outfit(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 14),
        ],
        ...deficiencyDetails.map((nutrient) {
          final name = nutrient['micronutrient']?.toString() ?? 'Nutrient';
          final topFoods =
              (topFoodsByNutrient[name] as List?)
                  ?.whereType<Map>()
                  .map((f) => f['food_item']?.toString() ?? '')
                  .where((s) => s.isNotEmpty)
                  .toList() ??
              [];

          return _insightInfoCard(
            title: name,
            children: [
              if (nutrient['deficiency_condition'] != null) ...[
                _insightBodyText(nutrient['deficiency_condition'].toString()),
                const SizedBox(height: 8),
              ],
              if (nutrient['best_indian_food_sources'] != null) ...[
                _insightSectionLabel("Best Food Sources"),
                _insightBodyText(
                  nutrient['best_indian_food_sources'].toString(),
                ),
                const SizedBox(height: 8),
              ],
              if (nutrient['absorption_tips'] != null) ...[
                _insightSectionLabel("Absorption Tips"),
                _insightBodyText(nutrient['absorption_tips'].toString()),
                const SizedBox(height: 8),
              ],
              if (topFoods.isNotEmpty) ...[
                _insightSectionLabel("Top Foods In This Plan"),
                _insightChips(topFoods),
              ],
            ],
          );
        }),
      ],
    );
  }

  // ---- Disease Guidance tab ----
  Widget _buildDiseaseGuidanceTab() {
    final guides = controller.diseaseGuidance;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: guides.map((guide) {
        final name = guide['disease_name']?.toString() ?? 'Condition';
        final keyMicronutrients =
            (guide['keyMicronutrients'] as List?)
                ?.map((e) => e.toString())
                .toList() ??
            [];

        return _insightInfoCard(
          title: name,
          children: [
            if (guide['macronutrient_considerations'] != null) ...[
              _insightSectionLabel("Macronutrient Considerations"),
              _insightBodyText(
                guide['macronutrient_considerations'].toString(),
              ),
              const SizedBox(height: 8),
            ],
            if (guide['clinical_notes'] != null) ...[
              _insightSectionLabel("Clinical Notes"),
              _insightBodyText(guide['clinical_notes'].toString()),
              const SizedBox(height: 8),
            ],
            if (guide['food_first_sources'] != null) ...[
              _insightSectionLabel("Food-First Sources"),
              _insightBodyText(guide['food_first_sources'].toString()),
              const SizedBox(height: 8),
            ],
            if (guide['suggested_supplement'] != null) ...[
              _insightSectionLabel("Suggested Supplement"),
              _insightBodyText(guide['suggested_supplement'].toString()),
              const SizedBox(height: 8),
            ],
            if (keyMicronutrients.isNotEmpty) ...[
              _insightSectionLabel("Key Micronutrients To Watch"),
              _insightChips(keyMicronutrients, color: const Color(0xffFF7A00)),
            ],
          ],
        );
      }).toList(),
    );
  }

  // ---- Life Stage tab ----
  Widget _buildLifeStageTab() {
    final guide = controller.lifeStageGuidance;
    if (guide == null) return const SizedBox.shrink();

    final keyMicronutrients =
        (guide['keyMicronutrients'] as List?)
            ?.map((e) => e.toString())
            .toList() ??
        [];

    return _insightInfoCard(
      title: guide['life_stage_name']?.toString() ?? 'Life Stage',
      children: [
        if (guide['macronutrient_focus'] != null) ...[
          _insightSectionLabel("Macronutrient Focus"),
          _insightBodyText(guide['macronutrient_focus'].toString()),
          const SizedBox(height: 8),
        ],
        if (guide['notes_cautions'] != null) ...[
          _insightSectionLabel("Notes & Cautions"),
          _insightBodyText(guide['notes_cautions'].toString()),
          const SizedBox(height: 8),
        ],
        if (guide['food_first_sources'] != null) ...[
          _insightSectionLabel("Food-First Sources"),
          _insightBodyText(guide['food_first_sources'].toString()),
          const SizedBox(height: 8),
        ],
        if (guide['suggested_supplement'] != null) ...[
          _insightSectionLabel("Suggested Supplement"),
          _insightBodyText(guide['suggested_supplement'].toString()),
          const SizedBox(height: 8),
        ],
        if (keyMicronutrients.isNotEmpty) ...[
          _insightSectionLabel("Key Micronutrients"),
          _insightChips(keyMicronutrients, color: const Color(0xff00A2FF)),
        ],
      ],
    );
  }

  // ---- Fiber & Protein tab ----
  Widget _buildFiberProteinTab() {
    final fiberFoods = controller.suggestedFiberFoods;
    final proteinPowder = controller.suggestedProteinPowder;

    TextStyle headerStyle = GoogleFonts.outfit(
      color: Colors.white54,
      fontSize: 11,
      fontWeight: FontWeight.w600,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fiberFoods.isNotEmpty) ...[
          _insightSectionLabel("High-Fiber Foods & Supplements"),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 3, child: Text("ITEM", style: headerStyle)),
              Expanded(
                flex: 4,
                child: Text("DOSAGE & DURATION", style: headerStyle),
              ),
              Expanded(flex: 3, child: Text("CAUTIONS", style: headerStyle)),
            ],
          ),
          Divider(color: Colors.white.withOpacity(0.1), height: 1),
          ...fiberFoods.map((food) {
            final name =
                food['food_or_supplement']?.toString() ?? 'Fiber source';
            final fiberContent = food['fiber_content']?.toString();
            final dosage = food['recommended_dosage']?.toString() ?? '-';
            final cautions = food['cautions']?.toString() ?? '-';

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          fiberContent != null ? "$name ($fiberContent)" : name,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Text(
                          dosage,
                          style: GoogleFonts.outfit(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          cautions,
                          style: GoogleFonts.outfit(
                            color: const Color(0xffFF7A00),
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.white.withOpacity(0.06), height: 1),
              ],
            );
          }),
        ],
        if (proteinPowder != null) ...[
          if (fiberFoods.isNotEmpty) const SizedBox(height: 6),
          _insightSectionLabel("Suggested Protein Powder"),
          const SizedBox(height: 6),
          _insightInfoCard(
            title: proteinPowder['powder_type']?.toString() ?? 'Protein Powder',
            children: [
              if (proteinPowder['source'] != null) ...[
                _insightSectionLabel("Source"),
                _insightBodyText(proteinPowder['source'].toString()),
                const SizedBox(height: 8),
              ],
              if (proteinPowder['protein_per_scoop'] != null) ...[
                _insightSectionLabel("Protein Per Scoop"),
                _insightBodyText(proteinPowder['protein_per_scoop'].toString()),
                const SizedBox(height: 8),
              ],
              if (proteinPowder['key_cautions'] != null) ...[
                _insightSectionLabel("Cautions"),
                _insightBodyText(proteinPowder['key_cautions'].toString()),
              ],
            ],
          ),
        ],
      ],
    );
  }

  // bottom, instead of cutting hard into the section — flat solid purple
  // through the middle, no lighter glow. Title, promo card and meal
  // timeline all sit on it. The meal cards inside are otherwise unchanged.
  Widget _buildDailyMealsSection(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 30, bottom: 26),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xff06010F), // match background
            Color(0xff3B0E6B), // rich deep purple
            Color(0xff3B0E6B), // rich deep purple
            Color(0xff06010F), // match background
          ],
          stops: [0.0, 0.08, 0.92, 1.0],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Daily Meals",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 16),

            // Promo customization Card
            _buildPromoCard(),
            const SizedBox(height: 20),

            // Consolidated Meal Timeline List
            _buildMealsTimeline(context),
          ],
        ),
      ),
    );
  }

  // 5. PROMO CARD
  Widget _buildPromoCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xff2A1649),
            const Color(0xff120D23).withOpacity(0.8),
          ],
        ),
        border: Border.all(
          color: const Color(0xffB100FF).withOpacity(0.12),
          width: 1,
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Customize Grocery List &\nexplore clinical recipes ➔",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 12,
            bottom: 8,
            top: 8,
            child: Row(
              children: [
                const Text("🥦", style: TextStyle(fontSize: 34)),
                const SizedBox(width: 4),
                Transform.rotate(
                  angle: 0.2,
                  child: const Text("🍎", style: TextStyle(fontSize: 34)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 6. CONSOLIDATED MEAL TIMELINE
  Widget _buildMealsTimeline(BuildContext context) {
    return Obx(() {
      // ── FUTURE OR PRE-ACTIVATION DATE: Show lock screen ─────────────────────
      if (controller.isLockedDate) {
        final bool beforeActivation = controller.isBeforeActivation;
        final int days = controller.daysUntilSelected;
        final String unlockMsg = beforeActivation
            ? "Not Available"
            : (days == 1 ? "Unlocks Tomorrow" : "Unlocks in $days days");
        final String bodyMsg = beforeActivation
            ? "Your meal plan hadn't started yet on\nthis day. Check out today's meals\ninstead! 💪"
            : "Your meal plan for this day hasn't been\nrevealed yet. Focus on today's meals\nand come back when it unlocks! 💪";
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xff0B0817).withOpacity(0.8),
                const Color(0xff1A0533).withOpacity(0.85),
              ],
            ),
            border: Border.all(
              color: const Color(0xffB100FF).withOpacity(0.15),
              width: 1.2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Animated glow lock icon
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color(0xffB100FF).withOpacity(0.25),
                      const Color(0xffB100FF).withOpacity(0.0),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xffB100FF).withOpacity(0.3),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.lock_rounded,
                  color: Color(0xffB100FF),
                  size: 30,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                unlockMsg,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                bodyMsg,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.45),
                  fontSize: 13,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 28),
              // Day countdown chip — only meaningful for future dates.
              if (!beforeActivation)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffB100FF).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: const Color(0xffB100FF).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        days == 1 ? "🗓  1 day to go" : "🗓  $days days to go",
                        style: GoogleFonts.inter(
                          color: const Color(0xffB100FF),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      }

      // ── NO PLAN FOUND ──────────────────────────────────────────────────────
      if (controller.mealTimeline.isEmpty) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xff0B0817).withOpacity(0.55),
            border: Border.all(color: Colors.white.withOpacity(0.04)),
          ),
          child: Center(
            child: Text(
              "No active meal plans found.",
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
          ),
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: controller.mealTimeline.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final meal = controller.mealTimeline[index];
          final int mealTypeId = meal['meal_id'] ?? 0;
          final int dietPlanMealId = meal['id'] ?? 0;
          final Map<int, List<dynamic>> optionFoods =
              Map<int, List<dynamic>>.from(meal['optionFoods'] ?? {});
          final String mealTitle = meal['title'] ?? 'Meal Slot';

          return Obx(() {
            final int selectedOpt =
                controller.selectedOptions[dietPlanMealId] ?? 1;
            final bool isCompleted = controller.completedMealIds.contains(
              mealTypeId,
            );
            final bool isExpanded = controller.expandedMealIds.contains(
              dietPlanMealId,
            );
            final List foodsOfSelectedOption = optionFoods[selectedOpt] ?? [];

            // Calculate option macros
            double totalProtein = 0.0;
            double totalCarbs = 0.0;
            double totalFat = 0.0;
            double activeKcal = 0.0;

            for (var f in foodsOfSelectedOption) {
              if (f == null) continue;
              totalProtein +=
                  double.tryParse(f['protein']?.toString() ?? '0') ?? 0;
              totalCarbs += double.tryParse(f['carbs']?.toString() ?? '0') ?? 0;
              totalFat += double.tryParse(f['fat']?.toString() ?? '0') ?? 0;
              activeKcal +=
                  double.tryParse(f['calories']?.toString() ?? '0') ?? 0;
            }

            final double targetKcal = activeKcal > 0
                ? activeKcal
                : (double.tryParse(meal['target_calories']?.toString() ?? '') ??
                      300.0);

            // Get option name from first food Notes metadata
            String optionName = "Option $selectedOpt";
            if (foodsOfSelectedOption.isNotEmpty) {
              final firstFood = foodsOfSelectedOption.first;
              final String? notes = firstFood['notes']?.toString();
              if (notes != null && notes.isNotEmpty) {
                try {
                  final Map<String, dynamic> meta = jsonDecode(notes);
                  if (meta['option_name'] != null &&
                      meta['option_name'].toString().isNotEmpty) {
                    optionName = meta['option_name'];
                  }
                } catch (_) {}
              }
            }

            final String foodDesc = foodsOfSelectedOption.isNotEmpty
                ? foodsOfSelectedOption
                      .map((f) => f['food_details']?['food_name'] ?? '')
                      .join(', ')
                : 'Tap to configure foods';

            String emoji = "🥗";
            final titleString = mealTitle.toLowerCase();
            if (titleString.contains('breakfast')) {
              emoji = "🥣";
            } else if (titleString.contains('lunch')) {
              emoji = "🍱";
            } else if (titleString.contains('dinner')) {
              emoji = "🍲";
            } else if (titleString.contains('snack') ||
                titleString.contains('mid meal')) {
              emoji = "🍇";
            } else if (titleString.contains('workout')) {
              emoji = "🥤";
            }

            final String mealImageUrl = _getMealImageUrl(mealTitle);

            return AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              alignment: Alignment.topCenter,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: const Color(0xff0B0817).withOpacity(0.55),
                  border: Border.all(
                    color: isCompleted
                        ? const Color(0xff00FF87).withOpacity(0.15)
                        : Colors.white.withOpacity(0.04),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER ROW (ALWAYS VISIBLE) ---
                    GestureDetector(
                      onTap: () {
                        if (isExpanded) {
                          controller.expandedMealIds.remove(dietPlanMealId);
                        } else {
                          controller.expandedMealIds.add(dietPlanMealId);
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        color: Colors.transparent,
                        child: Row(
                          children: [
                            // Status checkmark indicator
                            GestureDetector(
                              onTap: () {
                                if (isCompleted) {
                                  controller.unmarkMealAsCompleted(
                                    dietPlanMealId,
                                    mealTypeId,
                                  );
                                } else {
                                  controller.markMealAsCompleted(
                                    dietPlanMealId,
                                    mealTypeId,
                                    selectedOption: selectedOpt,
                                  );
                                }
                              },
                              child: Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: isCompleted
                                      ? const Color(0xff00FF87)
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: isCompleted
                                        ? Colors.transparent
                                        : Colors.white.withOpacity(0.2),
                                    width: 1.5,
                                  ),
                                ),
                                child: isCompleted
                                    ? const Icon(
                                        Icons.check,
                                        color: Colors.black,
                                        size: 14,
                                      )
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Text Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    mealTitle,
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (isExpanded) ...[
                                    const SizedBox(height: 4),
                                    Text(
                                      "${targetKcal.toInt()} kcal • P ${totalProtein.toInt()}g C ${totalCarbs.toInt()}g F ${totalFat.toInt()}g",
                                      style: GoogleFonts.inter(
                                        color: const Color(0xff00FF87),
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),

                            // Expand Icon Indicator
                            Icon(
                              isExpanded
                                  ? Icons.keyboard_arrow_up_rounded
                                  : Icons.keyboard_arrow_down_rounded,
                              color: Colors.white.withOpacity(0.4),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // --- EXPANDED DETAILS BODY ---
                    if (isExpanded) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Divider(
                          color: Colors.white.withOpacity(0.08),
                          height: 1,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Image Header inside card
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: 110,
                                    width: double.infinity,
                                    child: Image.network(
                                      mealImageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        color: const Color(0xff120D23),
                                        child: Center(
                                          child: Text(
                                            emoji,
                                            style: const TextStyle(
                                              fontSize: 32,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 110,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.1),
                                          Colors.black.withOpacity(0.6),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 14,
                                    bottom: 12,
                                    child: Row(
                                      children: [
                                        Text(
                                          emoji,
                                          style: const TextStyle(fontSize: 18),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Exchange Options",
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // 2. Macronutrient distributes chips
                            _buildMacroSummaryChips(
                              totalProtein,
                              totalCarbs,
                              totalFat,
                            ),
                            const SizedBox(height: 18),

                            // 3. Detailed Included items and swaps
                            Text(
                              "Included Items & Swaps",
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            _buildFoodItemsSection(
                              foodsOfSelectedOption,
                              optionFoods,
                            ),
                            const SizedBox(height: 20),

                            // 4. Action Log Button
                            _buildLogButton(
                              dietPlanMealId,
                              mealTypeId,
                              isCompleted,
                              selectedOpt,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          });
        },
      );
    });
  }

  // Macro Summary Chips Row
  Widget _buildMacroSummaryChips(double protein, double carbs, double fat) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildMiniMacroChip(
            "Protein",
            "${protein.toInt()}g",
            const Color(0xffFFD166),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildMiniMacroChip(
            "Carbs",
            "${carbs.toInt()}g",
            const Color(0xff00FF87),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: _buildMiniMacroChip(
            "Fat",
            "${fat.toInt()}g",
            const Color(0xffFF00E5),
          ),
        ),
      ],
    );
  }

  Widget _buildMiniMacroChip(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.04), width: 0.8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 6,
            width: 6,
            decoration: BoxDecoration(shape: BoxShape.circle, color: color),
          ),
          const SizedBox(width: 6),
          Text(
            "$label: $value",
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.65),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // Foods and Swaps List
  Widget _buildFoodItemsSection(
    List foods,
    Map<int, List<dynamic>> optionFoods,
  ) {
    if (foods.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        alignment: Alignment.center,
        child: Text(
          "No details available.",
          style: GoogleFonts.inter(color: Colors.white30, fontSize: 11),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: foods.length,
      separatorBuilder: (context, index) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Divider(color: Colors.white.withOpacity(0.06), height: 1.0),
      ),
      itemBuilder: (context, index) {
        final f = foods[index];
        final foodDetails = f['food_details'] as Map<String, dynamic>? ?? {};
        final String foodName =
            foodDetails['food_name']?.toString() ??
            f['food_name']?.toString() ??
            'Food Item';
        final double kcal =
            double.tryParse(f['calories']?.toString() ?? '0') ?? 0.0;
        // Portion: prefer household_measure from food_details, then exchange_amount, then quantity+unit
        final String qtyStr = f['quantity']?.toString() ?? '';
        final String unitStr =
            foodDetails['serving_unit']?.toString() ??
            foodDetails['unit']?.toString() ??
            '';

        final String portion =
            unitStr.toLowerCase() == "exchange" ||
                unitStr.toLowerCase() == "exchanges"
            ? (qtyStr.isNotEmpty ? '$qtyStr Exchange' : '')
            : (qtyStr.isNotEmpty ? '$qtyStr $unitStr'.trim() : '');

        // Construct swaps from Option 2 and Option 3 at the same index
        final List<String> swaps = [];
        final List option2Foods = optionFoods[2] ?? [];
        final List option3Foods = optionFoods[3] ?? [];

        if (index < option2Foods.length) {
          final f2 = option2Foods[index];
          final String name2 = f2['food_details']?['food_name'] ?? '';
          final String sSize2 =
              f2['serving_size']?.toString() ??
              f2['quantity']?.toString() ??
              '';
          final String sUnit2 =
              f2['serving_unit']?.toString() ??
              f2['unit']?.toString() ??
              f2['food_details']?['serving_unit']?.toString() ??
              '';
          final String portion2 = "$sSize2 $sUnit2".trim();
          if (name2.isNotEmpty) {
            swaps.add("$name2 ($portion2)");
          }
        }

        if (index < option3Foods.length) {
          final f3 = option3Foods[index];
          final String name3 = f3['food_details']?['food_name'] ?? '';
          final String sSize3 =
              f3['serving_size']?.toString() ??
              f3['quantity']?.toString() ??
              '';
          final String sUnit3 =
              f3['serving_unit']?.toString() ??
              f3['unit']?.toString() ??
              f3['food_details']?['serving_unit']?.toString() ??
              '';
          final String portion3 = "$sSize3 $sUnit3".trim();
          if (name3.isNotEmpty) {
            swaps.add("$name3 ($portion3)");
          }
        }

        String swapText = "";
        if (swaps.isNotEmpty) {
          swapText = "Swap: " + swaps.join(" OR ");
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        foodName,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        portion,
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "${kcal.toInt()} kcal",
                  style: GoogleFonts.inter(
                    color: const Color(0xff00FF87),
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            if (swapText.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                swapText,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.35),
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  // Inline action Log Button
  Widget _buildLogButton(
    int dietPlanMealId,
    int mealTypeId,
    bool isCompleted,
    int activeOpt,
  ) {
    return GestureDetector(
      onTap: () async {
        if (isCompleted) {
          await controller.unmarkMealAsCompleted(dietPlanMealId, mealTypeId);
        } else {
          final success = await controller.markMealAsCompleted(
            dietPlanMealId,
            mealTypeId,
            selectedOption: activeOpt,
          );
          if (success) {
            Get.snackbar(
              "Meal Logged 🥗",
              "Awesome job! +10 FitCoins added to your wallet.",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: const Color(0xff0B0817).withOpacity(0.9),
              colorText: Colors.white,
              borderColor: const Color(0xff00FF87).withOpacity(0.2),
              borderWidth: 1,
            );
          }
        }
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: isCompleted
              ? null
              : const LinearGradient(
                  colors: [Color(0xff00FF87), Color(0xffFFD166)],
                ),
          color: isCompleted ? Colors.white.withOpacity(0.06) : null,
          border: isCompleted
              ? Border.all(color: Colors.white.withOpacity(0.12), width: 1.0)
              : null,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.check_circle_outline_rounded,
              color: isCompleted ? const Color(0xff00FF87) : Colors.black,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              isCompleted ? "Marked as Eaten" : "Log this Meal",
              style: GoogleFonts.outfit(
                color: isCompleted ? Colors.white : Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
