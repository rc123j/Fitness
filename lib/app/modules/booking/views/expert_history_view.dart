import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/booking_controller.dart';

/// Read-only record of every booking this expert has ever had, split out
/// from the main dashboard (which only shows PENDING/APPROVED work) so the
/// active list doesn't get buried under years of finished bookings.
class ExpertHistoryView extends GetView<BookingController> {
  const ExpertHistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    // Deferred to after this frame — calling it synchronously here mutates
    // an Rx value (isLoadingAppointments) while this very build is still in
    // progress, which crashes with "setState() called during build" the
    // moment the Obx below tries to react to it.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => controller.fetchExpertAppointments(),
    );

    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Booking History",
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

        final all = controller.expertAppointments;
        final total = all.length;
        final completed = all.where((a) => a['status'] == 'COMPLETED').length;
        final cancelled = all.where((a) => a['status'] == 'CANCELLED').length;
        final rejected = all.where((a) => a['status'] == 'REJECTED').length;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
              child: Row(
                children: [
                  Expanded(
                    child: _statTile(
                      "Total",
                      total,
                      const Color(0xffB100FF),
                      Icons.calendar_month_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _statTile(
                      "Completed",
                      completed,
                      const Color(0xff00E5FF),
                      Icons.check_circle_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _statTile(
                      "Cancelled",
                      cancelled + rejected,
                      Colors.redAccent,
                      Icons.cancel_rounded,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(child: _StatusFilteredList(appointments: all)),
          ],
        );
      }),
    );
  }

  Widget _statTile(String label, int value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
      decoration: BoxDecoration(
        color: const Color(0xff0B0817).withOpacity(0.55),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 6),
          Text(
            "$value",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.55),
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusFilteredList extends StatefulWidget {
  final List<Map<String, dynamic>> appointments;
  const _StatusFilteredList({required this.appointments});

  @override
  State<_StatusFilteredList> createState() => _StatusFilteredListState();
}

class _StatusFilteredListState extends State<_StatusFilteredList> {
  String _filter = "All";
  static const _filters = [
    "All",
    "Pending",
    "Approved",
    "Completed",
    "Cancelled",
    "Rejected",
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _filter == "All"
        ? widget.appointments
        : widget.appointments
              .where(
                (a) => (a['status']?.toString() ?? '') == _filter.toUpperCase(),
              )
              .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 38,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _filters.length,
            itemBuilder: (context, index) {
              final f = _filters[index];
              final isActive = _filter == f;
              return GestureDetector(
                onTap: () => setState(() => _filter = f),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: isActive
                        ? const Color(0xffB100FF).withOpacity(0.15)
                        : const Color(0xff0B0817).withOpacity(0.55),
                    border: Border.all(
                      color: isActive
                          ? const Color(0xffB100FF)
                          : Colors.white.withOpacity(0.08),
                    ),
                  ),
                  child: Text(
                    f,
                    style: GoogleFonts.outfit(
                      color: isActive ? Colors.white : Colors.white54,
                      fontSize: 11,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Text(
                    "No bookings here yet",
                    style: GoogleFonts.inter(
                      color: Colors.white38,
                      fontSize: 13,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => _buildCard(filtered[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildCard(Map<String, dynamic> apt) {
    final member = apt['member'] ?? {};
    final user = member['user'] ?? {};
    final slot = apt['slot'] ?? {};
    final dateStr = slot['start_time']?.toString();
    final startTime = dateStr != null
        ? DateTime.tryParse(dateStr)?.toLocal()
        : null;

    final formattedDate = startTime != null
        ? DateFormat('dd MMM yyyy, hh:mm a').format(startTime)
        : 'N/A';
    final status = apt['status']?.toString() ?? 'PENDING';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xff090414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.04)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: _statusColor(status),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${user['first_name'] ?? 'Client'} ${user['last_name'] ?? ''}",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  formattedDate,
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 11,
                  ),
                ),
                if (apt['expert_notes'] != null &&
                    (apt['expert_notes'] as String).isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    "Notes: ${apt['expert_notes']}",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.35),
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _statusColor(status).withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: _statusColor(status).withOpacity(0.3)),
            ),
            child: Text(
              status,
              style: GoogleFonts.inter(
                color: _statusColor(status),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _statusColor(String status) {
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
}
