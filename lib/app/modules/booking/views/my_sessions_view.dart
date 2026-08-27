import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/booking_controller.dart';
import '../../../widgets/premium_layout_components.dart';

class MySessionsView extends GetView<BookingController> {
  const MySessionsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "My Sessions",
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
      body: Obx(() {
        if (controller.isLoadingAppointments.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xffFF00E5)),
          );
        }

        if (controller.clientAppointments.isEmpty) {
          return Center(
            child: Text(
              "No upcoming booked sessions",
              style: GoogleFonts.inter(color: Colors.white30, fontSize: 14),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.clientAppointments.length,
          itemBuilder: (context, index) {
            final apt = controller.clientAppointments[index];
            final consultant = apt['consultant'] ?? {};
            final slot = apt['slot'] ?? {};
            final dateStr = slot['start_time'] ?? '';

            DateTime? startTime;
            if (dateStr.isNotEmpty) {
              startTime = DateTime.parse(dateStr).toLocal();
            }

            final formattedDate = startTime != null
                ? DateFormat('EEEE, dd MMM').format(startTime)
                : 'N/A';
            final formattedTime = startTime != null
                ? DateFormat('hh:mm a').format(startTime)
                : 'N/A';
            final status = apt['status'] as String? ?? 'PENDING';

            return _buildSessionCard(
              context,
              apt,
              consultant,
              formattedDate,
              formattedTime,
              status,
              startTime,
            );
          },
        );
      }),
    );
  }

  Widget _buildSessionCard(
    BuildContext context,
    Map<String, dynamic> apt,
    Map<String, dynamic> consultant,
    String formattedDate,
    String formattedTime,
    String status,
    DateTime? startTime,
  ) {
    final slot = apt['slot'] ?? {};
    final endStr = slot['end_time'] ?? '';
    DateTime? endTime;
    if (endStr.isNotEmpty) {
      endTime = DateTime.parse(endStr).toLocal();
    }
    final resolvedEndTime = endTime ?? (startTime != null ? startTime.add(const Duration(minutes: 45)) : null);
    final bool isExpired = resolvedEndTime != null && DateTime.now().isAfter(resolvedEndTime);
    final displayStatus = isExpired && (status == 'PENDING' || status == 'APPROVED') ? 'TIME OVER' : status;

    final bool canJoinCall = !isExpired &&
        startTime != null &&
        DateTime.now().isAfter(startTime.subtract(const Duration(minutes: 10)));

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff090414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Consultation with ${consultant['first_name'] ?? 'Coach'} ${consultant['last_name'] ?? ''}",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (!isExpired && (status == 'PENDING' || status == 'APPROVED'))
                IconButton(
                  icon: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.redAccent,
                    size: 20,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () => _confirmCancellation(context, apt['id']),
                ),
            ],
          ),
          const SizedBox(height: 8),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(displayStatus).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _getStatusColor(displayStatus).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              displayStatus,
              style: GoogleFonts.inter(
                color: _getStatusColor(displayStatus),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              const Icon(
                Icons.calendar_month_rounded,
                color: Color(0xff00E5FF),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "$formattedDate at $formattedTime",
                style: GoogleFonts.inter(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(
                Icons.confirmation_number_outlined,
                color: Colors.white30,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                "Booking ID: #${apt['id']}",
                style: GoogleFonts.inter(color: Colors.white30, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),

          if (isExpired) ...[
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final consultantId = consultant['id'];
                      final idx = controller.experts.indexWhere((e) => e['id'] == consultantId);
                      if (idx != -1) {
                        controller.selectedExpertIndex.value = idx;
                        Get.to(() => const BookingDateTimeView());
                      } else {
                        Get.toNamed('/booking');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFF00E5),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.event_available_rounded, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          "Book Again",
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ] else if (status == 'APPROVED' || status == 'PENDING')
            Row(
              children: [
                if (status == 'APPROVED') ...[
                  Expanded(
                    child: ElevatedButton(
                      onPressed: canJoinCall
                          ? () => Get.toNamed('/video-call', arguments: apt)
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: canJoinCall
                            ? const Color(0xff00FF87)
                            : Colors.white.withOpacity(0.06),
                        disabledBackgroundColor: Colors.white.withOpacity(0.06),
                        foregroundColor: canJoinCall
                            ? Colors.black
                            : Colors.white38,
                        disabledForegroundColor: Colors.white38,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            canJoinCall
                                ? Icons.videocam_rounded
                                : Icons.lock_clock_rounded,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            canJoinCall
                                ? "Join Call"
                                : "Opens at $formattedTime",
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Get.toNamed(
                      '/chat',
                      arguments: {
                        'appointmentId': apt['id'],
                        'otherPartyName':
                            "${consultant['first_name'] ?? 'Coach'} ${consultant['last_name'] ?? ''}",
                      },
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: BorderSide(color: Colors.white.withOpacity(0.2)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.message_rounded, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          "Message",
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
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

  Color _getStatusColor(String status) {
    if (status == 'APPROVED') return const Color(0xff00FF87);
    if (status == 'CANCELLED') return Colors.redAccent;
    if (status == 'COMPLETED') return Colors.blueAccent;
    if (status == 'TIME OVER') return Colors.white30;
    return Colors.amber;
  }

  void _confirmCancellation(BuildContext context, int appointmentId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xff0B0817),
        title: Text(
          "Cancel Booking?",
          style: GoogleFonts.outfit(color: Colors.white),
        ),
        content: Text(
          "Are you sure you want to cancel this booking? This action cannot be undone.",
          style: GoogleFonts.inter(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Keep Booking",
              style: GoogleFonts.inter(color: Colors.white54),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.cancelAppointment(appointmentId);
            },
            child: Text(
              "Yes, Cancel",
              style: GoogleFonts.inter(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
