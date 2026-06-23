import 'package:get/get.dart';
import '../controllers/main_navigation_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../meal/controllers/meal_controller.dart';
import '../../progress/controllers/progress_controller.dart';
import '../../social/controllers/social_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    // Shared shell controller
    Get.lazyPut<MainNavigationController>(
      () => MainNavigationController(),
    );

    // Tab controllers
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<MealController>(
      () => MealController(),
    );
    Get.lazyPut<ProgressController>(
      () => ProgressController(),
    );
    Get.lazyPut<SocialController>(
      () => SocialController(),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(),
    );
  }
}
