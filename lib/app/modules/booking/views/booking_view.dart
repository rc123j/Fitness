import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/booking_controller.dart';
import '../../../widgets/premium_layout_components.dart';
import 'booking_date_time_view.dart';
import 'my_sessions_view.dart';

class BookingView extends GetView<BookingController> {
  BookingView({super.key});

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      bottomNavigationBar: _buildBottomBookButton(),
      body: Obx(() {
        final expert = controller.currentExpert;
        if (expert.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xffFF00E5)),
          );
        }

        return Stack(
          children: [
            /// 1. SCROLLABLE CONTENT PORTION
            Positioned.fill(
              child: Scrollbar(
                controller: _scrollController,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      /// COVER IMAGE & GRADIENT & BADGE STACKED INSIDE SCROLLVIEW
                      Stack(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.38,
                            width: double.infinity,
                            child: Image.network(
                              expert["image"] ??
                                  'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=600',
                              fit: BoxFit.cover,
                            ),
                          ),

                          /// Dark gradient overlay at top of image (for floating buttons visibility)
                          Positioned.fill(
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.4),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                          ),

                          /// Gallery count badge (bottom right of cover photo)
                          Positioned(
                            bottom:
                                50, // high enough to not get fully overlapped by floating card
                            right: 16,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.photo_library_outlined,
                                    color: Colors.white,
                                    size: 12,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "1/5",
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      /// OVERLAPPING SHIFTED COLUMN
                      Transform.translate(
                        offset: const Offset(0, -40),
                        child: Column(
                          children: [
                            /// FLOATING CARD (White background, Zomato style)
                            Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 16,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  /// Name & Rating row
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          expert["name"] ?? '',
                                          style: GoogleFonts.outfit(
                                            color: Colors.black,
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(
                                                0xff24963F,
                                              ), // Zomato green
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "${expert["rating"] ?? 4.9}",
                                                  style: GoogleFonts.inter(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(width: 2),
                                                const Icon(
                                                  Icons.star_rounded,
                                                  color: Colors.white,
                                                  size: 12,
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${expert["reviewsCount"] ?? 150} ratings",
                                            style: GoogleFonts.inter(
                                              color: Colors.black.withOpacity(
                                                0.4,
                                              ),
                                              fontSize: 9,
                                              decoration:
                                                  TextDecoration.underline,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),

                                  /// Distance / Location Row
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Colors.black.withOpacity(0.6),
                                        size: 14,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "${expert["location"] ?? 'Online'} · Verified Coach",
                                        style: GoogleFonts.inter(
                                          color: Colors.black.withOpacity(0.6),
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Icon(
                                        Icons.arrow_drop_down,
                                        color: Colors.black.withOpacity(0.6),
                                        size: 16,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),

                                  /// Role / Price Info
                                  Text(
                                    "${expert["role"] ?? 'Fitness Specialist'} | ₹500 for Session",
                                    style: GoogleFonts.inter(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Divider(
                                    color: Colors.black.withOpacity(0.08),
                                    height: 1,
                                  ),
                                  const SizedBox(height: 12),

                                  /// Bottom Buttons inside card (Open, Directions, Call)
                                  Row(
                                    children: [
                                      /// Open/Available tag
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.03),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(
                                              "Available",
                                              style: GoogleFonts.inter(
                                                color: const Color(0xff24963F),
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              " Today",
                                              style: GoogleFonts.inter(
                                                color: Colors.black,
                                                fontSize: 12,
                                              ),
                                            ),
                                            const SizedBox(width: 4),
                                            const Icon(
                                              Icons.keyboard_arrow_down_rounded,
                                              color: Colors.black54,
                                              size: 14,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),

                            /// ABOUT, SERVICES, FEATURES
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  buildAboutTabContent(),
                                  const SizedBox(height: 24),
                                  _buildFeaturesSection(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ), // Bottom padding to compensate for translation
                    ],
                  ),
                ),
              ),
            ),

            /// 2. FLOATING FIXED TOP ACTIONS (Back button, Share, Favorite)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              right: 16,
              child: Row(
                children: [
                  /// Favorite Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 8),

                  /// Share Icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.share_outlined,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What You'll Get",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.75,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          children: [
            _buildFeatureCard(
              "https://images.unsplash.com/photo-1517836357463-d25dfeac3438?w=500&q=80",
              "Personalized Plan",
              "Fitness | Nutrition",
            ),
            _buildFeatureCard(
              "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=500&q=80",
              "1-on-1 Video",
              "Live | Guidance",
            ),
            _buildFeatureCard(
              "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=500&q=80",
              "Ongoing Support",
              "24/7 | Chat",
            ),
            _buildFeatureCard(
              "https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=500&q=80",
              "Nutrition Guide",
              "Meals | Diet",
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeatureCard(String image, String title, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff121212),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                image,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 10,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.bookmark_border_rounded,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBookButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff06010F),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () => Get.to(() => const BookingDateTimeView()),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xffFF00E5),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: Text(
            "Book a Session",
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // Removed buildHeader

  /// ----------------------------------------------------
  /// 1. SEARCH BAR & FILTERS
  /// ----------------------------------------------------
  Widget buildSearchBar() {
    return Row(
      children: [
        /// Search Field Input
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: const Color(0xff0B0817).withOpacity(0.55),
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
                width: 1.0,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: [
                Icon(
                  Icons.search_rounded,
                  color: Colors.white.withOpacity(0.40),
                  size: 18,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (val) => controller.searchQuery.value = val,
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search experts, skills...",
                      hintStyle: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.35),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),

        /// Filter Trigger Button
        Container(
          height: 48,
          width: 82,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xff0B0817).withOpacity(0.55),
            border: Border.all(
              color: Colors.white.withOpacity(0.05),
              width: 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Filters",
                style: GoogleFonts.outfit(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.tune_rounded,
                color: Colors.white.withOpacity(0.75),
                size: 14,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// ----------------------------------------------------
  /// 2. CIRCULAR EXPERT SELECTOR ROW
  /// ----------------------------------------------------
  Widget buildExpertSelectorRow() {
    return SizedBox(
      height: 98,
      child: Obx(() {
        final activeIdx = controller.selectedExpertIndex.value;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          itemCount: controller.experts.length,
          itemBuilder: (context, index) {
            final expert = controller.experts[index];
            final isActive = index == activeIdx;

            return GestureDetector(
              onTap: () => controller.selectedExpertIndex.value = index,
              child: Container(
                margin: const EdgeInsets.only(right: 14),
                child: Column(
                  children: [
                    /// Circle Avatar container
                    Stack(
                      children: [
                        Container(
                          height: 56,
                          width: 56,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isActive
                                  ? const Color(0xffB100FF)
                                  : Colors.white.withOpacity(0.06),
                              width: isActive ? 1.8 : 0.8,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Image.network(
                                expert["image"] ??
                                    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=200',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        /// Online Dot
                        Positioned(
                          bottom: 2,
                          right: 2,
                          child: Container(
                            height: 10,
                            width: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xff00FF87),
                              border: Border.all(
                                color: const Color(0xff06010F),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),

                    /// Name
                    Text(
                      expert["name"]!.split(" ")[0],
                      style: GoogleFonts.outfit(
                        color: isActive
                            ? Colors.white
                            : Colors.white.withOpacity(0.55),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 1),

                    /// Role
                    Text(
                      expert["role"]!,
                      style: GoogleFonts.inter(
                        color: isActive
                            ? const Color(0xffB100FF)
                            : Colors.white.withOpacity(0.30),
                        fontSize: 7,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // Removed buildExpertOverviewCard and buildStatBadge

  /// ----------------------------------------------------
  // Removed Tab Selector Navigation Cards

  /// ----------------------------------------------------
  /// 5. DYNAMIC TAB: ABOUT DOCK
  /// ----------------------------------------------------
  // Removed buildStatsRow

  Widget buildAboutTabContent() {
    final expert = controller.currentExpert;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Container Box
        Container(
          padding: const EdgeInsets.all(16),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xff0B0817).withOpacity(0.55),
            border: Border.all(
              color: Colors.white.withOpacity(0.03),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "About Me",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                expert["aboutText"]!,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.55),
                  fontSize: 10,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),

              /// Credentials Sublist
              Column(
                children: (expert["credentials"] as List<String>).map((cred) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.verified_user_outlined,
                          color: Color(0xffFF00E5),
                          size: 12,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          cred,
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.70),
                            fontSize: 9,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Removed Services & Pricing section, and Reviews and Gallery sections

  /// ----------------------------------------------------
  /// 6. BOOK A SESSION CALENDAR (DATE/TIME GRID SELECTOR)
  /// ----------------------------------------------------
  Widget buildBookSessionCalendar() {
    return Obx(() {
      final dates = controller.dates;
      final expert = controller.currentExpert;
      final expertName = expert["name"] ?? 'Expert';

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Book a Session",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          if (dates.isEmpty) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff0B0817).withOpacity(0.55),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.03),
                  width: 0.8,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    color: Colors.white.withOpacity(0.2),
                    size: 28,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "No Available Slots",
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "$expertName hasn't added any slots yet. Check back soon!",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ] else ...[
            /// Horizontal Dates Row
            SizedBox(
              height: 72,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: dates.length,
                itemBuilder: (context, index) {
                  final item = dates[index];
                  return Obx(() {
                    final isActive =
                        index == controller.selectedDateIndex.value;
                    Color borderClr = isActive
                        ? const Color(0xffB100FF)
                        : Colors.white.withOpacity(0.04);
                    Color fillClr = isActive
                        ? const Color(0xffB100FF).withOpacity(0.08)
                        : Colors.white.withOpacity(0.01);

                    return GestureDetector(
                      onTap: () => controller.selectedDateIndex.value = index,
                      child: Container(
                        width: 68,
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: fillClr,
                          border: Border.all(
                            color: borderClr,
                            width: isActive ? 1.5 : 0.8,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              item["day"]!,
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.40),
                                fontSize: 8,
                              ),
                            ),
                            Text(
                              item["date"]!,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              item["slots"]!,
                              style: GoogleFonts.inter(
                                color: isActive
                                    ? const Color(0xffB100FF)
                                    : Colors.white.withOpacity(0.30),
                                fontSize: 7,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 12),

            /// Horizontal Time slots Row
            SizedBox(
              height: 38,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: controller.timeSlots.length,
                itemBuilder: (context, index) {
                  final slot = controller.timeSlots[index];
                  return Obx(() {
                    final isActive =
                        index == controller.selectedTimeSlotIndex.value;
                    Color borderClr = isActive
                        ? const Color(0xffB100FF)
                        : Colors.white.withOpacity(0.04);
                    Color fillClr = isActive
                        ? const Color(0xffB100FF).withOpacity(0.08)
                        : Colors.white.withOpacity(0.01);

                    return GestureDetector(
                      onTap: () =>
                          controller.selectedTimeSlotIndex.value = index,
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: fillClr,
                          border: Border.all(
                            color: borderClr,
                            width: isActive ? 1.5 : 0.8,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            slot,
                            style: GoogleFonts.outfit(
                              color: isActive
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.50),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
            const SizedBox(height: 20),

            /// Gradient Book Now button
            Obx(() {
              final expert = controller.currentExpert;
              if (expert.isEmpty ||
                  expert["services"] == null ||
                  (expert["services"] as List).isEmpty) {
                return const SizedBox.shrink();
              }
              final price = (expert["services"] as List)[0]["price"];
              final duration = (expert["services"] as List)[0]["duration"];

              return Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  gradient: const LinearGradient(
                    colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => controller.bookSession(),
                    borderRadius: BorderRadius.circular(14),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Book Now - ₹$price",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              Text(
                                "$duration Video Call",
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.85),
                                  fontSize: 9,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.videocam_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ],
        ],
      );
    });
  }

  /// ----------------------------------------------------
  /// 7. CLIENT REVIEWS SECTION
  /// ----------------------------------------------------
  Widget buildClientReviewsTrack() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "What Clients Say",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "View All Reviews",
              style: GoogleFonts.inter(
                color: const Color(0xffFF00E5),
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        /// Row item of reviews
        Obx(() {
          final expert = controller.currentExpert;
          if (expert.isEmpty || expert["reviews"] == null)
            return const SizedBox.shrink();
          return SizedBox(
            height: 98,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: (expert["reviews"] as List).length,
              itemBuilder: (context, index) {
                final rev = expert["reviews"][index];
                return Container(
                  width: 250,
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: const Color(0xff0B0817).withOpacity(0.55),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.03),
                      width: 0.8,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          rev["image"]!,
                          height: 32,
                          width: 32,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  rev["name"]!,
                                  style: GoogleFonts.outfit(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: List.generate(5, (index) {
                                    return const Icon(
                                      Icons.star_rounded,
                                      color: Color(0xffFFD700),
                                      size: 8,
                                    );
                                  }),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Expanded(
                              child: Text(
                                rev["comment"]!,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.50),
                                  fontSize: 8,
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
      ],
    );
  }

  Widget buildClientAppointmentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Your Booked Sessions",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          if (controller.clientAppointments.isEmpty) {
            return Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xff090414),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.04)),
              ),
              child: Center(
                child: Text(
                  "No upcoming booked sessions",
                  style: GoogleFonts.inter(color: Colors.white30, fontSize: 12),
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.clientAppointments.length,
            itemBuilder: (context, index) {
              final apt = controller.clientAppointments[index];
              final consultant = apt['consultant'] ?? {};
              final slot = apt['slot'] ?? {};
              final dateStr = slot['start_time'] ?? '';

              DateTime? startTime;
              if (dateStr.isNotEmpty) {
                startTime = DateTime.parse(dateStr).toLocal();
              }

              final formattedDate = startTime != null
                  ? DateFormat('EEEE, dd MMM').format(startTime)
                  : 'N/A';
              final formattedTime = startTime != null
                  ? DateFormat('hh:mm a').format(startTime)
                  : 'N/A';
              final status = apt['status'] as String? ?? 'PENDING';

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xff090414),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.04)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Consultation with ${consultant['first_name'] ?? 'Coach'} ${consultant['last_name'] ?? ''}",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color:
                                (status == 'APPROVED'
                                        ? const Color(0xff00FF87)
                                        : Colors.amber)
                                    .withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color:
                                  (status == 'APPROVED'
                                          ? const Color(0xff00FF87)
                                          : Colors.amber)
                                      .withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            status,
                            style: GoogleFonts.inter(
                              color: status == 'APPROVED'
                                  ? const Color(0xff00FF87)
                                  : Colors.amber,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_month_rounded,
                          color: Color(0xff00E5FF),
                          size: 14,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          "$formattedDate at $formattedTime",
                          style: GoogleFonts.inter(
                            color: Colors.white70,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () =>
                                _showRescheduleDialog(context, apt),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xffFF00E5),
                              side: const BorderSide(color: Color(0xffFF00E5)),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                            ),
                            child: Text(
                              "Reschedule",
                              style: GoogleFonts.outfit(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        if (status == 'APPROVED') ...[
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () =>
                                  Get.toNamed('/video-call', arguments: apt),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff00FF87),
                                foregroundColor: Colors.black,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.videocam_rounded, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Join Call",
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        }),
      ],
    );
  }

  void _showRescheduleDialog(
    BuildContext context,
    Map<String, dynamic> appointment,
  ) {
    final consultant = appointment['consultant'] ?? {};
    final consultantId = consultant['id'];

    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xff090414),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Reschedule Session",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Select a new available slot with this coach.",
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 16),
              Obx(() {
                final slots = controller.allAvailableSlots
                    .where((s) => s['consultant_id'] == consultantId)
                    .toList();
                if (slots.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: Text(
                        "No other available slots at the moment.",
                        style: GoogleFonts.inter(
                          color: Colors.white30,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                }

                return Container(
                  constraints: const BoxConstraints(maxHeight: 250),
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: slots.length,
                    itemBuilder: (context, index) {
                      final slot = slots[index];
                      final start = DateTime.parse(
                        slot['start_time'],
                      ).toLocal();
                      final formatted = DateFormat(
                        'dd MMM, hh:mm a',
                      ).format(start);

                      return ListTile(
                        title: Text(
                          formatted,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Color(0xffFF00E5),
                          size: 14,
                        ),
                        onTap: () {
                          controller.rescheduleAppointment(
                            appointment['id'],
                            slot['id'],
                          );
                          Get.back();
                        },
                      );
                    },
                  ),
                );
              }),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    "Cancel",
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ----------------------------------------------------
/// CUSTOM PAINTER FOR EXPERT RINGS
/// ----------------------------------------------------
class ExpertBackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 3.5;
    double radius = size.width / 2 - strokeWidth;
    Offset center = Offset(size.width / 2, size.height / 2);

    // Glowing border ring - LinearGradient (safe)
    Paint ringPaint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Color(0xffB100FF),
          Color(0xffFF00E5),
          Color(0xffFF7A00),
          Color(0xffB100FF),
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    // Glowing shadow - concentric circles (safe)
    for (double i = 1; i <= 3; i++) {
      canvas.drawCircle(
        center,
        radius,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5 + (i * 2.0)
          ..color = const Color(0xffB100FF).withOpacity(0.12 / i),
      );
    }
    canvas.drawCircle(center, radius, ringPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
