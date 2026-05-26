import 'package:get/get.dart';

class RegisterController extends GetxController {
  final obscurePassword = true.obs;
  final obscureConfirmPassword = true.obs;
  final agreeToTerms = true.obs;

  void togglePasswordVisibility() => obscurePassword.toggle();
  void toggleConfirmPasswordVisibility() => obscureConfirmPassword.toggle();
  void toggleAgreeToTerms() => agreeToTerms.toggle();
}
