import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MembershipController extends GetxController {
  // Selected plan index (0 = Monthly, 1 = Annual, 2 = Lifetime)
  final selectedPlanIndex = 1.obs;

  // Countdown timer variables
  final days = 2.obs;
  final hours = 23.obs;
  final minutes = 58.obs;
  final seconds = 44.obs;
  
  Timer? _timer;

  // Carousel variables
  final PageController pageController = PageController(viewportFraction: 0.5, initialPage: 2);
  final pageOffset = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
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
    selectedPlanIndex.value = index;
  }

  void purchasePlan() {
    final planNames = ["Monthly Plan", "Annual Plan", "Lifetime Plan"];
    final planPrice = ["₹599", "₹3,999", "₹9,999"];
    final selectedName = planNames[selectedPlanIndex.value];
    final selectedPrice = planPrice[selectedPlanIndex.value];

    Get.dialog(
      Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xff090414),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.6),
                blurRadius: 30,
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xff00FF87).withOpacity(0.12),
                  ),
                  child: const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xff00FF87),
                    size: 40,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  "Order Processed",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "You have successfully subscribed to the $selectedName for $selectedPrice.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffFF00E5),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 44),
                  ),
                  child: const Text("Continue"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
