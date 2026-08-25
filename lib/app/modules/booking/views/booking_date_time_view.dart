import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../controllers/booking_controller.dart';
import 'my_sessions_view.dart';

class BookingDateTimeView extends StatefulWidget {
  const BookingDateTimeView({super.key});

  @override
  State<BookingDateTimeView> createState() => _BookingDateTimeViewState();
}

class _BookingDateTimeViewState extends State<BookingDateTimeView> {
  final BookingController controller = Get.find<BookingController>();
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    // Default to the first available date in controller, or today
    _selectedDay = _focusedDay;
    _updateControllerDateSelection(_selectedDay!);
  }

  void _updateControllerDateSelection(DateTime selectedDate) {
    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    final dateList = controller.dates;

    int foundIndex = -1;
    for (int i = 0; i < dateList.length; i++) {
      if (dateList[i]['rawDate'] == dateStr) {
        foundIndex = i;
        break;
      }
    }

    controller.selectedDateIndex.value = foundIndex;
    controller.selectedTimeSlotIndex.value =
        0; // Reset time slot on date change
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Select Date & Time",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTableCalendar(),
              const SizedBox(height: 32),
              _buildTimeSlots(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildConfirmButton(),
    );
  }

  Widget _buildTableCalendar() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0B0817).withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.03), width: 0.8),
      ),
      padding: const EdgeInsets.all(8),
      child: TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 1)),
        lastDay: DateTime.now().add(const Duration(days: 90)),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
          _updateControllerDateSelection(selectedDay);
        },
        calendarStyle: CalendarStyle(
          defaultTextStyle: GoogleFonts.inter(color: Colors.white),
          weekendTextStyle: GoogleFonts.inter(color: Colors.white70),
          outsideTextStyle: GoogleFonts.inter(color: Colors.white30),
          selectedDecoration: const BoxDecoration(
            color: Color(0xffB100FF),
            shape: BoxShape.circle,
          ),
          todayDecoration: BoxDecoration(
            color: const Color(0xffB100FF).withOpacity(0.3),
            shape: BoxShape.circle,
          ),
        ),
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          leftChevronIcon: const Icon(
            Icons.chevron_left_rounded,
            color: Colors.white54,
          ),
          rightChevronIcon: const Icon(
            Icons.chevron_right_rounded,
            color: Colors.white54,
          ),
        ),
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
          weekendStyle: GoogleFonts.inter(color: Colors.white70, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildTimeSlots() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Available Times",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.timeSlots.isEmpty) {
            return Text(
              "No times available for this date.",
              style: GoogleFonts.inter(color: Colors.white54, fontSize: 13),
            );
          }
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: List.generate(controller.timeSlots.length, (index) {
              final slot = controller.timeSlots[index];
              return Obx(() {
                final isActive =
                    index == controller.selectedTimeSlotIndex.value;
                Color borderClr = isActive
                    ? const Color(0xffB100FF)
                    : Colors.white.withOpacity(0.04);
                Color fillClr = isActive
                    ? const Color(0xffB100FF).withOpacity(0.08)
                    : Colors.white.withOpacity(0.01);

                return GestureDetector(
                  onTap: () => controller.selectedTimeSlotIndex.value = index,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: fillClr,
                      border: Border.all(
                        color: borderClr,
                        width: isActive ? 1.5 : 0.8,
                      ),
                    ),
                    child: Text(
                      slot,
                      style: GoogleFonts.outfit(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withOpacity(0.50),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              });
            }),
          );
        }),
      ],
    );
  }

  Widget _buildConfirmButton() {
    return Obx(() {
      final expert = controller.currentExpert;
      if (expert.isEmpty ||
          expert["services"] == null ||
          (expert["services"] as List).isEmpty) {
        return const SizedBox.shrink();
      }
      final price = (expert["services"] as List)[0]["price"];
      final duration = (expert["services"] as List)[0]["duration"];

      return SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            height: 56,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () async {
                  if (controller.timeSlots.isEmpty) {
                    Get.snackbar(
                      "No Slot Selected",
                      "Please select a valid time slot to book.",
                      snackPosition: SnackPosition.BOTTOM,
                    );
                    return;
                  }
                  final success = await controller.bookSession();
                  if (success) {
                    Get.off(() => const MySessionsView());
                  }
                },
                borderRadius: BorderRadius.circular(16),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Confirm Booking",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "₹$price • $duration",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
