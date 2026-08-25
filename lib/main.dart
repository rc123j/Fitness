import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/modules/login/controllers/login_controller.dart';
import 'app/modules/notifications/controllers/notification_controller.dart';
import 'app/modules/register/controllers/register_controller.dart';
import 'app/modules/reminders/controllers/reminder_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/services/api_client.dart';
import 'app/services/auth_service.dart';
import 'app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await NotificationService.instance.initialize();

  // GetStorage().erase();

  Get.put(AuthService(), permanent: true);
  await Get.putAsync(() => ApiClient().init(), permanent: true);

  // Register core controllers permanently
  Get.put(NotificationController(), permanent: true);
  Get.put(ReminderController(), permanent: true);
  Get.put(LoginController(), permanent: true);
  Get.put(RegisterController(), permanent: true);

  runApp(
    GetMaterialApp(
      title: "Nutri Shape",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}
