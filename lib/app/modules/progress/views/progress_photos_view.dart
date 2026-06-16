import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/progress_controller.dart';

class ProgressPhotosView extends GetView<ProgressController> {
  ProgressPhotosView({super.key});

  // Local state for the interactive Before/After slider position (0.0 to 1.0)
  final sliderValue = 0.50.obs;

  // Image URLs matching the transformation journey
  final String beforeImg = "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=600";
  final String afterImg = "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=600";

  final List<Map<String, String>> timelineData = [
    {
      "day": "Day 1",
      "date": "15 Apr",
      "image": "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=200",
      "type": "before"
    },
    {
      "day": "Day 15",
      "date": "30 Apr",
      "image": "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=200",
      "type": "before"
    },
    {
      "day": "Day 30",
      "date": "15 May",
      "image": "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=200",
      "type": "after"
    },
    {
      "day": "Day 60",
      "date": "14 Jun",
      "image": "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=200",
      "type": "after"
    },
    {
      "day": "Day 90",
      "date": "14 Jul",
      "image": "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?q=80&w=200",
      "type": "after"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          /// BACKGROUND GLOW BLOBS
          Positioned(
            top: -120,
            left: -100,
            child: Container(
              height: 350,
              width: 350,
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
            bottom: -100,
            right: -100,
            child: Container(
              height: 350,
              width: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffB100FF).withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          /// BODY SCROLLABLE
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
                      children: [
                        const SizedBox(height: 10),

                        /// 1. TIMEFRAME SELECTOR ROW
                        buildTimeframeSelector(),
                        const SizedBox(height: 20),

                        /// 2. BEFORE/AFTER SLIDER CARD
                        buildSliderCard(),
                        const SizedBox(height: 20),

                        /// 3. TRANSFORMATION TIMELINE SECTION
                        buildTransformationTimeline(),
                        const SizedBox(height: 24),

                        /// 4. ADD NEW PROGRESS PHOTO GRADIENT BUTTON
                        buildAddPhotoBtn(),
                        const SizedBox(height: 20),

                        /// 5. SECURITY & PRIVACY FOOTER INFO
                        buildPrivacyFooter(),
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
          /// Back Button
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

          /// Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Progress Photos",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "See your transformation journey",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),

          /// Picture/Gallery Icon
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.03),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xffFF00E5).withOpacity(0.25),
                width: 0.8,
              ),
            ),
            child: const Icon(Icons.photo_library_rounded, color: Color(0xffFF00E5), size: 16),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 1. TIMEFRAME SELECTOR ROW
  /// ----------------------------------------------------
  Widget buildTimeframeSelector() {
    final list = ["30 Days", "90 Days", "All Time"];
    return Obx(() {
      final selected = controller.selectedPhotoTimeframe.value;
      return Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0xff0B0817).withOpacity(0.55),
          border: Border.all(
            color: Colors.white.withOpacity(0.04),
            width: 1.0,
          ),
        ),
        child: Row(
          children: list.map((time) {
            final isActive = time == selected;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.selectedPhotoTimeframe.value = time,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: isActive
                        ? const Color(0xffB100FF).withOpacity(0.08)
                        : Colors.transparent,
                    border: Border.all(
                      color: isActive
                          ? const Color(0xffB100FF)
                          : Colors.transparent,
                      width: 1.0,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      time,
                      style: GoogleFonts.outfit(
                        color: isActive ? Colors.white : Colors.white.withOpacity(0.40),
                        fontSize: 12,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    });
  }

  /// ----------------------------------------------------
  /// 2. BEFORE/AFTER SLIDER CARD
  /// ----------------------------------------------------
  Widget buildSliderCard() {
    return LayoutBuilder(builder: (context, constraints) {
      double width = constraints.maxWidth;
      double height = width * 1.25; // Keep beautiful portrait aspect ratio

      return Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.04), width: 1.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Obx(() {
            double currentPos = sliderValue.value;

            return Stack(
              children: [
                /// Left Side Image (BEFORE)
                Positioned.fill(
                  child: Image.network(
                    beforeImg,
                    fit: BoxFit.cover,
                  ),
                ),

                /// Left Border/Label Highlights
                Positioned(
                  top: 16,
                  left: 16,
                  child: Text(
                    "BEFORE",
                    style: GoogleFonts.outfit(
                      color: const Color(0xffFF00E5),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),

                /// Right Side Image (AFTER) with ClipRect
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.centerRight,
                    widthFactor: 1.0 - currentPos,
                    child: Image.network(
                      afterImg,
                      fit: BoxFit.cover,
                      // Ensure the image width remains identical to scale properly
                      width: width,
                      height: height,
                    ),
                  ),
                ),

                /// Right Label Highlight
                Positioned(
                  top: 16,
                  right: 16,
                  child: Text(
                    "AFTER",
                    style: GoogleFonts.outfit(
                      color: const Color(0xffFF7A00),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),

                /// Vertical Drag Border Line
                Positioned(
                  top: 0,
                  bottom: 0,
                  left: width * currentPos - 1.5,
                  child: Container(
                    width: 3,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffFF00E5),
                          Color(0xffFF7A00),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                ),

                /// Center Interactive Slider Handle Node
                Positioned(
                  top: height / 2 - 20,
                  left: width * currentPos - 20,
                  child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onHorizontalDragUpdate: (details) {
                      double newPos = (details.localPosition.dx + (width * currentPos - 20)) / width;
                      sliderValue.value = newPos.clamp(0.05, 0.95);
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xff090414),
                        border: Border.all(
                          color: const Color(0xffFF00E5),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xffFF00E5).withOpacity(0.35),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.keyboard_arrow_left_rounded, color: Colors.white, size: 12),
                            Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white, size: 12),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                /// Bottom Tags (Before / After Details)
                /// Before Tag (Bottom Left)
                Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xff0B0817).withOpacity(0.75),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                        width: 0.8,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, color: Color(0xffFF00E5), size: 10),
                            const SizedBox(width: 6),
                            Text(
                              "Day 1",
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "15 Apr 2024",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.50),
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// After Tag (Bottom Right)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xff0B0817).withOpacity(0.75),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.08),
                        width: 0.8,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_today_rounded, color: Color(0xffFF7A00), size: 10),
                            const SizedBox(width: 6),
                            Text(
                              "Day 30",
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "15 May 2024",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.50),
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      );
    });
  }

  /// ----------------------------------------------------
  /// 3. TRANSFORMATION TIMELINE SECTION
  /// ----------------------------------------------------
  Widget buildTransformationTimeline() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.history_toggle_off_rounded, color: Color(0xffFF00E5), size: 16),
                const SizedBox(width: 8),
                Text(
                  "Your Transformation Timeline",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          /// Horizontal Timeline Row List
          SizedBox(
            height: 140,
            child: Obx(() {
              final activeIdx = controller.activeTimelineIndex.value;
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: timelineData.length,
                itemBuilder: (context, index) {
                  final data = timelineData[index];
                  final isActive = index == activeIdx;
                  final isBefore = data["type"] == "before";

                  Color borderClr = isActive
                      ? (isBefore ? const Color(0xffFF00E5) : const Color(0xffFF7A00))
                      : Colors.transparent;

                  return GestureDetector(
                    onTap: () => controller.activeTimelineIndex.value = index,
                    child: Container(
                      width: 82,
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isActive ? borderClr : Colors.white.withOpacity(0.04),
                          width: isActive ? 1.5 : 0.8,
                        ),
                        color: Colors.white.withOpacity(0.01),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Column(
                          children: [
                            /// Photo Thumbnail
                            Expanded(
                              child: Image.network(
                                data["image"]!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),

                            /// Details
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Column(
                                children: [
                                  Text(
                                    data["day"]!,
                                    style: GoogleFonts.outfit(
                                      color: isActive
                                          ? (isBefore ? const Color(0xffFF00E5) : const Color(0xffFF7A00))
                                          : Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    data["date"]!,
                                    style: GoogleFonts.inter(
                                      color: Colors.white.withOpacity(0.40),
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
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 12),

          /// Timeline indicator dots
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Obx(() {
                final isActive = index == controller.activeTimelineIndex.value;
                return Container(
                  height: 6,
                  width: isActive ? 12 : 6,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: isActive ? const Color(0xffB100FF) : Colors.white.withOpacity(0.12),
                  ),
                );
              });
            }),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// 4. ADD NEW PROGRESS PHOTO GRADIENT BUTTON
  /// ----------------------------------------------------
  Widget buildAddPhotoBtn() {
    return Container(
      width: double.infinity,
      height: 52,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: const LinearGradient(
          colors: [
            Color(0xffFF00E5),
            Color(0xffFF7A00),
          ],
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white24,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                "Add New Progress Photo",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ----------------------------------------------------
  /// 5. SECURITY & PRIVACY FOOTER INFO
  /// ----------------------------------------------------
  Widget buildPrivacyFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(Icons.verified_user_rounded, color: Color(0xffB100FF), size: 16),
        const SizedBox(width: 8),
        Text(
          "Your photos are private and secure.\nOnly you can see your progress.",
          style: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.40),
            fontSize: 9,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
