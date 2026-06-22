import 'package:get/get.dart';
import '../controllers/health_tips_controller.dart';

class HealthTipsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HealthTipsController>(
      () => HealthTipsController(),
    );
  }
}
