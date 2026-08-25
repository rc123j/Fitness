import 'dart:async';
import 'package:get/get.dart';
import '../../../services/api_client.dart';
import '../../../services/auth_service.dart';

/// Simple REST + polling chat for a single booked appointment — no
/// websocket layer, just a timer refetching messages while this
/// controller is alive (i.e. while the chat screen is open).
class ChatController extends GetxController {
  final _apiClient = Get.find<ApiClient>();
  final _authService = Get.find<AuthService>();

  late final int appointmentId;
  late final String otherPartyName;

  final messages = <Map<String, dynamic>>[].obs;
  final isLoading = true.obs;
  final isSending = false.obs;

  Timer? _pollTimer;

  int? get myUserId => _authService.userId;

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map? ?? {};
    appointmentId = args['appointmentId'] as int;
    otherPartyName = args['otherPartyName'] as String? ?? 'Chat';

    fetchMessages(silent: false);
    _pollTimer = Timer.periodic(
      const Duration(seconds: 4),
      (_) => fetchMessages(silent: true),
    );
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }

  Future<void> fetchMessages({required bool silent}) async {
    if (!silent) isLoading.value = true;
    try {
      final res = await _apiClient.get('/api/bookings/$appointmentId/messages');
      final list = List<dynamic>.from(res.data);
      messages.value = list.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (_) {
      // Silent failures on poll ticks — don't spam the user with errors
      // for a background refresh; the next tick will retry.
    } finally {
      if (!silent) isLoading.value = false;
    }
  }

  Future<void> sendMessage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || isSending.value) return;

    isSending.value = true;
    try {
      final res = await _apiClient.post(
        '/api/bookings/$appointmentId/messages',
        data: {'body': trimmed},
      );
      messages.add(Map<String, dynamic>.from(res.data));
    } catch (e) {
      Get.snackbar(
        'Message Failed',
        'Could not send your message. Please try again.',
      );
    } finally {
      isSending.value = false;
    }
  }
}
