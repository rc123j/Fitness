import 'package:get/get.dart';

class MainNavigationController extends GetxController {
  // Active Tab Index
  final selectedIndex = 0.obs;

  // Change tab method
  void changeTab(int index) {
    selectedIndex.value = index;
  }
}
