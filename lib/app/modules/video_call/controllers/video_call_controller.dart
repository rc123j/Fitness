import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../services/api_client.dart';

class VideoCallController extends GetxController {
  final _apiClient = Get.find<ApiClient>();

  // Call controls states
  final isMuted = false.obs;
  final isCameraOff = false.obs;
  final connectionStatus = "Connecting...".obs;

  // Timer states
  final elapsedSeconds = 0.obs;
  Timer? _timer;

  // Call participant info
  final trainerName = "Expert Coach".obs;
  final trainerRole = "Senior Specialist".obs;
  final trainerAvatar = "https://images.unsplash.com/photo-1594744803329-e58b31de215f?q=80&w=200".obs;

  // Jitsi configuration
  final appointmentId = 0.obs;
  final jitsiUrl = "".obs;
  final isLoadingUrl = false.obs;
  final isExpertCaller = false.obs;

  @override
  void onInit() {
    super.onInit();
    final apt = Get.arguments as Map<String, dynamic>?;
    if (apt != null) {
      appointmentId.value = apt['id'] ?? 0;
      
      final consultant = apt['consultant'] ?? {};
      final member = apt['member'] ?? {};
      final user = member['user'] ?? {};

      // If it is loaded by the consultant, target details belong to standard member client.
      if (apt['member'] != null && user['first_name'] != null) {
        isExpertCaller.value = true;
        trainerName.value = "${user['first_name']} ${user['last_name'] ?? ''}";
        trainerRole.value = "Client Profile";
        trainerAvatar.value = "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200";
      } else {
        isExpertCaller.value = false;
        trainerName.value = "${consultant['first_name'] ?? 'Coach'} ${consultant['last_name'] ?? ''}";
        trainerRole.value = "Nutrition Coach";
        trainerAvatar.value = "https://images.unsplash.com/photo-1594744803329-e58b31de215f?q=80&w=200";
      }

      fetchJitsiCallLink();
    }
    startCallTimer();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> fetchJitsiCallLink() async {
    isLoadingUrl.value = true;
    try {
      final response = await _apiClient.get('/api/bookings/${appointmentId.value}/video-token');
      jitsiUrl.value = response.data['jitsiUrl'] ?? '';
      connectionStatus.value = "Connected";
    } catch (e) {
      debugPrint("Error fetching Jitsi Link: $e");
      connectionStatus.value = "Failed to connect";
      Get.snackbar("Connection Error", "Failed to retrieve Jitsi room link.", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoadingUrl.value = false;
    }
  }

  Future<void> launchJitsiCall() async {
    if (jitsiUrl.value.isEmpty) {
      Get.snackbar("Error", "Jitsi room URL is not loaded yet.", snackPosition: SnackPosition.BOTTOM);
      return;
    }
    
    final uri = Uri.parse(jitsiUrl.value);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Get.snackbar("Error", "Could not open browser/Jitsi app.", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to launch call link: $e", snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Starts the stopwatch ticking every second
  void startCallTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedSeconds.value++;
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
  }

  // Toggle Camera
  void toggleCamera() {
    isCameraOff.value = !isCameraOff.value;
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
                "Consultation Ended",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Your consultation session has ended.",
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
