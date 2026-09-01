import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/iap_service.dart';

class MembershipController extends GetxController {
  final IapService _iapService = Get.find<IapService>();

  // Selected plan index
  final selectedPlanIndex = 0.obs;

  // Countdown timer variables
  final days = 2.obs;
  final hours = 23.obs;
  final minutes = 58.obs;
  final seconds = 44.obs;
  
  Timer? _timer;

  // Carousel variables
  late final PageController pageController;
  final pageOffset = 0.0.obs;

  // Get dynamic plans and loading status from billing service
  List<Map<String, dynamic>> get plans => _iapService.availablePlans;
  bool get isLoading => _iapService.isLoading.value;

  @override
  void onInit() {
    super.onInit();
    
    // Initialize PageController centered on the first plan
    pageController = PageController(viewportFraction: 0.6, initialPage: 0);
    pageController.addListener(() {
      pageOffset.value = pageController.page ?? 0.0;
    });

    _startCountdown();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds.value > 0) {
        seconds.value--;
      } else {
        seconds.value = 59;
        if (minutes.value > 0) {
          minutes.value--;
        } else {
          minutes.value = 59;
          if (hours.value > 0) {
            hours.value--;
          } else {
            hours.value = 23;
            if (days.value > 0) {
              days.value--;
            } else {
              // Timer expired, reset to a fresh 3 days for demo consistency
              days.value = 2;
              hours.value = 23;
              minutes.value = 58;
              seconds.value = 44;
            }
          }
        }
      }
    });
  }

  void selectPlan(int index) {
    if (index >= 0 && index < plans.length) {
      selectedPlanIndex.value = index;
    }
  }

  // Trigger Purchase flow via billing service
  Future<void> purchaseSelectedPlan() async {
    if (plans.isEmpty) {
      Get.snackbar('Error', 'No subscription plans available right now.');
      return;
    }

    final index = selectedPlanIndex.value;
    if (index < 0 || index >= plans.length) return;

    final selectedPlan = plans[index];
    await _iapService.buyPlan(selectedPlan);
  }

  // Helper to refresh plans from backend/stores
  Future<void> refreshPlans() async {
    await _iapService.fetchAvailablePlans();
  }
}
