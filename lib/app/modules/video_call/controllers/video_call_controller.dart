import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class VideoCallController extends GetxController {
  // Call controls states
  final isMuted = false.obs;
  final isCameraOff = false.obs;
  final connectionStatus = "Connecting...".obs;

  // Timer states
  final elapsedSeconds = 0.obs;
  Timer? _timer;

  // Trainer Info (passed or default)
  final trainerName = "Dr. Olivia Bennett".obs;
  final trainerRole = "Senior Sports Nutritionist".obs;
  final trainerAvatar = "https://images.unsplash.com/photo-1594744803329-e58b31de215f?q=80&w=200".obs;

  @override
  void onInit() {
    super.onInit();
    startCallTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // Starts the stopwatch ticking every second
  void startCallTimer() {
    connectionStatus.value = "Connecting...";
    Future.delayed(const Duration(seconds: 2), () {
      connectionStatus.value = "Connected";
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        elapsedSeconds.value++;
      });
    });
  }

  // Format seconds to MM:SS
  String get formattedDuration {
    final minutes = (elapsedSeconds.value ~/ 60).toString().padLeft(2, '0');
    final seconds = (elapsedSeconds.value % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  // Toggle Mute
  void toggleMute() {
    isMuted.value = !isMuted.value;
    Get.snackbar(
      isMuted.value ? "Mic Muted" : "Mic Unmuted",
      isMuted.value ? "Your microphone is now muted." : "Your microphone is active.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff0B0817).withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  // Toggle Camera
  void toggleCamera() {
    isCameraOff.value = !isCameraOff.value;
    Get.snackbar(
      isCameraOff.value ? "Camera Disabled" : "Camera Enabled",
      isCameraOff.value ? "Your self-video stream is hidden." : "Your camera stream is visible.",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xff0B0817).withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  // End consultation session
  void endCall() {
    _timer?.cancel();
    final sessionDuration = formattedDuration;

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xff090414),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.withOpacity(0.12),
                ),
                child: const Icon(Icons.call_end_rounded, color: Colors.red, size: 28),
              ),
              const SizedBox(height: 18),
              Text(
                "Consultation Completed",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Thank you for consulting with ${trainerName.value}.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.50),
                  fontSize: 10.5,
                ),
              ),
              const SizedBox(height: 18),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.02),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Session Duration",
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.40),
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      sessionDuration,
                      style: GoogleFonts.outfit(
                        color: const Color(0xff00FF87),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 40,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xffFF00E5), Color(0xffB100FF)],
                    ),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Get.back(); // close dialog
                      Get.back(); // return to dashboard
                    },
                    child: Text(
                      "Done",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 12,
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
      barrierDismissible: false,
    );
  }
}
