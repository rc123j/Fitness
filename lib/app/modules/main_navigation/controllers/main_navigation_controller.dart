import 'package:get/get.dart';
import '../../../services/auth_service.dart';

class MainNavigationController extends GetxController {
  // Active Tab Index
  final selectedIndex = 0.obs;

  // Change tab method
  void changeTab(int index) {
    final authService = Get.find<AuthService>();
    final isExpert = authService.userRole == 'CONSULTANT' || authService.userRole == 'ADMIN';
    final maxIndex = isExpert ? 2 : 3;
    
    if (index > maxIndex) {
      selectedIndex.value = maxIndex;
    } else {
      selectedIndex.value = index;
    }
  }
}
