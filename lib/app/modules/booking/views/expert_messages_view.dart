import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/booking_controller.dart';

/// Messenger-style inbox for the expert — every client conversation in one
/// list, each showing its last message and unread count, instead of having
/// to open each booking individually to check for new messages.
class ExpertMessagesView extends GetView<BookingController> {
  const ExpertMessagesView({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => controller.fetchConsultantConversations(),
    );

    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Messages",
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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () => controller.fetchConsultantConversations(),
          ),
        ],
      ),
      body: RefreshIndicator(
        color: const Color(0xffFF00E5),
        backgroundColor: const Color(0xff121220),
        onRefresh: controller.fetchConsultantConversations,
        child: Obx(() {
          if (controller.isLoadingConversations.value &&
              controller.consultantConversations.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xffFF00E5)),
            );
          }

          final conversations = controller.consultantConversations;
          if (conversations.isEmpty) {
            return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.forum_outlined,
                        color: Colors.white.withOpacity(0.2),
                        size: 56,
                      ),
                      const SizedBox(height: 14),
                      Text(
                        "No conversations yet",
                        style: GoogleFonts.outfit(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: conversations.length,
            itemBuilder: (context, index) =>
                _buildConversationTile(conversations[index]),
          );
        }),
      ),
    );
  }

  Widget _buildConversationTile(Map<String, dynamic> convo) {
    final member = convo['member'] ?? {};
    final user = member['user'] ?? {};
    final name = "${user['first_name'] ?? 'Client'} ${user['last_name'] ?? ''}"
        .trim();
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';

    final lastMessage = convo['last_message'];
    final preview = lastMessage != null
        ? lastMessage['body']?.toString() ?? ''
        : 'No messages yet — say hello';

    String timeStr = '';
    if (lastMessage != null && lastMessage['created_at'] != null) {
      final dt = DateTime.tryParse(
        lastMessage['created_at'].toString(),
      )?.toLocal();
      if (dt != null) timeStr = DateFormat('dd MMM, hh:mm a').format(dt);
    }

    final unread = (convo['unread_count'] as num?)?.toInt() ?? 0;

    return GestureDetector(
      onTap: () => Get.toNamed(
        '/chat',
        arguments: {
          'appointmentId': convo['appointment_id'],
          'otherPartyName': name.isEmpty ? 'Client' : name,
        },
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xff0B0817).withOpacity(0.55),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: unread > 0
                ? const Color(0xffFF00E5).withOpacity(0.3)
                : Colors.white.withOpacity(0.06),
          ),
        ),
        child: Row(
          children: [
            Container(
              height: 44,
              width: 44,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xffFF00E5), Color(0xffB100FF)],
                ),
              ),
              child: Text(
                initial,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name.isEmpty ? 'Client' : name,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (timeStr.isNotEmpty)
                        Text(
                          timeStr,
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.35),
                            fontSize: 9,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          preview,
                          style: GoogleFonts.inter(
                            color: unread > 0
                                ? Colors.white.withOpacity(0.85)
                                : Colors.white.withOpacity(0.45),
                            fontSize: 12,
                            fontWeight: unread > 0
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unread > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xffFF00E5),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "$unread",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
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
}
