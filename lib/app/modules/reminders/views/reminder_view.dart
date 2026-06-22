import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/reminder_controller.dart';

class ReminderView extends GetView<ReminderController> {
  const ReminderView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          /// BACKGROUND NEON GLOWS
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              height: 320,
              width: 320,
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
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              height: 350,
              width: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffFF00E5).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// MAIN LAYOUT
          SafeArea(
            child: Column(
              children: [
                /// HEADER
                buildHeader(),

                /// BODY
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        /// 1. INFO CARD
                        buildTipCard(),
                        const SizedBox(height: 20),

                        /// 2. CATEGORY FILTER TABS
                        buildFilterTabs(),
                        const SizedBox(height: 20),

                        /// 3. REMINDERS LIST
                        Obx(() {
                          final items = controller.filteredReminders;
                          if (items.isEmpty) {
                            return buildEmptyState();
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return buildReminderCard(context, item);
                            },
                          );
                        }),
                        const SizedBox(height: 100), // Spacing for floating CTA
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// FLOATING ACTION BUTTON - PREMIUM CUSTOM CTA
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: buildAddReminderCTA(context),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// HEADER WIDGET
  /// ----------------------------------------------------
  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          /// Back Button
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
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 14),

          /// Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Smart Reminders",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Keep your schedule aligned with goals",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 1. INFO/TIP CARD
  /// ----------------------------------------------------
  Widget buildTipCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: const Color(0xffB100FF).withOpacity(0.15),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xffB100FF).withOpacity(0.12),
            ),
            child: const Icon(Icons.alarm_on_rounded, color: Color(0xffB100FF), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Consistency Boost",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Users who set regular reminders show a 40% increase in workout and meal plan compliance.",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 9.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 2. FILTER TABS
  /// ----------------------------------------------------
  Widget buildFilterTabs() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.categories.length,
        itemBuilder: (context, index) {
          final cat = controller.categories[index];
          return Obx(() {
            final isActive = controller.activeFilter.value == cat;
            Color activeColor = const Color(0xffFF00E5);
            if (cat == "Meal") activeColor = const Color(0xffFF7A00);
            if (cat == "Water") activeColor = const Color(0xff00E5FF);
            if (cat == "Supplement") activeColor = const Color(0xffB100FF);
            if (cat == "Weight Check") activeColor = const Color(0xffFFD700);
            if (cat == "Progress Upload") activeColor = const Color(0xffFF00E5);

            return GestureDetector(
              onTap: () => controller.activeFilter.value = cat,
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isActive ? activeColor.withOpacity(0.08) : const Color(0xff0B0817).withOpacity(0.55),
                  border: Border.all(
                    color: isActive ? activeColor : Colors.white.withOpacity(0.04),
                    width: 1.0,
                  ),
                ),
                child: Center(
                  child: Text(
                    cat,
                    style: GoogleFonts.outfit(
                      color: isActive ? Colors.white : Colors.white.withOpacity(0.40),
                      fontSize: 11,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  /// ----------------------------------------------------
  /// 3. REMINDER CARD
  /// ----------------------------------------------------
  Widget buildReminderCard(BuildContext context, Map<String, dynamic> item) {
    final int id = item["id"] as int;
    final String name = item["name"] as String;
    final String type = item["type"] as String;
    final String time = item["time"] as String;
    final List<String> days = List<String>.from(item["days"]);
    final int snooze = item["snoozeDuration"] as int;
    final RxBool isEnabled = item["isEnabled"] as RxBool;

    Color accentColor = const Color(0xffFF00E5);
    IconData typeIcon = Icons.notifications_active_rounded;

    if (type == "Meal") {
      accentColor = const Color(0xffFF7A00);
      typeIcon = Icons.restaurant_rounded;
    } else if (type == "Water") {
      accentColor = const Color(0xff00E5FF);
      typeIcon = Icons.water_drop_rounded;
    } else if (type == "Supplement") {
      accentColor = const Color(0xffB100FF);
      typeIcon = Icons.medication_rounded;
    } else if (type == "Weight Check") {
      accentColor = const Color(0xffFFD700);
      typeIcon = Icons.monitor_weight_rounded;
    } else if (type == "Progress Upload") {
      accentColor = const Color(0xffFF00E5);
      typeIcon = Icons.add_a_photo_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            /// Glow indicator on left edge
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                color: accentColor,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  /// Primary Row (Icon + Details + Toggle Switch)
                  Row(
                    children: [
                      /// Icon Container
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: accentColor.withOpacity(0.08),
                          border: Border.all(color: accentColor.withOpacity(0.18), width: 1),
                        ),
                        child: Icon(typeIcon, color: accentColor, size: 20),
                      ),
                      const SizedBox(width: 14),

                      /// Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              time,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              name,
                              style: GoogleFonts.outfit(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Switch toggle
                      Obx(() => Switch(
                            value: isEnabled.value,
                            activeColor: accentColor,
                            activeTrackColor: accentColor.withOpacity(0.20),
                            inactiveThumbColor: Colors.white30,
                            inactiveTrackColor: Colors.white10,
                            onChanged: (val) => controller.toggleReminder(id, val),
                          )),
                    ],
                  ),

                  const SizedBox(height: 12),
                  Divider(color: Colors.white.withOpacity(0.04), height: 1),
                  const SizedBox(height: 12),

                  /// Secondary Row (Days list + Snooze adjustment + Trash trigger)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      /// Days text
                      Row(
                        children: [
                          Icon(Icons.calendar_today_rounded, color: Colors.white.withOpacity(0.30), size: 10),
                          const SizedBox(width: 6),
                          Text(
                            days.join(", "),
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.40),
                              fontSize: 9,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      /// Snooze select & Delete buttons
                      Row(
                        children: [
                          /// Snooze chip selector
                          GestureDetector(
                            onTap: () => showSnoozePicker(context, id, snooze),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.02),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.white.withOpacity(0.05), width: 0.8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.snooze_rounded, color: accentColor, size: 11),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${snooze}m",
                                    style: GoogleFonts.outfit(
                                      color: Colors.white.withOpacity(0.70),
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          /// Delete Button
                          GestureDetector(
                            onTap: () => controller.deleteReminder(id),
                            child: Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red.withOpacity(0.05),
                              ),
                              child: Icon(Icons.delete_outline_rounded, color: Colors.red.withOpacity(0.60), size: 15),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Empty State Widget
  Widget buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60),
      child: Column(
        children: [
          const Icon(Icons.alarm_off_rounded, color: Colors.white24, size: 48),
          const SizedBox(height: 14),
          Text(
            "No reminders found",
            style: GoogleFonts.outfit(color: Colors.white54, fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "Try adding a schedule or adjust filters.",
            style: GoogleFonts.inter(color: Colors.white30, fontSize: 10),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// ADD REMINDER CTA BUTTON
  /// ----------------------------------------------------
  Widget buildAddReminderCTA(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xffFF00E5),
            Color(0xffB100FF),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffB100FF).withOpacity(0.30),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () => showAddReminderSheet(context),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.add_alarm_rounded, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  "Add Reminder Schedule",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ----------------------------------------------------
  /// SNOOZE PICKER POPUP SHEET
  /// ----------------------------------------------------
  void showSnoozePicker(BuildContext context, int id, int currentSnooze) {
    final options = [5, 10, 15, 20, 30];
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: const Color(0xff090414),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.0),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                height: 4,
                width: 36,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              "Adjust Snooze Duration",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Select snooze length when alarm triggers",
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.40),
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: options.map((mins) {
                final isSelected = mins == currentSnooze;
                return GestureDetector(
                  onTap: () {
                    controller.updateSnooze(id, mins);
                    Get.back();
                  },
                  child: Container(
                    height: 40,
                    width: 54,
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xffB100FF).withOpacity(0.12) : Colors.white.withOpacity(0.01),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: isSelected ? const Color(0xffB100FF) : Colors.white.withOpacity(0.04),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "${mins}m",
                        style: GoogleFonts.outfit(
                          color: isSelected ? Colors.white : Colors.white.withOpacity(0.50),
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }

  /// ----------------------------------------------------
  /// ADD REMINDER BOTTOM SHEET FORM
  /// ----------------------------------------------------
  void showAddReminderSheet(BuildContext context) {
    final titleController = TextEditingController();
    final selectedType = "Meal".obs;
    final selectedTime = "08:00 AM".obs;
    final selectedDays = <String>[].obs;
    final snoozeVal = 10.obs;

    final weekDays = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
    final typesList = [
      {"name": "Meal", "icon": Icons.restaurant_rounded, "color": const Color(0xffFF7A00)},
      {"name": "Water", "icon": Icons.water_drop_rounded, "color": const Color(0xff00E5FF)},
      {"name": "Supplement", "icon": Icons.medication_rounded, "color": const Color(0xffB100FF)},
      {"name": "Weight Check", "icon": Icons.monitor_weight_rounded, "color": const Color(0xffFFD700)},
      {"name": "Progress Upload", "icon": Icons.add_a_photo_rounded, "color": const Color(0xffFF00E5)},
    ];

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: const Color(0xff090414),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.0),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// drag handle
                  Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  Text(
                    "New Reminder Schedule",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 18),

                  /// Reminder Title Input
                  Text(
                    "REMINDER LABEL",
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.40),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white.withOpacity(0.04), width: 1),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: TextField(
                      controller: titleController,
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "e.g., Post-workout Protein Shake",
                        hintStyle: GoogleFonts.inter(color: Colors.white.withOpacity(0.25), fontSize: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),

                  /// Reminder Category Type Row
                  Text(
                    "REMINDER TYPE",
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.40),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 52,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: typesList.length,
                      itemBuilder: (context, idx) {
                        final typeMap = typesList[idx];
                        final name = typeMap["name"] as String;
                        final icon = typeMap["icon"] as IconData;
                        final color = typeMap["color"] as Color;

                        return Obx(() {
                          final isSelected = selectedType.value == name;
                          return GestureDetector(
                            onTap: () => selectedType.value = name,
                            child: Container(
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: isSelected ? color.withOpacity(0.12) : Colors.white.withOpacity(0.01),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected ? color : Colors.white.withOpacity(0.04),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(icon, color: isSelected ? color : Colors.white.withOpacity(0.35), size: 16),
                                  const SizedBox(width: 8),
                                  Text(
                                    name,
                                    style: GoogleFonts.outfit(
                                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.50),
                                      fontSize: 11,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 18),

                  /// Time Picker trigger row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "TIME",
                            style: GoogleFonts.outfit(
                              color: Colors.white.withOpacity(0.40),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Obx(() => Text(
                                selectedTime.value,
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )),
                        ],
                      ),
                      GestureDetector(
                        onTap: () async {
                          final TimeOfDay? picked = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: const ColorScheme.dark(
                                    primary: Color(0xffB100FF),
                                    onPrimary: Colors.white,
                                    surface: Color(0xff090414),
                                    onSurface: Colors.white,
                                  ),
                                  dialogBackgroundColor: const Color(0xff090414),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (picked != null) {
                            final hour = picked.hourOfPeriod == 0 ? 12 : picked.hourOfPeriod;
                            final minute = picked.minute.toString().padLeft(2, '0');
                            final period = picked.period == DayPeriod.am ? 'AM' : 'PM';
                            selectedTime.value = "${hour.toString().padLeft(2, '0')}:$minute $period";
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: const Color(0xffB100FF).withOpacity(0.08),
                            border: Border.all(color: const Color(0xffB100FF).withOpacity(0.30)),
                          ),
                          child: Text(
                            "Choose Time",
                            style: GoogleFonts.outfit(
                              color: const Color(0xffB100FF),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  /// Custom day picker row
                  Text(
                    "REPEAT ON DAYS",
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.40),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: weekDays.map((day) {
                      return Obx(() {
                        final isSel = selectedDays.contains(day);
                        return GestureDetector(
                          onTap: () {
                            if (isSel) {
                              selectedDays.remove(day);
                            } else {
                              selectedDays.add(day);
                            }
                          },
                          child: Container(
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: isSel
                                  ? const LinearGradient(
                                      colors: [Color(0xffFF00E5), Color(0xffB100FF)],
                                    )
                                  : null,
                              color: isSel ? null : Colors.white.withOpacity(0.02),
                              border: Border.all(
                                color: isSel ? Colors.transparent : Colors.white.withOpacity(0.04),
                                width: 1.0,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                day.substring(0, 1),
                                style: GoogleFonts.outfit(
                                  color: isSel ? Colors.white : Colors.white.withOpacity(0.40),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  /// Snooze Minutes slider or adjuster
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "SNOOZE DURATION",
                        style: GoogleFonts.outfit(
                          color: Colors.white.withOpacity(0.40),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.8,
                        ),
                      ),
                      Obx(() => Text(
                            "${snoozeVal.value} Minutes",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ],
                  ),
                  Obx(() => SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: const Color(0xffB100FF),
                          inactiveTrackColor: Colors.white10,
                          thumbColor: const Color(0xffFF00E5),
                          overlayColor: const Color(0xffFF00E5).withOpacity(0.12),
                          valueIndicatorColor: const Color(0xff090414),
                          trackHeight: 3,
                        ),
                        child: Slider(
                          value: snoozeVal.value.toDouble(),
                          min: 5,
                          max: 30,
                          divisions: 5,
                          label: "${snoozeVal.value}m",
                          onChanged: (val) => snoozeVal.value = val.toInt(),
                        ),
                      )),
                  const SizedBox(height: 24),

                  /// Create CTA
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          final label = titleController.text.trim();
                          if (label.isEmpty) {
                            Get.snackbar(
                              "Error",
                              "Please provide a reminder label.",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red.withOpacity(0.8),
                              colorText: Colors.white,
                            );
                            return;
                          }
                          // Add reminder
                          controller.addReminder(
                            label,
                            selectedType.value,
                            selectedTime.value,
                            selectedDays.isEmpty ? ["Everyday"] : selectedDays.toList(),
                            snoozeVal.value,
                          );
                          Get.back();
                        },
                        child: Text(
                          "Save Reminder",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
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
      ),
      isScrollControlled: true,
    );
  }
}
