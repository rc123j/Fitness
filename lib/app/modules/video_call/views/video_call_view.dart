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
      backgroundColor: const Color(0xff090414),
      body: Stack(
        children: [
          /// 1. SUBTLE BACKGROUND AMBIENCE
          Positioned(
            top: -150,
            left: -100,
            child: Container(
              height: 400,
              width: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xff2E0A4F).withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// 2. MAIN LAYOUT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  /// BACK BUTTON & TITLE
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => controller.endCall(),
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white70,
                            size: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        "Consultation Room",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  /// 3. CONSULTATION CALL DETAILS CARD
                  Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: Colors.white.withOpacity(0.08)),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Avatar of remote user
                        Obx(() => Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              )
                            ]
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(
                              controller.trainerAvatar.value,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )),
                        const SizedBox(height: 24),
                        
                        /// Name and Role
                        Obx(() => Text(
                          controller.trainerName.value,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        const SizedBox(height: 4),
                        Obx(() => Text(
                          controller.trainerRole.value,
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.40),
                            fontSize: 11,
                          ),
                        )),
                        const SizedBox(height: 24),
                        
                        /// Connection status / Loading state
                        Obx(() {
                          final isLoading = controller.isLoadingUrl.value;
                          final status = controller.connectionStatus.value;
                          
                          if (isLoading) {
                            return const Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xffFF00E5)),
                                  strokeWidth: 2,
                                ),
                              ),
                            );
                          }
                          
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: 8,
                                width: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: status == "Connected" ? const Color(0xff00FF87) : Colors.red,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                status,
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.60),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          );
                        }),
                        const SizedBox(height: 24),

                        /// ticking duration counter
                        Obx(() => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.02),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.white.withOpacity(0.06)),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.timer_outlined, color: Color(0xff00E5FF), size: 14),
                              const SizedBox(width: 8),
                              Text(
                                "Duration: ${controller.formattedDuration}",
                                style: GoogleFonts.outfit(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ),

                  const Spacer(),

                  /// 4. GLOWING LAUNCH CALL BUTTON
                  Obx(() {
                    final isReady = controller.jitsiUrl.value.isNotEmpty;
                    
                    return GestureDetector(
                      onTap: isReady ? () => controller.launchJitsiCall() : null,
                      child: Container(
                        height: 56,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(28),
                          gradient: LinearGradient(
                            colors: isReady 
                                ? [const Color(0xffFF00E5), const Color(0xffB100FF)]
                                : [Colors.white10, Colors.white12],
                          ),
                          boxShadow: isReady ? [
                            BoxShadow(
                              color: const Color(0xffFF00E5).withOpacity(0.3),
                              blurRadius: 15,
                              offset: const Offset(0, 4),
                            )
                          ] : null,
                        ),
                        child: Center(
                          child: controller.isLoadingUrl.value
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    strokeWidth: 2,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.videocam_rounded, color: Colors.white, size: 20),
                                    const SizedBox(width: 8),
                                    Text(
                                      isReady ? "Join Live Consultation Room" : "Setting up room...",
                                      style: GoogleFonts.outfit(
                                        color: isReady ? Colors.white : Colors.white24,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),

                  /// 5. CALL TERMINATION BUTTON
                  GestureDetector(
                    onTap: () => controller.endCall(),
                    child: Container(
                      height: 52,
                      width: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red.withOpacity(0.12),
                        border: Border.all(color: Colors.red.withOpacity(0.3)),
                      ),
                      child: const Icon(Icons.call_end_rounded, color: Colors.red, size: 24),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
