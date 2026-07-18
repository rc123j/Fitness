import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/register/bindings/register_binding.dart';
import '../modules/register/views/register_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/goal/views/goal_selection_screen.dart';
import '../modules/meal/bindings/meal_binding.dart';
import '../modules/meal/views/meal_view.dart';
import '../modules/meal/views/meal_detail_view.dart';
import '../modules/meal/views/nutrition_history_view.dart';
import '../modules/progress/bindings/progress_binding.dart';
import '../modules/progress/views/progress_view.dart';
import '../modules/progress/views/progress_photos_view.dart';
import '../modules/wallet/bindings/wallet_binding.dart';
import '../modules/wallet/views/wallet_view.dart';
import '../modules/booking/bindings/booking_binding.dart';
import '../modules/booking/views/booking_view.dart';
import '../modules/profile/bindings/profile_binding.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/profile/views/settings_view.dart';
import '../modules/supplements/bindings/supplement_binding.dart';
import '../modules/supplements/views/supplement_view.dart';
import '../modules/family/bindings/family_binding.dart';
import '../modules/family/views/family_view.dart';
import '../modules/social/bindings/social_binding.dart';
import '../modules/social/views/social_feed_view.dart';
import '../modules/social/views/create_post_view.dart';
import '../modules/reminders/bindings/reminder_binding.dart';
import '../modules/reminders/views/reminder_view.dart';
import '../modules/notifications/bindings/notification_binding.dart';
import '../modules/notifications/views/notification_view.dart';
import '../modules/health_tips/bindings/health_tips_binding.dart';
import '../modules/health_tips/views/health_tips_view.dart';
import '../modules/video_call/bindings/video_call_binding.dart';
import '../modules/video_call/views/video_call_view.dart';
import '../modules/main_navigation/bindings/main_navigation_binding.dart';
import '../modules/main_navigation/views/main_navigation_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),
    GetPage(
      name: _Paths.GOAL_SELECTION,
      page: () => const GoalSelectionScreen(),
    ),
    GetPage(
      name: _Paths.MEAL_PLAN,
      page: () => const MealView(),
      binding: MealBinding(),
    ),
    GetPage(
      name: _Paths.MEAL_DETAIL,
      page: () => const MealDetailView(),
      binding: MealBinding(),
    ),
    GetPage(
      name: _Paths.PROGRESS,
      page: () => const ProgressView(),
      binding: ProgressBinding(),
    ),
    GetPage(
      name: _Paths.PROGRESS_PHOTOS,
      page: () => ProgressPhotosView(),
      binding: ProgressBinding(),
    ),
    GetPage(
      name: _Paths.REWARDS_HUB,
      page: () => const WalletView(),
      binding: WalletBinding(),
    ),
    GetPage(
      name: _Paths.BOOKING,
      page: () => const BookingView(),
      binding: BookingBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.SUPPLEMENTS,
      page: () => const SupplementView(),
      binding: SupplementBinding(),
    ),
    GetPage(
      name: _Paths.FAMILY,
      page: () => const FamilyView(),
      binding: FamilyBinding(),
    ),
    GetPage(
      name: _Paths.SOCIAL_FEED,
      page: () => const SocialFeedView(),
      binding: SocialBinding(),
    ),
    GetPage(
      name: _Paths.CREATE_POST,
      page: () => const CreatePostView(),
      binding: SocialBinding(),
    ),
    GetPage(
      name: _Paths.REMINDERS,
      page: () => const ReminderView(),
      binding: ReminderBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationView(),
      binding: NotificationBinding(),
    ),
    GetPage(
      name: _Paths.HEALTH_TIPS,
      page: () => const HealthTipsView(),
      binding: HealthTipsBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO_CALL,
      page: () => const VideoCallView(),
      binding: VideoCallBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_NAVIGATION,
      page: () => const MainNavigationView(),
      binding: MainNavigationBinding(),
    ),
    GetPage(
      name: _Paths.CALORIE_HISTORY,
      page: () => const NutritionHistoryView(),
      binding: MealBinding(),
    ),
  ];
}
