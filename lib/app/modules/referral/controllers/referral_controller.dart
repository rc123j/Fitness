import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';

class ReferralController extends GetxController {
  final _apiClient = Get.find<ApiClient>();

  final isLoading = false.obs;
  final referralCode = ''.obs;
  final shareLink = ''.obs;
  final shareText = ''.obs;
  final totalReferrals = 0.obs;
  final totalPointsEarned = 0.obs;
  final rewardPerReferral = 50.obs;

  final referralHistory = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReferralData();
  }

  Future<void> fetchReferralData() async {
    isLoading.value = true;
    try {
      final codeRes = await _apiClient.get(ApiEndpoints.myReferralCode);
      if (codeRes.statusCode == 200 && codeRes.data != null) {
        referralCode.value = codeRes.data['referral_code']?.toString() ?? '';
        shareLink.value = codeRes.data['share_link']?.toString() ?? '';
        shareText.value = codeRes.data['share_text']?.toString() ?? '';
        totalReferrals.value = (codeRes.data['total_referrals'] as num?)?.toInt() ?? 0;
        totalPointsEarned.value = (codeRes.data['total_points_earned'] as num?)?.toInt() ?? 0;
        rewardPerReferral.value = (codeRes.data['reward_per_referral'] as num?)?.toInt() ?? 50;
      }

      final histRes = await _apiClient.get(ApiEndpoints.referralHistory);
      if (histRes.statusCode == 200 && histRes.data != null) {
        final List raw = histRes.data['history'] ?? [];
        referralHistory.value = raw.map((e) => Map<String, dynamic>.from(e)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching referral data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void copyReferralCode() {
    if (referralCode.value.isEmpty) return;
    Clipboard.setData(ClipboardData(text: referralCode.value));
    Get.snackbar(
      "Code Copied! 📋",
      "Referral code ${referralCode.value} copied to clipboard.",
      backgroundColor: const Color(0xff00FF87).withValues(alpha: 0.9),
      colorText: Colors.black,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 2),
    );
  }

  void shareReferralCode() {
    if (referralCode.value.isEmpty) return;
    final msg = shareText.value.isNotEmpty
        ? shareText.value
        : "Join me on NutriFit for healthy living! Use my code ${referralCode.value} on signup to get a 50 FitPoints bonus! ${shareLink.value}";
    
    try {
      Share.share(msg, subject: "Join me on NutriFit & Get 50 FitPoints!");
    } catch (e) {
      copyReferralCode();
    }
  }
}
