import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class MainNavigationController extends GetxController {
  // Active Tab Index
  final selectedIndex = 0.obs;

  // Whether the bottom nav bar is shown — hidden while scrolling forward
  // through content, shown again when scrolling back toward the top.
  final isNavBarVisible = true.obs;

  // Change tab method
  void changeTab(int index) {
    final authService = Get.find<AuthService>();
    final isExpert =
        authService.userRole == 'CONSULTANT' || authService.userRole == 'ADMIN';
    final maxIndex = isExpert ? 2 : 3;

    if (index > maxIndex) {
      selectedIndex.value = maxIndex;
    } else {
      selectedIndex.value = index;
    }
    isNavBarVisible.value = true;
  }
}
