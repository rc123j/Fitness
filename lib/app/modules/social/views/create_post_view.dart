import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/social_controller.dart';

class CreatePostView extends GetView<SocialController> {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    // A selection of high-quality mock workout/nutrition images from Unsplash to choose as upload mockups
    final List<String> mockGallery = [
      "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=300", // Lifting weights
      "https://images.unsplash.com/photo-1498837167922-ddd27525d352?q=80&w=300", // Salad prep
      "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?q=80&w=300", // Meal prep containers
      "https://images.unsplash.com/photo-1506126613408-eca07ce68773?q=80&w=300", // Yoga stretching
      "https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?q=80&w=300", // Running stairs
      "https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?q=80&w=300"  // Abs training
    ];

    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          /// BACKGROUND NEON GLOW BLOBS
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              height: 280,
              width: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffFF00E5).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -100,
            child: Container(
              height: 320,
              width: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xff00E5FF).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// SCROLLABLE COMPOSE UI
          SafeArea(
            child: Column(
              children: [
                /// HEADER
                buildHeader(),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),

                        /// 1. CAPTION TEXTBOX (Glassmorphic)
                        buildCaptionField(),
                        const SizedBox(height: 20),

                        /// 2. POST TYPE DROPDOWN
                        buildPostTypeSelector(context),
                        const SizedBox(height: 20),

                        /// 3. CHOOSE ACHIEVEMENT BADGE (Pulse selections)
                        Text(
                          "Attach Achievement Badge",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        buildBadgeSelector(),
                        const SizedBox(height: 20),

                        /// 4. MOCK PHOTO GALLERY SELECTOR
                        Text(
                          "Select Photo Upload",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Tap to choose a photo depicting your daily achievement.",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.35),
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 12),
                        buildMockGallerySelector(mockGallery),
                        const SizedBox(height: 30),

                        /// 5. PUBLISH CTA BUTTON
                        buildPublishButton(),
                        const SizedBox(height: 20),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          /// Back Arrow
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.03),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.08),
                  width: 0.8,
                ),
              ),
              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 16),
            ),
          ),
          const SizedBox(width: 14),

          Text(
            "Create Narrative",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 1. CAPTION TEXTBOX
  /// ----------------------------------------------------
  Widget buildCaptionField() {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: const Color(0xff0B0817).withOpacity(0.55),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.0),
      ),
      padding: const EdgeInsets.all(14),
      child: TextField(
        maxLines: null,
        onChanged: (val) => controller.captionInput.value = val,
        style: GoogleFonts.inter(color: Colors.white, fontSize: 13, height: 1.45),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "What transformation milestones did you conquer today? Share details about your workout sessions, clean nutrition adherence, and weight milestones...",
          hintStyle: GoogleFonts.inter(color: Colors.white24, fontSize: 12),
        ),
      ),
    );
  }

  /// ----------------------------------------------------
  /// 2. POST TYPE DROPDOWN
  /// ----------------------------------------------------
  Widget buildPostTypeSelector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Post Category",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 48,
          width: double.infinity,
          decoration: BoxDecoration(
            color: const Color(0xff0B0817).withOpacity(0.55),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.05), width: 0.8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: const Color(0xff090414),
            ),
            child: Obx(() => DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.postTypeInput.value,
                    onChanged: (val) {
                      if (val != null) controller.postTypeInput.value = val;
                    },
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white30),
                    items: controller.postTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                  ),
                )),
          ),
        ),
      ],
    );
  }

  /// ----------------------------------------------------
  /// 3. CHOOSE ACHIEVEMENT BADGE
  /// ----------------------------------------------------
  Widget buildBadgeSelector() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: controller.badgesList.length,
        itemBuilder: (context, index) {
          final badge = controller.badgesList[index];
          final badgeColor = Color(int.parse(badge["color"]!.replaceAll('0x', ''), radix: 16));

          return Obx(() {
            final isActive = controller.selectedBadgeIndex.value == index;
            final isNone = badge["title"] == "None";

            return GestureDetector(
              onTap: () => controller.selectedBadgeIndex.value = index,
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: isActive ? badgeColor.withOpacity(0.12) : const Color(0xff0B0817).withOpacity(0.55),
                  border: Border.all(
                    color: isActive ? badgeColor : Colors.white.withOpacity(0.04),
                    width: 1.0,
                  ),
                ),
                child: Row(
                  children: [
                    if (!isNone) ...[
                      Icon(Icons.emoji_events_rounded, color: isActive ? badgeColor : Colors.white24, size: 12),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      badge["title"]!,
                      style: GoogleFonts.outfit(
                        color: isActive ? Colors.white : Colors.white.withOpacity(0.40),
                        fontSize: 10,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  /// ----------------------------------------------------
  /// 4. MOCK PHOTO GALLERY SELECTOR
  /// ----------------------------------------------------
  Widget buildMockGallerySelector(List<String> gallery) {
    return SizedBox(
      height: 94,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: gallery.length,
        itemBuilder: (context, index) {
          final imageUrl = gallery[index];

          return Obx(() {
            final isSelected = controller.imageInput.value == imageUrl;
            // Set first image as selected if none is chosen
            if (controller.imageInput.value.isEmpty && index == 0) {
              Future.microtask(() => controller.imageInput.value = imageUrl);
            }

            return GestureDetector(
              onTap: () => controller.imageInput.value = imageUrl,
              child: Container(
                width: 94,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? const Color(0xffFF00E5) : Colors.white.withOpacity(0.04),
                    width: isSelected ? 2.0 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: const Color(0xffFF00E5).withOpacity(0.12),
                            blurRadius: 10,
                          ),
                        ]
                      : null,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.network(imageUrl, fit: BoxFit.cover),
                ),
              ),
            );
          });
        },
      ),
    );
  }

  /// ----------------------------------------------------
  /// 5. PUBLISH CTA BUTTON
  /// ----------------------------------------------------
  Widget buildPublishButton() {
    return Container(
      height: 48,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [
            Color(0xffFF00E5),
            Color(0xffFF7A00),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffFF00E5).withOpacity(0.35),
            blurRadius: 15,
            spreadRadius: 1,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            controller.createPost();
            if (controller.captionInput.value.trim().isNotEmpty) {
              Get.back(); // navigate back to feed
            }
          },
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.share_rounded, color: Colors.white, size: 16),
                const SizedBox(width: 8),
                Text(
                  "Publish to Social Room",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
