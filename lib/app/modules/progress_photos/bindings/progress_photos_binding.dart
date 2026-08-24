import 'package:get/get.dart';
import '../../progress/controllers/progress_controller.dart';

class ProgressPhotosBinding extends Bindings {
  @override
  void dependencies() {
    // Reuses the same ProgressController instance the Progress tab uses
    // (already registered by MainNavigationBinding in the normal app flow).
    Get.lazyPut<ProgressController>(() => ProgressController());
  }
}
