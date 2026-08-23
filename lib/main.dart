import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/modules/login/controllers/login_controller.dart';
import 'app/modules/register/controllers/register_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/services/api_client.dart';
import 'app/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  // GetStorage().erase();

  Get.put(AuthService(), permanent: true);
  await Get.putAsync(() => ApiClient().init(), permanent: true);

  // Register auth controllers permanently so they are NEVER deleted during navigation
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
