import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../controllers/booking_controller.dart';

class ExpertSlotsView extends StatefulWidget {
  const ExpertSlotsView({super.key});

  @override
  State<ExpertSlotsView> createState() => _ExpertSlotsViewState();
}

class _ExpertSlotsViewState extends State<ExpertSlotsView> {
  final controller = Get.find<BookingController>();
  CalendarFormat _calendarFormat = CalendarFormat.twoWeeks;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    // Load slots for the consultant
    controller.fetchExpertSlots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Manage Availability",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          // Table calendar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xff090414),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.04)),
            ),
            child: TableCalendar(
              firstDay: DateTime.now().subtract(const Duration(days: 30)),
              lastDay: DateTime.now().add(const Duration(days: 120)),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarStyle: CalendarStyle(
                defaultTextStyle: GoogleFonts.inter(color: Colors.white70),
                weekendTextStyle: GoogleFonts.inter(color: Colors.white30),
                selectedDecoration: const BoxDecoration(
                  color: Color(0xffFF00E5),
                  shape: BoxShape.circle,
                ),
                todayDecoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
              headerStyle: HeaderStyle(
                formatButtonTextStyle: GoogleFonts.outfit(color: Colors.white, fontSize: 11),
                formatButtonDecoration: BoxDecoration(
                  border: Border.all(color: Colors.white12),
                  borderRadius: BorderRadius.circular(12),
                ),
                titleTextStyle: GoogleFonts.outfit(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                leftChevronIcon: const Icon(Icons.chevron_left_rounded, color: Colors.white),
                rightChevronIcon: const Icon(Icons.chevron_right_rounded, color: Colors.white),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: GoogleFonts.inter(color: Colors.white54, fontSize: 11),
                weekendStyle: GoogleFonts.inter(color: Colors.white30, fontSize: 11),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Slots for ${DateFormat('dd MMM').format(_selectedDay ?? DateTime.now())}",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ).let((_) => GestureDetector(
                      onTap: () => _showAddSlotDialog(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xffFF00E5).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xffFF00E5).withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.add, color: Color(0xffFF00E5), size: 14),
                            const SizedBox(width: 4),
                            Text(
                              "Add Slot",
                              style: GoogleFonts.outfit(
                                color: const Color(0xffFF00E5),
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Slots list
          Expanded(
            child: Obx(() {
              if (controller.isLoadingSlots.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFF00E5)),
                  ),
                );
              }

              // Filter slots for the selected day
              final filteredSlots = controller.expertSlots.where((slot) {
                if (slot['start_time'] == null) return false;
                final start = DateTime.parse(slot['start_time']).toLocal();
                return isSameDay(start, _selectedDay);
              }).toList();

              if (filteredSlots.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.hourglass_empty_rounded, color: Colors.white24, size: 40),
                      const SizedBox(height: 8),
                      Text(
                        "No availability slots configured",
                        style: GoogleFonts.inter(color: Colors.white30, fontSize: 13),
                      )
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredSlots.length,
                itemBuilder: (context, index) {
                  final slot = filteredSlots[index];
                  final start = DateTime.parse(slot['start_time']).toLocal();
                  final end = DateTime.parse(slot['end_time']).toLocal();
                  final formattedStart = DateFormat('hh:mm a').format(start);
                  final formattedEnd = DateFormat('hh:mm a').format(end);
                  final status = slot['status'] as String? ?? 'AVAILABLE';

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xff090414),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.04)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.access_time_rounded, color: Color(0xff00FF87), size: 18),
                        const SizedBox(width: 12),
                        Text(
                          "$formattedStart - $formattedEnd",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: (status == 'AVAILABLE' ? const Color(0xff00FF87) : Colors.amber).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: (status == 'AVAILABLE' ? const Color(0xff00FF87) : Colors.amber).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            status,
                            style: GoogleFonts.inter(
                              color: status == 'AVAILABLE' ? const Color(0xff00FF87) : Colors.amber,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (status == 'AVAILABLE') ...[
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Get.defaultDialog(
                                title: "Delete Slot",
                                middleText: "Are you sure you want to remove this slot?",
                                textConfirm: "Delete",
                                textCancel: "Cancel",
                                confirmTextColor: Colors.white,
                                buttonColor: Colors.redAccent,
                                onConfirm: () {
                                  controller.deleteAvailabilitySlot(slot['id']);
                                  Get.back();
                                }
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(Icons.close_rounded, color: Colors.redAccent, size: 16),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
              );
            }),
          )
        ],
      ),
    );
  }

  void _showAddSlotDialog(BuildContext context) {
    TimeOfDay startTime = const TimeOfDay(hour: 9, minute: 0);
    TimeOfDay endTime = const TimeOfDay(hour: 10, minute: 0);

    // Intelligently auto-fill the next available time slot based on the last slot for this day
    final date = _selectedDay ?? DateTime.now();
    DateTime? latestEndTime;
    
    for (var slot in controller.expertSlots) {
      if (slot['start_time'] == null || slot['end_time'] == null) continue;
      final slotStart = DateTime.parse(slot['start_time']).toLocal();
      final slotEnd = DateTime.parse(slot['end_time']).toLocal();
      
      if (slotStart.year == date.year && slotStart.month == date.month && slotStart.day == date.day) {
        if (latestEndTime == null || slotEnd.isAfter(latestEndTime)) {
          latestEndTime = slotEnd;
        }
      }
    }

    if (latestEndTime != null) {
      startTime = TimeOfDay(hour: latestEndTime.hour, minute: latestEndTime.minute);
      final nextEnd = latestEndTime.add(const Duration(hours: 1));
      endTime = TimeOfDay(hour: nextEnd.hour, minute: nextEnd.minute);
    }

    Get.dialog(
      StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xff090414),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xffFF00E5).withOpacity(0.15),
                    blurRadius: 40,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xffFF00E5).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.add_task_rounded, color: Color(0xffFF00E5), size: 20),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Add Time Slot",
                        style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  
                  // Start Time Selector
                  Text("Start Time", style: GoogleFonts.inter(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context, 
                        initialTime: startTime,
                        builder: (context, child) => Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: Color(0xffFF00E5),
                              surface: Color(0xff090414),
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        setDialogState(() => startTime = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            startTime.format(context),
                            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const Icon(Icons.schedule_rounded, color: Color(0xff00E5FF), size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // End Time Selector
                  Text("End Time", style: GoogleFonts.inter(color: Colors.white54, fontSize: 12)),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showTimePicker(
                        context: context, 
                        initialTime: endTime,
                        builder: (context, child) => Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: Color(0xffFF00E5),
                              surface: Color(0xff090414),
                            ),
                          ),
                          child: child!,
                        ),
                      );
                      if (picked != null) {
                        setDialogState(() => endTime = picked);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.03),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.05)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            endTime.format(context),
                            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const Icon(Icons.schedule_rounded, color: Color(0xff00E5FF), size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Get.back(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.white.withOpacity(0.1)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text("Cancel", style: GoogleFonts.outfit(color: Colors.white60, fontWeight: FontWeight.w600)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            gradient: const LinearGradient(
                              colors: [Color(0xffFF00E5), Color(0xffB100FF)],
                            ),
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              final date = _selectedDay ?? DateTime.now();
                              final startDateTime = DateTime(date.year, date.month, date.day, startTime.hour, startTime.minute);
                              final endDateTime = DateTime(date.year, date.month, date.day, endTime.hour, endTime.minute);
                              
                              if (endDateTime.isBefore(startDateTime)) {
                                Get.snackbar(
                                  "Invalid Time",
                                  "End time must be after start time.",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                );
                                return;
                              }

                              bool hasConflict = false;
                              for (var slot in controller.expertSlots) {
                                if (slot['start_time'] == null) continue;
                                final existingStart = DateTime.parse(slot['start_time']).toLocal();
                                final existingEnd = DateTime.parse(slot['end_time']).toLocal();
                                
                                if (existingStart.year == startDateTime.year && existingStart.month == startDateTime.month && existingStart.day == startDateTime.day) {
                                  if (startDateTime.isBefore(existingEnd) && endDateTime.isAfter(existingStart)) {
                                    hasConflict = true;
                                    break;
                                  }
                                }
                              }

                              if (hasConflict) {
                                Get.snackbar(
                                  "Time Conflict",
                                  "This time slot overlaps with an existing slot.",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.redAccent,
                                  colorText: Colors.white,
                                );
                                return;
                              }

                              controller.addAvailabilitySlot(startDateTime, endDateTime);
                              Get.back();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text("Save Slot", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

extension LetExtension<T> on T {
  R let<R>(R Function(T) block) => block(this);
}
