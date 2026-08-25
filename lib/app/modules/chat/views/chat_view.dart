import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          controller.otherPartyName,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xffFF00E5)),
                  );
                }
                final items = controller.messages;
                if (items.isEmpty) {
                  return Center(
                    child: Text(
                      "No messages yet — say hello!",
                      style: GoogleFonts.inter(
                        color: Colors.white38,
                        fontSize: 13,
                      ),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final msg = items[index];
                    final senderId = msg['sender']?['id'];
                    final isMine = senderId == controller.myUserId;
                    return _buildBubble(msg, isMine);
                  },
                );
              }),
            ),
            _buildInputBar(textController),
          ],
        ),
      ),
    );
  }

  Widget _buildBubble(Map<String, dynamic> msg, bool isMine) {
    final body = msg['body']?.toString() ?? '';
    String timeStr = '';
    final createdAt = msg['created_at']?.toString();
    if (createdAt != null) {
      final dt = DateTime.tryParse(createdAt)?.toLocal();
      if (dt != null) timeStr = DateFormat('hh:mm a').format(dt);
    }

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        constraints: BoxConstraints(maxWidth: Get.width * 0.75),
        decoration: BoxDecoration(
          gradient: isMine
              ? const LinearGradient(
                  colors: [Color(0xffFF00E5), Color(0xffB100FF)],
                )
              : null,
          color: isMine ? null : const Color(0xff17141F),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMine ? 16 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              body,
              style: GoogleFonts.inter(
                color: Colors.white,
                fontSize: 13.5,
                height: 1.4,
              ),
            ),
            if (timeStr.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                timeStr,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 9,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(TextEditingController textController) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: const Color(0xff0B0817),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: TextField(
                controller: textController,
                minLines: 1,
                maxLines: 4,
                style: GoogleFonts.inter(color: Colors.white, fontSize: 13.5),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Type a message...",
                  hintStyle: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.35),
                  ),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Obx(
            () => GestureDetector(
              onTap: controller.isSending.value
                  ? null
                  : () {
                      final text = textController.text;
                      textController.clear();
                      controller.sendMessage(text);
                    },
              child: Container(
                height: 44,
                width: 44,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xffFF00E5), Color(0xffB100FF)],
                  ),
                ),
                child: controller.isSending.value
                    ? const Padding(
                        padding: EdgeInsets.all(12),
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 18,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
