import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/meal_controller.dart';
import '../../progress/controllers/progress_controller.dart';
import '../../main_navigation/controllers/main_navigation_controller.dart';
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
        onTap: () {
          // MealView is a tab page inside MainNavigationView's IndexedStack,
          // not a pushed route — there's nothing for Get.back() to pop, so
          // switch back to the Home tab instead.
          if (Get.isRegistered<MainNavigationController>()) {
            Get.find<MainNavigationController>().changeTab(0);
          } else if (Get.key.currentState?.canPop() ?? false) {
            Get.back();
          }
        },
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
        // left inset clears the leading back button once the bar is
        // collapsed/pinned — a smaller value here lets the title render
        // underneath the back button while scrolling.
        titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
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
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xff151520),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
      ),
      child: child,
    );
  }

  Widget _insightSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Container(
            width: 3,
            height: 14,
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: Colors.white70,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            text.toUpperCase(),
            style: GoogleFonts.outfit(
              color: Colors.white70,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _insightBodyText(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        color: Colors.white.withOpacity(0.80),
        fontSize: 13,
        height: 1.55,
      ),
    );
  }

  Widget _insightBulletList(List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items.map((item) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 1),
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
                child: const Icon(
                  Icons.lightbulb_outline_rounded,
                  color: Colors.white70,
                  size: 14,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  item,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.85),
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _insightChips(List<String> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: items
          .map(
            (item) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.15),
                  width: 1,
                ),
              ),
              child: Text(
                item,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
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
    IconData? icon,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.02),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.04),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                    ),
                    child: Icon(icon, color: Colors.white70, size: 16),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(height: 1, color: Colors.white.withOpacity(0.1)),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: children,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMacrosTab() {
    final achieved = controller.macroAchieved;

    Widget statTile(
      String label,
      int target,
      num? achievedVal, {
      String unit = 'g',
    }) {
      final achievedInt = achievedVal?.round() ?? target;
      final delta = achievedInt - target;
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          margin: const EdgeInsets.symmetric(horizontal: 3),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.04),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: Column(
            children: [
              Text(
                "$achievedInt\n$unit",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "of $target",
                style: GoogleFonts.outfit(color: Colors.white38, fontSize: 10),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.outfit(
                  color: Colors.white70,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            statTile(
              "Calories",
              controller.targetCalories.value,
              achieved?['kcal'],
              unit: 'kcal',
            ),
            statTile(
              "Carbs",
              controller.targetCarbs.value,
              achieved?['carb_g'],
            ),
            statTile(
              "Protein",
              controller.targetProtein.value,
              achieved?['protein_g'],
            ),
            statTile("Fat", controller.targetFat.value, achieved?['fat_g']),
          ],
        ),
        if (controller.accuracyNote.isNotEmpty) ...[
          const SizedBox(height: 14),
          _insightSectionLabel("Plan Accuracy"),
          const SizedBox(height: 4),
          _insightBodyText(controller.accuracyNote),
        ],
      ],
    );
  }

  Widget _buildAdviceTab() {
    return _insightBulletList(controller.adviceList);
  }

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

    Widget measurementCard(
      String label,
      String value,
      String cutoff,
      String status,
      bool atRisk,
      IconData icon,
    ) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.04),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
              child: Icon(icon, color: Colors.white70, size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    "Cutoff: $cutoff",
                    style: GoogleFonts.outfit(
                      color: Colors.white54,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  value,
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 10,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        measurementCard(
          "Waist Circumference",
          "${waistCm.toStringAsFixed(0)} cm",
          "< ${waistCutoff.toStringAsFixed(0)} cm",
          waistAtRisk ? "At Risk" : "Healthy",
          waistAtRisk,
          Icons.straighten_rounded,
        ),
        measurementCard(
          "Hip Circumference",
          "${hipCm.toStringAsFixed(0)} cm",
          "N/A",
          "Healthy",
          false,
          Icons.accessibility_new_rounded,
        ),
        measurementCard(
          "Waist-to-Hip (WHR)",
          whr.toStringAsFixed(2),
          "< ${whrCutoff.toStringAsFixed(2)}",
          whrAtRisk ? "Central Obesity" : "Healthy",
          whrAtRisk,
          Icons.monitor_weight_outlined,
        ),
        measurementCard(
          "Waist-to-Height (WHtR)",
          whtr.toStringAsFixed(2),
          "< 0.50",
          whtrHealthy ? "Healthy" : "Cardio Risk",
          !whtrHealthy,
          Icons.favorite_border_rounded,
        ),
        if (alerts.isNotEmpty) ...[
          const SizedBox(height: 8),
          _insightSectionLabel("Cardio-Metabolic Risks"),
          const SizedBox(height: 8),
          _insightChips(alerts),
        ],
      ],
    );
  }

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
          _insightSectionLabel("Nutrient Targets"),
          const SizedBox(height: 8),
          _insightChips(targetingNames),
          const SizedBox(height: 20),
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
            icon: Icons.spa_outlined,
            children: [
              if (nutrient['deficiency_condition'] != null) ...[
                _insightBodyText(nutrient['deficiency_condition'].toString()),
                const SizedBox(height: 12),
              ],
              if (nutrient['best_indian_food_sources'] != null) ...[
                _insightSectionLabel("Best Food Sources"),
                const SizedBox(height: 4),
                _insightBodyText(
                  nutrient['best_indian_food_sources'].toString(),
                ),
                const SizedBox(height: 12),
              ],
              if (nutrient['absorption_tips'] != null) ...[
                _insightSectionLabel("Absorption Tips"),
                const SizedBox(height: 4),
                _insightBodyText(nutrient['absorption_tips'].toString()),
                const SizedBox(height: 12),
              ],
              if (topFoods.isNotEmpty) ...[
                _insightSectionLabel("Top Foods In This Plan"),
                const SizedBox(height: 8),
                _insightChips(topFoods),
              ],
            ],
          );
        }),
      ],
    );
  }

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
          icon: Icons.health_and_safety_outlined,
          children: [
            if (guide['macronutrient_considerations'] != null) ...[
              _insightSectionLabel("Macronutrient Considerations"),
              const SizedBox(height: 4),
              _insightBodyText(
                guide['macronutrient_considerations'].toString(),
              ),
              const SizedBox(height: 12),
            ],
            if (guide['clinical_notes'] != null) ...[
              _insightSectionLabel("Clinical Notes"),
              const SizedBox(height: 4),
              _insightBodyText(guide['clinical_notes'].toString()),
              const SizedBox(height: 12),
            ],
            if (guide['food_first_sources'] != null) ...[
              _insightSectionLabel("Food-First Sources"),
              const SizedBox(height: 4),
              _insightBodyText(guide['food_first_sources'].toString()),
              const SizedBox(height: 12),
            ],
            if (guide['suggested_supplement'] != null) ...[
              _insightSectionLabel("Suggested Supplement"),
              const SizedBox(height: 4),
              _insightBodyText(guide['suggested_supplement'].toString()),
              const SizedBox(height: 12),
            ],
            if (keyMicronutrients.isNotEmpty) ...[
              _insightSectionLabel("Key Micronutrients"),
              const SizedBox(height: 8),
              _insightChips(keyMicronutrients),
            ],
          ],
        );
      }).toList(),
    );
  }

  Widget _buildFiberProteinTab() {
    final fiberFoods = controller.suggestedFiberFoods;
    final proteinPowder = controller.suggestedProteinPowder;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (fiberFoods.isNotEmpty) ...[
          _insightSectionLabel("High-Fiber Foods & Supplements"),
          const SizedBox(height: 12),
          ...fiberFoods.map((food) {
            final name =
                food['food_or_supplement']?.toString() ?? 'Fiber source';
            final fiberContent = food['fiber_content']?.toString();
            final dosage = food['recommended_dosage']?.toString() ?? '-';
            final cautions = food['cautions']?.toString() ?? '-';

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.1),
                        ),
                        child: const Icon(
                          Icons.eco_outlined,
                          color: Colors.white70,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          fiberContent != null ? "$name ($fiberContent)" : name,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _insightSectionLabel("Dosage"),
                            const SizedBox(height: 2),
                            Text(
                              dosage,
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _insightSectionLabel("Cautions"),
                            const SizedBox(height: 2),
                            Text(
                              cautions,
                              style: GoogleFonts.inter(
                                color: Colors.white70,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
        if (proteinPowder != null) ...[
          if (fiberFoods.isNotEmpty) const SizedBox(height: 8),
          _insightSectionLabel("Suggested Protein Powder"),
          const SizedBox(height: 12),
          _insightInfoCard(
            title: proteinPowder['powder_type']?.toString() ?? 'Protein Powder',
            icon: Icons.fitness_center_rounded,
            children: [
              if (proteinPowder['source'] != null) ...[
                _insightSectionLabel("Source"),
                const SizedBox(height: 4),
                _insightBodyText(proteinPowder['source'].toString()),
                const SizedBox(height: 10),
              ],
              if (proteinPowder['protein_per_scoop'] != null) ...[
                _insightSectionLabel("Protein Per Scoop"),
                const SizedBox(height: 4),
                _insightBodyText(proteinPowder['protein_per_scoop'].toString()),
                const SizedBox(height: 10),
              ],
              if (proteinPowder['key_cautions'] != null) ...[
                _insightSectionLabel("Cautions"),
                const SizedBox(height: 4),
                _insightBodyText(proteinPowder['key_cautions'].toString()),
              ],
            ],
          ),
        ],
      ],
    );
  }

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

    return tabs;
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                GestureDetector(
                  onTap: () => Get.toNamed('/calorie-history'),
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.12),
                        width: 0.8,
                      ),
                    ),
                    child: const Icon(
                      Icons.history_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
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

                            // 2. Calorie & macronutrient distributes chips
                            _buildMacroSummaryChips(
                              targetKcal,
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
  Widget _buildMacroSummaryChips(
    double kcal,
    double protein,
    double carbs,
    double fat,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: _buildMiniMacroChip(
            "Kcal",
            "${kcal.toInt()}",
            const Color(0xffFF7A00),
          ),
        ),
        const SizedBox(width: 6),
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
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
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
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              "$label: $value",
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.65),
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isCompleted
                  ? Icons.check_circle_rounded
                  : Icons.check_circle_outline_rounded,
              color: Colors.black,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              isCompleted ? "Marked as Eaten" : "Mark as Complete",
              style: GoogleFonts.outfit(
                color: Colors.black,
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
