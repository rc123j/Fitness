import 'package:get/get.dart';
import '../../profile/controllers/profile_controller.dart';

class StreakController extends GetxController {
  final ProfileController profileController = Get.find<ProfileController>();

  int get currentStreak => profileController.streakCount.value;
  int get longestStreak => profileController.longestStreak.value;
  
  int get progressToMilestone => currentStreak % 30;
  double get progressPercentage => (currentStreak % 30) / 30;
}
