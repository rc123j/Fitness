import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/booking_controller.dart';
import '../../../services/auth_service.dart' as import_auth;

class ExpertDashboardView extends GetView<BookingController> {
  const ExpertDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    // Deferred to after this frame — calling it synchronously here mutates
    // an Rx value (isLoadingAppointments) while this very build is still in
    // progress, which can crash with "setState() called during build" once
    // an Obx further down reacts to it mid-build.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => controller.fetchExpertAppointments(),
    );

    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Expert Consultation Portal",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.forum_rounded, color: Colors.white),
            tooltip: "Messages",
            onPressed: () => Get.toNamed('/expert-messages'),
          ),
          IconButton(
            icon: const Icon(Icons.history_rounded, color: Colors.white),
            tooltip: "Booking History",
            onPressed: () => Get.toNamed('/expert-history'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () => controller.fetchExpertAppointments(),
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Colors.white70),
            onPressed: () {
              Get.defaultDialog(
                title: "Logout",
                middleText: "Are you sure you want to log out?",
                textConfirm: "Logout",
                textCancel: "Cancel",
                confirmTextColor: Colors.white,
                buttonColor: const Color(0xffFF00E5),
                onConfirm: () {
                  Get.find<import_auth.AuthService>().logout();
                },
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoadingAppointments.value) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFF00E5)),
            ),
          );
        }

        // Only ongoing work belongs on the main dashboard — anything
        // finished (completed/rejected/cancelled) piles up forever
        // otherwise. That's what the History screen is for.
        final activeAppointments = controller.expertAppointments
            .where((a) => a['status'] == 'PENDING' || a['status'] == 'APPROVED')
            .toList();

        if (activeAppointments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.white.withOpacity(0.2),
                  size: 64,
                ),
                const SizedBox(height: 16),
                Text(
                  "No active appointments right now",
                  style: GoogleFonts.outfit(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => Get.toNamed('/expert-history'),
                  child: Text(
                    "View booking history",
                    style: GoogleFonts.outfit(
                      color: const Color(0xffFF00E5),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: activeAppointments.length,
          itemBuilder: (context, index) {
            final apt = activeAppointments[index];
            final member = apt['member'] ?? {};
            final user = member['user'] ?? {};
            final slot = apt['slot'] ?? {};
            final dateStr = slot['start_time'] ?? '';

            DateTime? startTime;
            if (dateStr.isNotEmpty) {
              startTime = DateTime.parse(dateStr).toLocal();
            }

            final formattedDate = startTime != null
                ? DateFormat('EEEE, dd MMM yyyy').format(startTime)
                : 'N/A';
            final formattedTime = startTime != null
                ? DateFormat('hh:mm a').format(startTime)
                : 'N/A';

            final status = apt['status'] as String? ?? 'PENDING';
            final isPending = status == 'PENDING';
            final isCompleted = status == 'COMPLETED';
            // Only allow starting the call from 10 minutes before the
            // scheduled slot onward — approving a request shouldn't
            // immediately let either side jump into a call for a session
            // that's still hours (or days) away.
            final bool canStartCall =
                startTime != null &&
                DateTime.now().isAfter(
                  startTime.subtract(const Duration(minutes: 10)),
                );

            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff090414),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.04),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${user['first_name'] ?? 'Client'} ${user['last_name'] ?? ''}",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: _getStatusColor(status).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: _getStatusColor(status).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          status,
                          style: GoogleFonts.inter(
                            color: _getStatusColor(status),
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Email: ${user['email'] ?? 'N/A'} | Phone: ${user['phone'] ?? 'N/A'}",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Divider(color: Colors.white10, height: 1),
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
                        formattedDate,
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.access_time_rounded,
                        color: Color(0xffFF00E5),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        formattedTime,
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  if (apt['notes'] != null &&
                      (apt['notes'] as String).isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      "Client Notes: ${apt['notes']}",
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.5),
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  if (isPending) ...[
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => controller.respondToAppointment(
                              apt['id'],
                              'REJECTED',
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.redAccent),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Reject",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => controller.respondToAppointment(
                              apt['id'],
                              'APPROVED',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff00FF87),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              "Approve",
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else if (!isCompleted &&
                      status != 'REJECTED' &&
                      status != 'CANCELLED') ...[
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _showCompleteSessionDialog(
                                  context,
                                  apt['id'],
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xffFF00E5),
                                  side: const BorderSide(
                                    color: Color(0xffFF00E5),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Text(
                                  "Add Notes",
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => Get.toNamed(
                                  '/chat',
                                  arguments: {
                                    'appointmentId': apt['id'],
                                    'otherPartyName':
                                        "${user['first_name'] ?? 'Client'} ${user['last_name'] ?? ''}",
                                  },
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: BorderSide(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      size: 15,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Message",
                                      style: GoogleFonts.outfit(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: canStartCall
                                ? () =>
                                      Get.toNamed('/video-call', arguments: apt)
                                : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: canStartCall
                                  ? const Color(0xff00FF87)
                                  : Colors.white.withOpacity(0.06),
                              disabledBackgroundColor: Colors.white.withOpacity(
                                0.06,
                              ),
                              foregroundColor: canStartCall
                                  ? Colors.black
                                  : Colors.white38,
                              disabledForegroundColor: Colors.white38,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  canStartCall
                                      ? Icons.videocam_rounded
                                      : Icons.lock_clock_rounded,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  canStartCall
                                      ? "Start Call"
                                      : "Available at $formattedTime",
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ] else if (isCompleted) ...[
                    if (apt['expert_notes'] != null &&
                        (apt['expert_notes'] as String).isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        "Your Notes: ${apt['expert_notes']}",
                        style: GoogleFonts.inter(
                          color: const Color(0xff00FF87).withOpacity(0.70),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'APPROVED':
        return const Color(0xff00FF87);
      case 'PENDING':
        return const Color(0xffFFD600);
      case 'COMPLETED':
        return const Color(0xff00E5FF);
      case 'REJECTED':
      case 'CANCELLED':
        return Colors.redAccent;
      default:
        return Colors.white54;
    }
  }

  void _showCompleteSessionDialog(BuildContext context, int appointmentId) {
    final notesController = TextEditingController();

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xff090414),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Complete Consultation",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Write any recommendation or notes for the client.",
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                maxLines: 4,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: "Add workout tips, diet recommendations...",
                  hintStyle: GoogleFonts.inter(
                    color: Colors.white24,
                    fontSize: 13,
                  ),
                  fillColor: Colors.white.withOpacity(0.02),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.white.withOpacity(0.1),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xffFF00E5)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.outfit(
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      controller.completeAppointment(
                        appointmentId,
                        notesController.text.trim(),
                      );
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffFF00E5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Complete & Save",
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
