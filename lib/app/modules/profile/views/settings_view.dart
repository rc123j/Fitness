import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/profile_controller.dart';
import '../../../widgets/premium_layout_components.dart';

class SettingsView extends GetView<ProfileController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          /// Background Glow Blobs
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffB100FF).withOpacity(0.05),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// Scrollable content
          SafeArea(
            child: Column(
              children: [
                /// Header Row
                buildHeader(),

                /// Scrollable body
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        /// 1. Go Premium Card
                        buildGoPremiumCard(),
                        const SizedBox(height: 24),

                        /// 2. Account Section
                        sectionHeader("Account"),
                        const SizedBox(height: 8),
                        buildAccountGroup(),
                        const SizedBox(height: 24),

                        /// 3. Preferences Section
                        sectionHeader("Preferences"),
                        const SizedBox(height: 8),
                        buildPreferencesGroup(),
                        const SizedBox(height: 24),

                        /// 4. Support & More Section
                        sectionHeader("Support & More"),
                        const SizedBox(height: 8),
                        buildSupportGroup(),
                        const SizedBox(height: 24),

                        /// 5. Log Out Button
                        buildLogoutBtn(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// HEADER WIDGET
  /// ----------------------------------------------------
  Widget buildHeader() {
    return const PremiumAppBar(
      title: "Settings",
      subtitle: "Configure your app & preferences",
    );
  }

  /// ----------------------------------------------------
  /// 1. GO PREMIUM CARD
  /// ----------------------------------------------------
  Widget buildGoPremiumCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: const Color(0xffFF7A00).withOpacity(0.20),
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          /// Glowing Diamond Icon
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xffB100FF).withOpacity(0.12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffB100FF).withOpacity(0.20),
                  blurRadius: 15,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: const Icon(
              Icons.diamond_rounded,
              color: Color(0xffB100FF),
              size: 28,
            ),
          ),
          const SizedBox(width: 16),

          /// Text Descriptions
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Go Premium",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Unlock advanced features and faster results.",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 10,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 12),

                /// Upgrade Now button
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xffFF00E5),
                          Color(0xffFF7A00),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffFF00E5).withOpacity(0.30),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Text(
                      "Upgrade Now",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Right Arrow
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.white.withOpacity(0.30),
            size: 20,
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// SECTION HEADERS
  /// ----------------------------------------------------
  Widget sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Text(
        title,
        style: GoogleFonts.outfit(
          color: Colors.white.withOpacity(0.50),
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  /// ----------------------------------------------------
  /// 2. ACCOUNT LIST GROUP
  /// ----------------------------------------------------
  Widget buildAccountGroup() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0B0817).withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          buildSettingsRowItem(
            icon: Icons.person_outline_rounded,
            title: "Personal Information",
            subtitle: "Update your personal details",
            onTap: () {},
          ),
          buildDivider(),
          buildSettingsRowItem(
            icon: Icons.lock_outline_rounded,
            title: "Change Password",
            subtitle: "Update your account password",
            onTap: () {},
          ),
          buildDivider(),
          buildSettingsRowItem(
            icon: Icons.mail_outline_rounded,
            title: "Email & Phone",
            subtitle: "Manage your contact details",
            onTap: () {},
          ),
          buildDivider(),
          buildSettingsRowItem(
            icon: Icons.link_rounded,
            title: "Connected Accounts",
            subtitle: "Manage Google, Apple & more",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 3. PREFERENCES LIST GROUP
  /// ----------------------------------------------------
  Widget buildPreferencesGroup() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0B0817).withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          /// Units
          Obx(() {
            return buildSettingsRowItem(
              icon: Icons.straighten_rounded,
              title: "Units",
              subtitle: "Choose between Metric & Imperial",
              trailing: Text(
                controller.isMetric.value ? "Metric" : "Imperial",
                style: GoogleFonts.outfit(
                  color: const Color(0xffFF00E5),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap: () => controller.toggleMetricImperial(),
            );
          }),
          buildDivider(),

          /// Notifications
          Obx(() {
            return buildSettingsRowItem(
              icon: Icons.notifications_none_rounded,
              title: "Notifications",
              subtitle: "Manage your notification preferences",
              trailing: SizedBox(
                height: 24,
                width: 40,
                child: Switch(
                  value: controller.notificationsEnabled.value,
                  activeColor: const Color(0xffFF00E5),
                  activeTrackColor: const Color(0xffFF00E5).withOpacity(0.20),
                  inactiveThumbColor: Colors.white30,
                  inactiveTrackColor: Colors.white10,
                  onChanged: (val) => controller.notificationsEnabled.value = val,
                ),
              ),
              onTap: () {},
            );
          }),
          buildDivider(),

          /// Reminders
          buildSettingsRowItem(
            icon: Icons.access_time_rounded,
            title: "Reminders",
            subtitle: "Set workout, meal & water reminders",
            onTap: () => Get.toNamed('/reminders'),
          ),
          buildDivider(),

          /// Privacy
          buildSettingsRowItem(
            icon: Icons.security_rounded,
            title: "Privacy",
            subtitle: "Manage your privacy settings",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 4. SUPPORT LIST GROUP
  /// ----------------------------------------------------
  Widget buildSupportGroup() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0B0817).withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          buildSettingsRowItem(
            icon: Icons.help_outline_rounded,
            title: "Help Center",
            subtitle: "Get help and support",
            onTap: () {},
          ),
          buildDivider(),
          buildSettingsRowItem(
            icon: Icons.mail_outline_rounded,
            title: "Contact Us",
            subtitle: "We're here to help",
            onTap: () {},
          ),
          buildDivider(),
          buildSettingsRowItem(
            icon: Icons.star_border_rounded,
            title: "Rate NutriFit",
            subtitle: "Share your feedback",
            onTap: () {},
          ),
          buildDivider(),
          buildSettingsRowItem(
            icon: Icons.info_outline_rounded,
            title: "About NutriFit",
            subtitle: "Version 2.3.1",
            onTap: () {},
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 5. LOG OUT BUTTON
  /// ----------------------------------------------------
  Widget buildLogoutBtn() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff0B0817).withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.red.withOpacity(0.25),
          width: 1.0,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => controller.logout(),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.logout_rounded, color: Colors.red, size: 20),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Log Out",
                        style: GoogleFonts.outfit(
                          color: Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        "Sign out from your account",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.30),
                          fontSize: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(color: Colors.white.withOpacity(0.04), height: 1),
    );
  }

  Widget buildSettingsRowItem({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(icon, color: const Color(0xffB100FF), size: 18),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.40),
                        fontSize: 8,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                trailing,
                const SizedBox(width: 8),
              ],
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.white.withOpacity(0.20),
                size: 11,
              ),
            ],
          ),
        ),
      ),
    );
  }

}
