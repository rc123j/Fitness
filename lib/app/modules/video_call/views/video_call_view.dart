import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/video_call_controller.dart';

class VideoCallView extends GetView<VideoCallController> {
  const VideoCallView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Obx(() {
        final connected = controller.connectionStatus.value == "Connected";

        return Stack(
          children: [
            /// 1. TRAINER'S FULL-SCREEN VIDEO STREAM FEED
            Positioned.fill(
              child: Image.network(
                "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=600",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xff06010F),
                  child: Center(
                    child: Icon(
                      Icons.person_rounded,
                      color: Colors.white.withOpacity(0.10),
                      size: 100,
                    ),
                  ),
                ),
              ),
            ),

            /// Dark overlay gradient to ensure text readability
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.60),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.70),
                    ],
                  ),
                ),
              ),
            ),

            /// 2. PIP SELF-PREVIEW CAMERA CONTAINER (FLOAT)
            if (connected)
              Positioned(
                top: 140,
                right: 20,
                child: Obx(() {
                  final camOff = controller.isCameraOff.value;

                  return Container(
                    height: 150,
                    width: 100,
                    decoration: BoxDecoration(
                      color: const Color(0xff0B0817).withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: camOff ? Colors.white.withOpacity(0.15) : const Color(0xffFF00E5).withOpacity(0.50),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.40),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: camOff
                          ? Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.videocam_off_rounded, color: Colors.white.withOpacity(0.40), size: 20),
                                  const SizedBox(height: 6),
                                  Text(
                                    "Cam Off",
                                    style: GoogleFonts.inter(
                                      color: Colors.white.withOpacity(0.40),
                                      fontSize: 8.5,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Image.network(
                              "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200",
                              fit: BoxFit.cover,
                            ),
                    ),
                  );
                }),
              ),

            /// 3. BACK BUTTON (Top-left overlay)
            Positioned(
              top: 52,
              left: 20,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.40),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.12),
                      width: 0.8,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),

            /// 4. TOP META PANEL (Status, Name, Role, Call Timer)
            Positioned(
              top: 106,
              left: 20,
              right: 20,
              child: buildTopMetaPanel(),
            ),

            /// 4. BOTTOM ACTION CONTROL PANEL
            Positioned(
              bottom: 30,
              left: 30,
              right: 30,
              child: buildBottomControlPanel(),
            ),

            /// 5. CONNECTING COVER OVERLAY
            if (!connected)
              Positioned.fill(
                child: buildConnectingOverlay(),
              ),
          ],
        );
      }),
    );
  }

  /// ----------------------------------------------------
  /// TOP METADATA BAR
  /// ----------------------------------------------------
  Widget buildTopMetaPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xff090414).withOpacity(0.50),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.06), width: 1.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Row(
            children: [
              /// Trainer Profile Circle
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xff00FF87), width: 1),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(controller.trainerAvatar.value, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),

              /// Info details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          controller.trainerName.value,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),

                        /// Pulse indicator dot
                        Container(
                          height: 6,
                          width: 6,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff00FF87),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      controller.trainerRole.value,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.50),
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ),
              ),

              /// Ticking stopwatch counter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withOpacity(0.08)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.timer_outlined, color: Color(0xff00E5FF), size: 12),
                    const SizedBox(width: 6),
                    Text(
                      controller.formattedDuration,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ----------------------------------------------------
  /// BOTTOM ACTION PANEL
  /// ----------------------------------------------------
  Widget buildBottomControlPanel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xff090414).withOpacity(0.55),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.06), width: 1.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              /// MUTE MICROPHONE BUTTON
              Obx(() {
                final muted = controller.isMuted.value;
                return buildCallActionButton(
                  icon: muted ? Icons.mic_off_rounded : Icons.mic_rounded,
                  color: muted ? Colors.red : Colors.white24,
                  iconColor: Colors.white,
                  onTap: () => controller.toggleMute(),
                );
              }),

              /// END CALL BUTTON (Gradient Red)
              GestureDetector(
                onTap: () => controller.endCall(),
                child: Container(
                  height: 52,
                  width: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xffFF3B30),
                        Color(0xffFF2D55),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xffFF3B30).withOpacity(0.40),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Icon(Icons.call_end_rounded, color: Colors.white, size: 24),
                ),
              ),

              /// CAMERA TOGGLE BUTTON
              Obx(() {
                final camOff = controller.isCameraOff.value;
                return buildCallActionButton(
                  icon: camOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
                  color: camOff ? Colors.red : Colors.white24,
                  iconColor: Colors.white,
                  onTap: () => controller.toggleCamera(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCallActionButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 44,
        width: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(color: Colors.white.withOpacity(0.04)),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
    );
  }

  /// ----------------------------------------------------
  /// CONNECTING OVERLAY BLUR VIEW
  /// ----------------------------------------------------
  Widget buildConnectingOverlay() {
    return Container(
      color: const Color(0xff06010F).withOpacity(0.85),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              /// Pulsing neon progress bar ring
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 80,
                    width: 80,
                    child: CircularProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xffB100FF)),
                      strokeWidth: 3.5,
                      backgroundColor: Colors.white.withOpacity(0.04),
                    ),
                  ),
                  const Icon(
                    Icons.video_call_rounded,
                    color: Color(0xffFF00E5),
                    size: 32,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "Connecting with Expert...",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Establishing secure audio-video stream",
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.40),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
