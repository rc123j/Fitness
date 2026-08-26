import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dio/dio.dart';
import 'package:jitsi_meet_flutter_sdk/jitsi_meet_flutter_sdk.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../services/api_client.dart';
import '../../../services/auth_service.dart';

class VideoCallController extends GetxController {
  final _apiClient = Get.find<ApiClient>();
  final _authService = Get.find<AuthService>();
  final _jitsiMeet = JitsiMeet();

  // Call controls states
  final isMuted = false.obs;
  final isCameraOff = false.obs;
  final connectionStatus = "Setting up room...".obs;
  // True once the native Jitsi call view has actually been joined — used
  // to tell a "left before joining" back-tap apart from a real hang-up.
  final isInCall = false.obs;
  bool _hasEnded = false;

  // Timer states
  final elapsedSeconds = 0.obs;
  Timer? _timer;

  // Call participant info
  final trainerName = "Expert Coach".obs;
  final trainerRole = "Senior Specialist".obs;
  final trainerAvatar =
      "https://images.unsplash.com/photo-1594744803329-e58b31de215f?q=80&w=200"
          .obs;

  // Jitsi configuration
  final appointmentId = 0.obs;
  final jitsiUrl = "".obs;
  final roomName = "".obs;
  final isLoadingUrl = false.obs;
  final isExpertCaller = false.obs;
  // Member-only: true while polling because the expert hasn't opened the
  // room yet — the member can never start the call themselves, only join
  // once it's actually live.
  final waitingForExpertToStart = false.obs;
  // Expert-only: set when the session's time window hasn't arrived yet (or
  // has already passed) — the call simply can't be opened outside it.
  final outsideSessionWindow = false.obs;
  Timer? _waitPollTimer;

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
        trainerAvatar.value =
            "https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=200";
      } else {
        isExpertCaller.value = false;
        trainerName.value =
            "${consultant['first_name'] ?? 'Coach'} ${consultant['last_name'] ?? ''}";
        trainerRole.value = "Nutrition Coach";
        trainerAvatar.value =
            "https://images.unsplash.com/photo-1594744803329-e58b31de215f?q=80&w=200";
      }

      fetchJitsiCallLink();
    }
    // Timer starts once the call is actually joined (conferenceJoined),
    // not while the pre-join lobby is just sitting there.
  }

  @override
  void onClose() {
    _timer?.cancel();
    _waitPollTimer?.cancel();
    if (isInCall.value) _jitsiMeet.hangUp();
    super.onClose();
  }

  /// Fetches (and, for the expert within the session window, opens) the
  /// video room. The backend enforces who can start it and when — this
  /// just reflects whatever it says:
  ///  - expert too early/late  -> outsideSessionWindow, no retry (won't
  ///    change until they come back within the window)
  ///  - member before the expert has started -> waitingForExpertToStart,
  ///    polls every few seconds so Join lights up the moment it opens
  ///  - anything else -> plain failure, no auto-retry
  Future<void> fetchJitsiCallLink({bool isPoll = false}) async {
    if (!isPoll) isLoadingUrl.value = true;
    try {
      final response = await _apiClient.get(
        '/api/bookings/${appointmentId.value}/video-token',
      );
      jitsiUrl.value = response.data['jitsiUrl'] ?? '';
      roomName.value = response.data['roomName'] ?? '';
      connectionStatus.value = "Ready to join";
      waitingForExpertToStart.value = false;
      outsideSessionWindow.value = false;
      _waitPollTimer?.cancel();
    } catch (e) {
      String? errorCode;
      String? message;
      if (e is DioException) {
        final data = e.response?.data;
        if (data is Map) {
          errorCode = data['error']?.toString();
          message = data['message']?.toString();
        }
      }

      if (errorCode == 'CALL_NOT_STARTED') {
        connectionStatus.value = "Waiting for expert to start the call...";
        waitingForExpertToStart.value = true;
        _waitPollTimer ??= Timer.periodic(
          const Duration(seconds: 6),
          (_) => fetchJitsiCallLink(isPoll: true),
        );
      } else if (errorCode == 'OUTSIDE_SESSION_WINDOW') {
        connectionStatus.value =
            message ?? "This session's time window has passed.";
        outsideSessionWindow.value = true;
        _waitPollTimer?.cancel();
      } else {
        debugPrint("Error fetching Jitsi Link: $e");
        connectionStatus.value = "Failed to connect";
        if (!isPoll) {
          Get.snackbar(
            "Connection Error",
            message ?? "Failed to retrieve the video room. Please try again.",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } finally {
      if (!isPoll) isLoadingUrl.value = false;
    }
  }

  /// Launches the real, embedded Jitsi Meet call (native SDK view — not an
  /// external browser link) for this appointment's room.
  Future<void> joinCall() async {
    if (roomName.value.isEmpty) {
      Get.snackbar(
        "Error",
        "Video room is not ready yet.",
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Explicitly request camera/mic up front instead of leaving it to the
    // native Jitsi SDK to ask mid-join — on some heavily customized Android
    // builds (seen on Vivo devices) letting the native side trigger its own
    // first-time permission prompt can hang the main thread instead of
    // showing the dialog, which looks like the app freezing/crashing.
    final statuses = await [Permission.camera, Permission.microphone].request();
    final cameraOk = statuses[Permission.camera]?.isGranted ?? false;
    final micOk = statuses[Permission.microphone]?.isGranted ?? false;

    if (!cameraOk || !micOk) {
      Get.snackbar(
        "Permission Required",
        "Camera and microphone access are needed to join the call. Please enable them in app settings.",
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 4),
      );
      final permanentlyDenied = statuses.values.any(
        (s) => s.isPermanentlyDenied,
      );
      if (permanentlyDenied) await openAppSettings();
      return;
    }

    final displayName =
        _authService.userEmail?.split('@').first ?? 'Nutri Shape User';

    final options = JitsiMeetConferenceOptions(
      serverURL: "https://meet.jit.si",
      room: roomName.value,
      userInfo: JitsiMeetUserInfo(displayName: displayName),
      configOverrides: {
        "startWithAudioMuted": false,
        "startWithVideoMuted": false,
        "subject": "Nutri Shape Consultation",
      },
      featureFlags: {
        "welcomepage.enabled": false,
        "invite.enabled": false,
        "add-people.enabled": false,
        "calendar.enabled": false,
        "call-integration.enabled": false,
        // In-app chat is handled by our own Chat screen, not Jitsi's.
        "chat.enabled": false,
        "meeting-name.enabled": false,
      },
    );

    await _jitsiMeet.join(
      options,
      JitsiMeetEventListener(
        conferenceJoined: (url) {
          connectionStatus.value = "Connected";
          if (!isInCall.value) {
            isInCall.value = true;
            startCallTimer();
          }
        },
        conferenceTerminated: (url, error) => _handleNativeCallEnded(),
        readyToClose: () => _handleNativeCallEnded(),
      ),
    );
  }

  /// Called when the native Jitsi call view reports it's done (hang up,
  /// dropped connection, etc). Shows the session summary the same way a
  /// manual "end call" tap does, but only once even if both callbacks fire.
  void _handleNativeCallEnded() {
    if (_hasEnded || !isInCall.value) return;
    endCall();
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

  /// Used by the lobby's back/hang-up buttons — leaving before ever
  /// actually joining the call should just close the screen, not show the
  /// "Consultation Ended" summary for a call that never happened.
  void handleExitTap() {
    if (isInCall.value) {
      endCall();
    } else {
      Get.back();
    }
  }

  // End consultation session
  void endCall() {
    if (_hasEnded) return;
    _hasEnded = true;

    _timer?.cancel();
    if (isInCall.value) {
      isInCall.value = false;
      _jitsiMeet.hangUp();
    }
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
                child: const Icon(
                  Icons.call_end_rounded,
                  color: Colors.red,
                  size: 28,
                ),
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
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
