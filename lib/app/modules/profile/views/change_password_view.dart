import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/profile_controller.dart';

class ChangePasswordView extends GetView<ProfileController> {
  ChangePasswordView({super.key});

  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Change Password",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Obx(() {
          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Create New Password",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Your new password must be different from previous used passwords.",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      _buildLabel("Current Password"),
                      _buildPasswordField(_oldPasswordController, "Enter current password"),
                      const SizedBox(height: 20),
                      
                      _buildLabel("New Password"),
                      _buildPasswordField(_newPasswordController, "Enter new password"),
                      const SizedBox(height: 20),
                      
                      _buildLabel("Confirm New Password"),
                      _buildPasswordField(_confirmPasswordController, "Confirm your new password", isConfirm: true),
                      
                      const SizedBox(height: 48),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value ? null : () async {
                            if (_formKey.currentState!.validate()) {
                              final success = await controller.changePassword(
                                _oldPasswordController.text,
                                _newPasswordController.text,
                              );
                              if (success) {
                                Get.back();
                                Get.snackbar(
                                  "Success",
                                  "Password updated successfully!",
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: const Color(0xff24963F),
                                  colorText: Colors.white,
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xffFF00E5),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            "Update Password",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (controller.isLoading.value)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xffFF00E5),
                    ),
                  ),
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          color: Colors.white.withOpacity(0.9),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String hint, {bool isConfirm = false}) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      style: GoogleFonts.inter(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: Colors.white.withOpacity(0.3)),
        filled: true,
        fillColor: const Color(0xff0B0817).withOpacity(0.55),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.04)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.04)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xffFF00E5)),
        ),
        prefixIcon: Icon(
          Icons.lock_outline_rounded,
          color: Colors.white.withOpacity(0.4),
          size: 20,
        ),
      ),
      validator: (val) {
        if (val == null || val.isEmpty) return "This field is required";
        if (val.length < 6) return "Password must be at least 6 characters";
        if (isConfirm && val != _newPasswordController.text) {
          return "Passwords do not match";
        }
        return null;
      },
    );
  }
}
