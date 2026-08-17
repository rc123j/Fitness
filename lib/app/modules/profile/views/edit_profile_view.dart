import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/profile_controller.dart';

class EditProfileView extends GetView<ProfileController> {
  EditProfileView({super.key}) {
    // Populate form fields with current values from controller
    final nameParts = controller.username.value.split(' ');
    _firstNameController.text = nameParts.isNotEmpty ? nameParts[0] : '';
    _lastNameController.text = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    _emailController.text = controller.email.value;
    _phoneController.text = controller.phone.value;
  }

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

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
          "Edit Profile",
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /// Profile Picture
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: const Color(0xffB100FF), width: 2),
                              image: const DecorationImage(
                                image: NetworkImage("https://images.unsplash.com/photo-1570295999919-56ceb5ecca61?q=80&w=200"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: Color(0xffFF00E5),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      
                      _buildInputField(
                        "First Name", 
                        _firstNameController, 
                        Icons.person_outline_rounded
                      ),
                      const SizedBox(height: 20),

                      _buildInputField(
                        "Last Name", 
                        _lastNameController, 
                        Icons.person_outline_rounded
                      ),
                      const SizedBox(height: 20),
                      
                      _buildInputField(
                        "Email Address", 
                        _emailController, 
                        Icons.mail_outline_rounded,
                        isReadOnly: true
                      ),
                      const SizedBox(height: 20),
                      
                      _buildInputField(
                        "Phone Number", 
                        _phoneController, 
                        Icons.phone_outlined
                      ),
                      
                      const SizedBox(height: 48),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.isLoading.value ? null : () async {
                            if (_formKey.currentState!.validate()) {
                              final success = await controller.updateProfileDetails(
                                firstName: _firstNameController.text.trim(),
                                lastName: _lastNameController.text.trim(),
                                phone: _phoneController.text.trim(),
                              );
                              if (success) {
                                Get.back();
                                Get.snackbar(
                                  "Success",
                                  "Profile updated successfully.",
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
                            "Save Changes",
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

  Widget _buildInputField(
    String label, 
    TextEditingController controller, 
    IconData icon, {
    bool isNumber = false,
    bool isReadOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
          child: Text(
            label,
            style: GoogleFonts.outfit(
              color: Colors.white.withOpacity(0.9),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          readOnly: isReadOnly,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          style: GoogleFonts.inter(
            color: isReadOnly ? Colors.white.withOpacity(0.5) : Colors.white,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: isReadOnly 
                ? const Color(0xff0B0817).withOpacity(0.25)
                : const Color(0xff0B0817).withOpacity(0.55),
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
              icon,
              color: Colors.white.withOpacity(0.4),
              size: 20,
            ),
          ),
          validator: (val) {
            if (val == null || val.isEmpty) return "This field is required";
            return null;
          },
        ),
      ],
    );
  }
}
