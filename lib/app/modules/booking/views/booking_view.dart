import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/booking_controller.dart';
import '../../../widgets/premium_layout_components.dart';

class BookingView extends GetView<BookingController> {
  const BookingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          /// BACKGROUND BLUR BLOBS
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              height: 320,
              width: 320,
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
          Positioned(
            bottom: -80,
            right: -100,
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

          /// SCROLLABLE VIEW PORT
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

                        /// 1. SEARCH BAR & FILTERS
                        buildSearchBar(),
                        const SizedBox(height: 20),

                        /// 2. CIRCULAR EXPERT SELECTOR ROW
                        buildExpertSelectorRow(),
                        const SizedBox(height: 20),

                        /// 3. SELECTED EXPERT OVERVIEW CARD
                        buildExpertOverviewCard(),
                        const SizedBox(height: 20),

                        /// 4. TAB CONTROLS (ABOUT, SERVICES, REVIEWS, GALLERY)
                        buildTabSelector(),
                        const SizedBox(height: 20),

                        /// 5. ACTIVE TAB DYNAMIC VIEWS
                        Obx(() {
                          final currentTab = controller.activeTab.value;
                          if (currentTab == "About") {
                            return buildAboutTabContent();
                          } else if (currentTab == "Services") {
                            return buildServicesTabContent();
                          } else if (currentTab == "Reviews") {
                            return buildReviewsTabContent();
                          } else {
                            return buildGalleryTabContent();
                          }
                        }),
                        const SizedBox(height: 24),

                        /// 6. BOOK A SESSION DATE/TIME CALENDAR SELECTOR
                        buildBookSessionCalendar(),
                        const SizedBox(height: 24),

                        /// 7. CLIENT REVIEWS SECTION
                        buildClientReviewsTrack(),
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
    return PremiumAppBar(
      title: "Experts & Booking",
      subtitle: "Find expert guidance. Book. Get results.",
      trailing: Container(
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
        child: const Icon(Icons.calendar_today_rounded, color: Colors.white, size: 16),
      ),
    );
  }

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
                Icon(Icons.search_rounded, color: Colors.white.withOpacity(0.40), size: 18),
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
              Icon(Icons.tune_rounded, color: Colors.white.withOpacity(0.75), size: 14),
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
                              color: isActive ? const Color(0xffB100FF) : Colors.white.withOpacity(0.06),
                              width: isActive ? 1.8 : 0.8,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(28),
                              child: Image.network(
                                expert["image"]!,
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
                              border: Border.all(color: const Color(0xff06010F), width: 1.5),
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
                        color: isActive ? Colors.white : Colors.white.withOpacity(0.55),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 1),

                    /// Role
                    Text(
                      expert["role"]!,
                      style: GoogleFonts.inter(
                        color: isActive ? const Color(0xffB100FF) : Colors.white.withOpacity(0.30),
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

  /// ----------------------------------------------------
  /// 3. SELECTED EXPERT OVERVIEW CARD
  /// ----------------------------------------------------
  Widget buildExpertOverviewCard() {
    return Container(
      height: 194,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Obx(() {
          final expert = controller.currentExpert;

          return Stack(
            children: [
              /// Left Graphic glowing circular ring (with Expert Image inside)
              Positioned(
                left: -15,
                top: 0,
                bottom: 0,
                child: Center(
                  child: CustomPaint(
                    size: const Size(160, 160),
                    painter: ExpertBackdropPainter(),
                  ),
                ),
              ),

              /// Image
              Positioned(
                left: 10,
                top: 25,
                bottom: 20,
                child: SizedBox(
                  width: 110,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      expert["image"]!,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),

              /// Right details list
              Positioned(
                left: 134,
                top: 14,
                right: 12,
                bottom: 12,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// Verification & Rating row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: const Color(0xffB100FF).withOpacity(0.12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.verified_user_rounded, color: Color(0xffB100FF), size: 10),
                              const SizedBox(width: 4),
                              Text(
                                "Verified Expert",
                                style: GoogleFonts.outfit(
                                  color: const Color(0xffB100FF),
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Color(0xffFFD700), size: 12),
                            const SizedBox(width: 3),
                            Text(
                              "${expert["rating"]} (${expert["reviewsCount"]} reviews)",
                              style: GoogleFonts.inter(
                                color: Colors.white.withOpacity(0.50),
                                fontSize: 8,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    /// Coach name & role
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text(
                              expert["name"]!,
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(Icons.verified_rounded, color: Color(0xffFF00E5), size: 14),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          expert["role"]!,
                          style: GoogleFonts.outfit(
                            color: const Color(0xffFF00E5),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    /// Stats Row
                    Row(
                      children: [
                        /// Experience
                        buildStatBadge(Icons.emoji_events_rounded, expert["experience"]!, "Experience"),
                        const SizedBox(width: 10),
                        /// Clients
                        buildStatBadge(Icons.people_rounded, expert["clients"]!, "Helped"),
                        const SizedBox(width: 10),
                        /// Location
                        buildStatBadge(Icons.location_on_rounded, expert["location"]!.split(",")[0], "Online"),
                      ],
                    ),

                    /// Bio Description snippet
                    Text(
                      expert["bio"]!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.50),
                        fontSize: 8,
                        height: 1.25,
                      ),
                    ),

                    /// Scrollable Tags Row
                    SizedBox(
                      height: 18,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        children: (expert["tags"] as List<String>).map((tag) {
                          Color activeColor = tag.contains("Weight") || tag.contains("Recomp")
                              ? const Color(0xffFF7A00)
                              : const Color(0xffB100FF);
                          return Container(
                            margin: const EdgeInsets.only(right: 6),
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: activeColor.withOpacity(0.05),
                              border: Border.all(color: activeColor.withOpacity(0.20), width: 0.8),
                            ),
                            child: Center(
                              child: Text(
                                tag,
                                style: GoogleFonts.inter(
                                  color: activeColor,
                                  fontSize: 7,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget buildStatBadge(IconData icon, String title, String sub) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xffFF00E5).withOpacity(0.60), size: 10),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 8,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              sub,
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.35),
                fontSize: 6,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// ----------------------------------------------------
  /// 4. TAB CONTROLS (ABOUT, SERVICES, REVIEWS, GALLERY)
  /// ----------------------------------------------------
  Widget buildTabSelector() {
    final tabs = ["About", "Services", "Reviews", "Gallery"];
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
      child: Obx(() {
        final active = controller.activeTab.value;
        return Row(
          children: tabs.map((tab) {
            final isActive = tab == active;
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.activeTab.value = tab,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
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
                      tab,
                      style: GoogleFonts.outfit(
                        color: isActive ? Colors.white : Colors.white.withOpacity(0.40),
                        fontSize: 11,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  /// ----------------------------------------------------
  /// 5. DYNAMIC TAB: ABOUT DOCK
  /// ----------------------------------------------------
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
                        const Icon(Icons.verified_user_outlined, color: Color(0xffFF00E5), size: 12),
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
        const SizedBox(height: 20),

        /// Services List inside About
        buildServicesTabContent(),
      ],
    );
  }

  /// DYNAMIC TAB: SERVICES DOCK
  Widget buildServicesTabContent() {
    final expert = controller.currentExpert;
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Services & Pricing",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "View All",
                style: GoogleFonts.inter(
                  color: const Color(0xffFF00E5),
                  fontSize: 9,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          /// List of items
          Column(
            children: (expert["services"] as List<Map<String, dynamic>>).map((srv) {
              IconData icon = Icons.videocam_rounded;
              Color clr = const Color(0xffB100FF);

              if (srv["type"] == "chat") {
                icon = Icons.chat_bubble_rounded;
                clr = const Color(0xffFF7A00);
              } else if (srv["type"] == "plan") {
                icon = Icons.calendar_month_rounded;
                clr = const Color(0xffFF00E5);
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white.withOpacity(0.01),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.03),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: clr.withOpacity(0.12),
                      ),
                      child: Icon(icon, color: clr, size: 14),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            srv["title"],
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            srv["duration"],
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.40),
                              fontSize: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "₹${srv["price"]}",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  /// DYNAMIC TAB: REVIEWS DOCK
  Widget buildReviewsTabContent() {
    final expert = controller.currentExpert;
    return Column(
      children: (expert["reviews"] as List<Map<String, dynamic>>).map((rev) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
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
                child: Image.network(rev["image"]!, height: 32, width: 32, fit: BoxFit.cover),
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
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: List.generate(5, (index) {
                            return const Icon(Icons.star_rounded, color: Color(0xffFFD700), size: 10);
                          }),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      rev["comment"]!,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.50),
                        fontSize: 9,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  /// DYNAMIC TAB: GALLERY DOCK
  Widget buildGalleryTabContent() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.0,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Image.network(
            "https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=200",
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  /// ----------------------------------------------------
  /// 6. BOOK A SESSION CALENDAR (DATE/TIME GRID SELECTOR)
  /// ----------------------------------------------------
  Widget buildBookSessionCalendar() {
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

        /// Horizontal Dates Row
        SizedBox(
          height: 72,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: controller.dates.length,
            itemBuilder: (context, index) {
              final item = controller.dates[index];
              return Obx(() {
                final isActive = index == controller.selectedDateIndex.value;
                Color borderClr = isActive ? const Color(0xffB100FF) : Colors.white.withOpacity(0.04);
                Color fillClr = isActive ? const Color(0xffB100FF).withOpacity(0.08) : Colors.white.withOpacity(0.01);

                return GestureDetector(
                  onTap: () => controller.selectedDateIndex.value = index,
                  child: Container(
                    width: 68,
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: fillClr,
                      border: Border.all(color: borderClr, width: isActive ? 1.5 : 0.8),
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
                            color: isActive ? const Color(0xffB100FF) : Colors.white.withOpacity(0.30),
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
                final isActive = index == controller.selectedTimeSlotIndex.value;
                Color borderClr = isActive ? const Color(0xffB100FF) : Colors.white.withOpacity(0.04);
                Color fillClr = isActive ? const Color(0xffB100FF).withOpacity(0.08) : Colors.white.withOpacity(0.01);

                return GestureDetector(
                  onTap: () => controller.selectedTimeSlotIndex.value = index,
                  child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: fillClr,
                      border: Border.all(color: borderClr, width: isActive ? 1.5 : 0.8),
                    ),
                    child: Center(
                      child: Text(
                        slot,
                        style: GoogleFonts.outfit(
                          color: isActive ? Colors.white : Colors.white.withOpacity(0.50),
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
          final price = (expert["services"] as List)[0]["price"];
          final duration = (expert["services"] as List)[0]["duration"];

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
                          const Icon(Icons.videocam_rounded, color: Colors.white, size: 16),
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
    );
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
                        child: Image.network(rev["image"]!, height: 32, width: 32, fit: BoxFit.cover),
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
                                    return const Icon(Icons.star_rounded, color: Color(0xffFFD700), size: 8);
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

}

/// ----------------------------------------------------
/// CUSTOM PAINTER FOR EXPERT RINGS
/// ----------------------------------------------------
class ExpertBackdropPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 3.5;
    double radius = size.width / 2.3;
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
