import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';
import 'swiggy_tabs.dart';
import '../../../widgets/app_shimmer.dart';
import '../../../widgets/premium_meal_promo_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.find<HomeController>();
  final ScrollController _scrollController = ScrollController();
  bool _showStickySearch = false;

  /// Approximate pixel offset at which the search bar scrolls off-screen.
  /// Header (~80) + tabs (~80) + search bar top padding (16) ≈ 176px.
  static const double _stickyThreshold = 176.0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final shouldShow = _scrollController.offset > _stickyThreshold;
    if (shouldShow != _showStickySearch) {
      setState(() {
        _showStickySearch = shouldShow;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: const Color(0xff06010F),
      body: Stack(
        children: [
          SafeArea(
            top: false,
            bottom: false,
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                /// 1. TOP HEADER SECTION (Location/Profile)
                Obx(() {
                    final isMeal = controller.activeTab.value == 0;
                    final headerBg = isMeal
                        ? const Color(0xffB81F22).withOpacity(0.20)
                        : const Color(0xff3F72AF).withOpacity(0.20);

                    // Dynamically update system status bar style to match the tab theme
                    SystemChrome.setSystemUIOverlayStyle(
                      SystemUiOverlayStyle(
                        statusBarColor: headerBg,
                        statusBarIconBrightness: Brightness.light,
                        statusBarBrightness: Brightness.dark, // iOS
                        systemNavigationBarColor: const Color(0xff06010F),
                        systemNavigationBarIconBrightness: Brightness.light,
                      ),
                    );

                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      color: headerBg,
                      padding: EdgeInsets.only(
                        left: 18,
                        right: 18,
                        top: topPadding + 14,
                        bottom: 16,
                      ),
                      child: buildTopHeader(),
                    );
                  }),

                  /// THE SWIGGY STYLE TOP TABS
                  const SwiggyTabsHeader(),

                  /// THE DYNAMIC CONTENT AREA
                  Obx(() {
                    final isMeal = controller.activeTab.value == 0;
                    final bgColor = isMeal
                        ? const Color(0xff640F11)
                        : const Color(0xff3F72AF);

                    if (!isMeal) {
                      return Column(
                        children: [
                          // Colored Section
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: bgColor,
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(24),
                                bottomRight: Radius.circular(24),
                              ),
                            ),
                            padding: const EdgeInsets.only(
                              left: 18,
                              right: 18,
                              top: 16,
                              bottom: 18,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.asset(
                                'assets/home/home1.png',
                                width: double.infinity,
                                height: 160,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // Dark Section with Coming Soon Card
                          Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: Color(0xff06010F),
                            ),
                            padding: const EdgeInsets.only(top: 40, bottom: 200, left: 18, right: 18),
                            child: Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.03),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.08),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xff3F72AF).withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.fitness_center_rounded,
                                      color: Color(0xff3F72AF),
                                      size: 40,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Workout Plans",
                                    style: GoogleFonts.outfit(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Coming Soon!",
                                    style: GoogleFonts.outfit(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xff3F72AF),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    "We are crafting customized AI-driven workout plans and daily routine exercises to help you crush your fitness goals.",
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.outfit(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white.withOpacity(0.6),
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return Column(
                      children: [
                        // Colored Section (Bleeds from tabs)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                          ),
                          padding: const EdgeInsets.only(
                            left: 18,
                            right: 18,
                            top: 16,
                            bottom: 18,
                          ),
                          child: Column(
                            children: [
                              if (isMeal) ...[
                                // When sticky bar is visible, hide the inline
                                // search bar so it doesn't show twice.
                                AnimatedOpacity(
                                  duration: const Duration(milliseconds: 250),
                                  opacity: _showStickySearch ? 0.0 : 1.0,
                                  child: const PremiumSearchBar(),
                                ),
                                const SizedBox(height: 16),
                                const PremiumMealPromoCard(),
                                const SizedBox(height: 16),
                                SwiggyPromoCards(),
                              ] else
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(24),
                                  child: Image.asset(
                                    'assets/home/home1.png',
                                    width: double.infinity,
                                    height: 140,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // Dark Section (Rest of the content)
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xff06010F),
                          ),
                          padding: const EdgeInsets.only(top: 24, bottom: 100),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),

                                    /// 2. ACTIVE PLAN CARD (Glassmorphic)
                                    Obx(() => AppShimmer(
                                      enabled: controller.isLoading.value,
                                      child: buildActivePlanCard(),
                                    )),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 28),

                              /// 4. TODAY'S MEAL PLAN — full-width blue gradient section
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.only(
                                  top: 32,
                                  bottom: 28,
                                ),
                                decoration: const BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(0xff06010F), // match background
                                      Color(0xff09287B), // rich deep blue
                                      Color(
                                        0xff0E44B5,
                                      ), // vibrant royal blue center glow
                                      Color(
                                        0xff081E57,
                                      ), // dark blue/navy transition
                                      Color(0xff06010F), // match background
                                    ],
                                    stops: [0.0, 0.25, 0.55, 0.85, 1.0],
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                      ),
                                      child: GestureDetector(
                                        onTap: () => Get.toNamed('/meal-plan'),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Today's\nMeal Plan",
                                              style: GoogleFonts.outfit(
                                                color: Colors.white,
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                                height: 1.15,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "View Full Plan →",
                                              style: GoogleFonts.inter(
                                                color: Colors.white.withOpacity(
                                                  0.6,
                                                ),
                                                fontSize: 13,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Obx(() => AppShimmer(
                                      enabled: controller.isLoading.value,
                                      child: buildMealPlanTimeline(),
                                    )),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 28),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// PROMO BANNERS
                                    buildPromoBanners(),

                                    const SizedBox(height: 24),

                                    /// OFFER CARDS
                                  ], // close Column children
                                ), // close Column
                              ), // close Padding
                              // Offers Section - full width, no extra padding
                              buildOfferCards(context),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // const SizedBox(height: 24),

                                    /// TODAY'S MEAL PROGRESS CARD
                                    // buildMealProgressCard(),
                                    /// 3. DAILY PROGRESS DASHBOARD (Reactive)
                                    Obx(() => AppShimmer(
                                      enabled: controller.isLoading.value,
                                      child: buildDailyProgressDashboard(),
                                    )),
                                    const SizedBox(height: 28),

                                    /// 5. AI COACH & HYDRATION GOAL (ROW)
                                    // Row(
                                    //   crossAxisAlignment: CrossAxisAlignment.start,
                                    //   children: [
                                    //     Expanded(flex: 11, child: buildAICoachCard()),
                                    //     const SizedBox(width: 12),
                                    //     Expanded(flex: 8, child: buildHydrationGoalCard()),
                                    //   ],
                                    // ),`
                                    // const SizedBox(height: 28),

                                    /// 6. PROGRESS & STREAK SECTION
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () => Get.toNamed('/progress'),
                                          child: sectionTitle(
                                            "YOUR PROGRESS",
                                            "View All",
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        GestureDetector(
                                          onTap: () => Get.toNamed('/progress'),
                                          child: buildWeightProgressCard(),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(height: 28),

                                    /*
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      sectionTitle("STREAK", "View All"),
                                      const SizedBox(height: 14),
                                      buildStreakAndRewardsCard(),
                                      const SizedBox(height: 12),
                                      buildBadgesCard(),
                                    ],
                                  ),
                                  */
                                    const SizedBox(height: 28),

                                    /// 7. QUICK ACTIONS Grid
                                    /*
                                  sectionTitle("QUICK ACTIONS", ""),

                                  const SizedBox(height: 16),

                                  buildQuickActionsGrid(),
                                  */
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),

          /// STICKY SEARCH BAR — appears at the top when scrolled past the blue section
          Obx(() {
            final isMeal = controller.activeTab.value == 0;
            if (!isMeal) return const SizedBox.shrink();
            return AnimatedSlide(
              offset: _showStickySearch ? Offset.zero : const Offset(0, -1),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              child: AnimatedOpacity(
                opacity: _showStickySearch ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Container(
                  padding: EdgeInsets.only(
                    top: topPadding + 10,
                    left: 18,
                    right: 18,
                    bottom: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff640F11),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff640F11).withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const PremiumSearchBar(),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// TOP HEADER WIDGET
  /// ----------------------------------------------------
  Widget buildTopHeader() {
    return Row(
      children: [
        /// USER INFO TEXT
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                final String fullName = controller.userName.value;
                final String firstName = fullName.isNotEmpty
                    ? fullName.split(' ')[0]
                    : 'Member';
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Hey, ",
                      style: GoogleFonts.outfit(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) => const LinearGradient(
                        colors: [
                          Color(0xffB100FF),
                          Color(0xffFF00E5),
                          Color(0xffFF7A00),
                        ],
                      ).createShader(bounds),
                      child: Text(
                        "$firstName!",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
        ),

        /// HEADER TOP RIGHT ACTIONS
        Row(
          children: [
            // FitCoins Wallet Widget
            Obx(() {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xffFFD166).withOpacity(0.25),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("🪙", style: TextStyle(fontSize: 13)),
                    const SizedBox(width: 4),
                    Text(
                      "${controller.fitPoints.value}",
                      style: GoogleFonts.outfit(
                        color: const Color(0xffFFD166),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => Get.toNamed('/notifications'),
              child: buildTopActionButton(
                icon: Icons.notifications_none_rounded,
                showDot: true,
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => Get.toNamed('/profile'),
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                    width: 0.8,
                  ),
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/profile/avatar.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.person_rounded,
                      color: Colors.white.withOpacity(0.85),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildTopActionButton({required IconData icon, required bool showDot}) {
    return Container(
      height: 40,
      width: 40,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.08), width: 0.8),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(icon, color: Colors.white.withOpacity(0.85), size: 20),
          if (showDot)
            Positioned(
              top: 10,
              right: 10,
              child: Container(
                height: 7,
                width: 7,
                decoration: const BoxDecoration(
                  color: Color(0xffFF00E5),
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// ACTIVE PLAN CARD WIDGET
  /// ----------------------------------------------------
  Widget buildActivePlanCard() {
    return Obx(() {
      final double progress = (controller.planDayNumber.value / 30.0).clamp(
        0.0,
        1.0,
      );

      return Container(
        height: 154,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xff120D23).withOpacity(0.8),
          border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Stack(
              children: [
                /// Premium Custom Painted Vector BG (Option A)
                Positioned.fill(
                  child: CustomPaint(painter: ActivePlanBgPainter()),
                ),

                /// Text Details & Progress
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "ACTIVE PLAN",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2.0,
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            controller.planName.value.isNotEmpty
                                ? controller.planName.value
                                : "Fat Loss Plan",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "Keep up the great pace! ⚡",
                            style: GoogleFonts.inter(
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      /// Linear Progress Bar
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Stack(
                            children: [
                              Container(
                                height: 6,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                              FractionallySizedBox(
                                alignment: Alignment.centerLeft,
                                widthFactor: progress,
                                child: Container(
                                  height: 6,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xffB100FF),
                                        Color(0xffFF00E5),
                                        Color(0xffFF7A00),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Plan Progress: Day ${controller.planDayNumber.value} of 30",
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.45),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                "${controller.planDaysRemaining.value} days remaining",
                                style: GoogleFonts.inter(
                                  color: Colors.white.withOpacity(0.45),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  /// ----------------------------------------------------
  /// HONEST RESULTS PROMISE CARD
  /// ----------------------------------------------------
  Widget buildHonestResultsCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(
          0xff051911,
        ).withOpacity(0.40), // Subtle emerald health tint
        border: Border.all(
          color: const Color(0xff00FF87).withOpacity(0.18),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xff00FF87).withOpacity(0.02),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xff00FF87).withOpacity(0.12),
                      ),
                      child: const Icon(
                        Icons.verified_user_rounded,
                        color: Color(0xff00FF87),
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "Our Science-Backed Promise",
                      style: GoogleFonts.outfit(
                        color: const Color(0xff00FF87),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  "Real results take time & consistency.",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.70),
                      fontSize: 12,
                      height: 1.4,
                    ),
                    children: [
                      const TextSpan(
                        text:
                            "Follow this customized meal plan consistently for 30 days and we assure you a safe, healthy weight change of ",
                      ),
                      TextSpan(
                        text: "5 to 7 kg",
                        style: GoogleFonts.outfit(
                          color: const Color(0xff00FF87),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const TextSpan(
                        text:
                            ". No crash dieting, just home-cooked Indian meals matching your body profile.",
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    buildTrustBadge("Science-Based", Icons.science_rounded),
                    buildTrustBadge("Indian-Friendly", Icons.home_rounded),
                    buildTrustBadge(
                      "No False Claims",
                      Icons.fact_check_rounded,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTrustBadge(String label, IconData icon) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white.withOpacity(0.40), size: 12),
        const SizedBox(width: 4),
        Text(
          label,
          style: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.50),
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  /// ----------------------------------------------------
  /// OFFER CARDS & BOTTOM SHEET
  /// ----------------------------------------------------
  Widget buildDailyProgressDashboard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xff121220),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Obx(() {
        final double calProgress = controller.targetCalories.value > 0
            ? (controller.currentCalories.value / controller.targetCalories.value).clamp(0.0, 1.0)
            : 0.0;
            
        final double pProgress = controller.targetProtein.value > 0
            ? (controller.currentProtein.value / controller.targetProtein.value).clamp(0.0, 1.0)
            : 0.0;
        final double cProgress = controller.targetCarbs.value > 0
            ? (controller.currentCarbs.value / controller.targetCarbs.value).clamp(0.0, 1.0)
            : 0.0;
        final double fProgress = controller.targetFat.value > 0
            ? (controller.currentFat.value / controller.targetFat.value).clamp(0.0, 1.0)
            : 0.0;

        return Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Daily Progress",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () => Get.toNamed('/progress'), // Navigate to full Dedicated Progress Screen
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xffFF7A00).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "Analytics ↗",
                      style: GoogleFonts.outfit(
                        color: const Color(0xffFF7A00),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Circular Calorie Ring
            Row(
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: 1.0,
                        strokeWidth: 10,
                        color: const Color(0xffFF7A00).withOpacity(0.1),
                        backgroundColor: Colors.transparent,
                      ),
                      CircularProgressIndicator(
                        value: calProgress,
                        strokeWidth: 10,
                        color: const Color(0xffFF7A00),
                        strokeCap: StrokeCap.round,
                        backgroundColor: Colors.transparent,
                      ),
                      Center(
                        child: Icon(
                          Icons.local_fire_department_rounded,
                          color: const Color(0xffFF7A00),
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${controller.currentCalories.value} / ${controller.targetCalories.value}",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        "Calories Consumed",
                        style: GoogleFonts.outfit(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Macro Bars
            buildMacroBar("Protein", controller.currentProtein.value, controller.targetProtein.value, pProgress, const Color(0xff00A2FF)),
            const SizedBox(height: 12),
            buildMacroBar("Carbs", controller.currentCarbs.value, controller.targetCarbs.value, cProgress, const Color(0xff00FF87)),
            const SizedBox(height: 12),
            buildMacroBar("Fats", controller.currentFat.value, controller.targetFat.value, fProgress, const Color(0xffFF3E3E)),
          ],
        );
      }),
    );
  }

  Widget buildMacroBar(String title, int current, int target, double progress, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "${current}g / ${target}g",
              style: GoogleFonts.outfit(
                color: Colors.white.withOpacity(0.6),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.15),
            color: color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }

  Widget buildOfferCards(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            "Offers For You",
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(left: 18, right: 18),
          clipBehavior: Clip.none,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.translate(
                offset: const Offset(0, -8),
                child: GestureDetector(
                  onTap: () => _showPremiumOfferBottomSheet(
                    context,
                    "50% OFF",
                    "On Annual Plan",
                    const Color(0xffFF7A00),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/home/offer1.png',
                      width: 320,
                      height: 190,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              GestureDetector(
                onTap: () => _showTalkToExpertBottomSheet(context),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/home/offer2.png',
                    width: 320,
                    height: 190,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  void _showPremiumOfferBottomSheet(
    BuildContext context,
    String offerTitle,
    String offerSubtitle,
    Color accentColor,
  ) {
    int selectedPlanIndex = 1; // 0 = monthly, 1 = annual

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 8,
                bottom: 32,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xff9D4EDD), // Bright vibrant purple
                    Color(0xff3A0CA3), // Deep rich purple
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                ),
                border: Border.all(color: Colors.white.withOpacity(0.05)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.8),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Top Banner Image (fully visible)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/home/bottom_sheet1.png',
                      width: double.infinity,
                      height: 200, // Reverted to slightly larger size
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 16),
                  // Plan Selection Cards
                  Row(
                    children: [
                      // Monthly Plan
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedPlanIndex = 0),
                          child: _buildPlanCard(
                            title: "Monthly Plan",
                            price: "₹499",
                            duration: "/month",
                            billing: "Billed monthly",
                            isSelected: selectedPlanIndex == 0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Annual Plan
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => selectedPlanIndex = 1),
                          child: _buildPlanCard(
                            title: "Annual Plan",
                            price: "₹2,999",
                            duration: "",
                            oldPrice: "₹5,999",
                            billing: "Billed yearly • Save 50%",
                            isSelected: selectedPlanIndex == 1,
                            isBestValue: true,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // CTA Button
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          colors: [Color(0xffFFD166), Color(0xffF7931A)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xffF7931A).withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            selectedPlanIndex == 1
                                ? "Get 50% Off Now"
                                : "Start Monthly Plan",
                            style: GoogleFonts.outfit(
                              color: const Color(0xff3E2000),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xff3E2000),
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        color: Colors.white.withOpacity(0.5),
                        size: 14,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Secure payment   •   Cancel anytime",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ], // Closes children of Column
              ), // Closes Column
            ); // Closes Container
          }, // Closes StatefulBuilder builder
        ); // Closes StatefulBuilder
      },
    );
  }

  void _showTalkToExpertBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: 32,
          ),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff00A3FF), // Bright vibrant blue
                Color(0xff09287B), // Deep rich blue
              ],
            ),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.8),
                blurRadius: 40,
                spreadRadius: 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 4),

              // Top Banner Image (fully visible)
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/home/botoom_sheet2.png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),

              const SizedBox(height: 28),

              // Title and Subtitle
              Text(
                "Talk to an Expert Dietitian",
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Get personalized guidance on your diet, workout, and supplements directly from certified experts.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 32),

              // CTA Button
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    gradient: const LinearGradient(
                      colors: [Color(0xff00D1FF), Color(0xff0088FF)],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff0088FF).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Talk Now",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.call_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: Colors.white.withOpacity(0.5),
                    size: 14,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "100% Confidential & Secure",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ], // Closes children of Column
          ), // Closes Column
        ); // Closes Container
      }, // Closes showModalBottomSheet builder
    ); // Closes showModalBottomSheet
  } // Closes _showTalkToExpertBottomSheet

  Widget _buildFeatureIcon(String emoji, String text) {
    return Expanded(
      child: Column(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.04),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 26)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.85),
              fontSize: 11,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanCard({
    required String title,
    required String price,
    required String duration,
    required String billing,
    required bool isSelected,
    String? oldPrice,
    bool isBestValue = false,
  }) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: isSelected
                ? const Color(0xffE98C00).withOpacity(0.12)
                : Colors.white.withOpacity(0.03),
            border: Border.all(
              color: isSelected
                  ? const Color(0xffE98C00)
                  : Colors.white.withOpacity(0.08),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Icon(
                    isSelected
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked,
                    color: isSelected
                        ? const Color(0xffE98C00)
                        : Colors.white.withOpacity(0.2),
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (duration.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4.0, left: 2.0),
                      child: Text(
                        duration,
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  if (oldPrice != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5.0, left: 6.0),
                      child: Text(
                        oldPrice,
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 13,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                billing,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        if (isBestValue)
          Positioned(
            top: -12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xffFFD166),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xffFFD166).withOpacity(0.3),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: Color(0xff3E2000),
                    size: 12,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    "Best Value",
                    style: GoogleFonts.outfit(
                      color: const Color(0xff3E2000),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  /// ----------------------------------------------------
  /// MEAL PROGRESS BAR CARD
  /// ----------------------------------------------------
  Widget buildMealProgressCard() {
    return Obx(() {
      final double progress = controller.totalMealsToday.value > 0
          ? (controller.mealsCompletedToday.value /
                    controller.totalMealsToday.value)
                .clamp(0.0, 1.0)
          : 0.0;

      return GestureDetector(
        onTap: () => Get.toNamed('/meal-plan'),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xff0B0817).withOpacity(0.55),
            border: Border.all(
              color: const Color(0xffB100FF).withOpacity(0.15),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.restaurant_menu_rounded,
                        color: Color(0xffB100FF),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Today's Meals",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${controller.mealsCompletedToday.value} / ${controller.totalMealsToday.value} Completed",
                    style: GoogleFonts.inter(
                      color: const Color(0xffB100FF),
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 6,
                child: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.06),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xffB100FF), Color(0xffFF00E5)],
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  /// ----------------------------------------------------
  /// STATS CARD WIDGET
  /// ----------------------------------------------------
  Widget buildStatCard({
    required String title,
    required String value,
    required String sub,
    required IconData icon,
    required Color color,
    required double progress,
  }) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(color: color.withOpacity(0.22), width: 1.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.06),
            const Color(0xff0B0817).withOpacity(0.40),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.03),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            /// Wave Graphic Background
            Positioned.fill(
              child: CustomPaint(painter: WavePainter(color: color)),
            ),

            /// Info Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withOpacity(0.12),
                        ),
                        child: Icon(icon, color: color, size: 18),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.80),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  Text(
                    value,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    sub,
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.45),
                      fontSize: 10,
                    ),
                  ),

                  const SizedBox(height: 12),

                  /// Progress Bar
                  Container(
                    height: 5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white.withOpacity(0.08),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: progress.clamp(0.0, 1.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            colors: [color, color.withOpacity(0.3)],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Specialized Water Card with glasses
  Widget buildWaterCard({required double current, required double target}) {
    Color color = const Color(0xff00A3FF);
    int totalCups = 5;
    int filledCups = ((current / target) * totalCups).round().clamp(
      0,
      totalCups,
    );

    return Container(
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.55),
        border: Border.all(color: color.withOpacity(0.22), width: 1.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.06),
            const Color(0xff0B0817).withOpacity(0.40),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.03),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            /// Wave Graphic Background
            Positioned.fill(
              child: CustomPaint(painter: WavePainter(color: color)),
            ),

            /// Info Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withOpacity(0.12),
                        ),
                        child: Icon(
                          Icons.water_drop_rounded,
                          color: color,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Water",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.80),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: current.toStringAsFixed(1),
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: " / ${target.round()} L",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.45),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  /// Droplet indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(totalCups, (index) {
                      bool isFilled = index < filledCups;
                      return Icon(
                        Icons.water_drop_rounded,
                        color: isFilled
                            ? color
                            : Colors.white.withOpacity(0.12),
                        size: 15,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// ----------------------------------------------------
  /// MEAL PLAN TIMELINE WIDGETS
  /// ----------------------------------------------------
  Widget buildPromoBanners() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildBannerImage('assets/home/banner1.png'),
          const SizedBox(width: 12),
          _buildBannerImage('assets/home/banner2.png'),
          const SizedBox(width: 12),
          _buildBannerImage('assets/home/banner3.png'),
          const SizedBox(width: 12),
          _buildBannerImage('assets/home/banner4.png'),
        ],
      ),
    );
  }

  Widget _buildBannerImage(String path) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.asset(path, width: 360, height: 180, fit: BoxFit.cover),
    );
  }

  Widget buildMealPlanTimeline() {
    return Obx(() {
      return BlockbusterMealCarousel(meals: controller.homeMeals.toList());
    });
  }

  /// ----------------------------------------------------
  /// AI COACH CARD WIDGET
  /// ----------------------------------------------------
  Widget buildAICoachCard() {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.60),
        border: Border.all(
          color: const Color(0xffB100FF).withOpacity(0.25),
          width: 1.0,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xffB100FF).withOpacity(0.06),
            const Color(0xff0B0817).withOpacity(0.40),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xffB100FF).withOpacity(0.04),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          /// Glowing Brain Circle Icon
          Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xffB100FF).withOpacity(0.35),
                  const Color(0xffFF00E5).withOpacity(0.12),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffB100FF).withOpacity(0.15),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
              border: Border.all(
                color: const Color(0xffB100FF).withOpacity(0.30),
                width: 0.8,
              ),
            ),
            child: const Icon(
              Icons.psychology_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),

          /// Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "AI Coach Insight",
                  style: GoogleFonts.outfit(
                    color: const Color(0xffC947FF),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "Your protein intake is 18% lower today. Add more protein in your next meal.",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.70),
                    fontSize: 10.5,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: Colors.white.withOpacity(0.35),
            size: 18,
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// HYDRATION GOAL CARD (with glowing water bottle)
  /// ----------------------------------------------------
  Widget buildHydrationGoalCard() {
    Color themeColor = const Color(0xff00A3FF);

    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: const Color(0xff0B0817).withOpacity(0.60),
        border: Border.all(color: themeColor.withOpacity(0.25), width: 1.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeColor.withOpacity(0.06),
            const Color(0xff0B0817).withOpacity(0.40),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: themeColor.withOpacity(0.04),
            blurRadius: 10,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          /// Left column: details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Icon(Icons.water_drop_rounded, color: themeColor, size: 12),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        "Hydration Goal",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.70),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "2.1",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: " / 3 L",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.40),
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                /// Mini Glass Droplets
                Row(
                  children: List.generate(5, (index) {
                    bool filled = index < 3;
                    return Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: Icon(
                        Icons.water_drop_rounded,
                        color: filled
                            ? themeColor
                            : Colors.white.withOpacity(0.12),
                        size: 9,
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          /// Right column: Neon Water Bottle Custom drawn
          SizedBox(
            width: 32,
            height: double.infinity,
            child: CustomPaint(
              painter: NeonBottlePainter(fillProgress: 2.1 / 3.0),
            ),
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// YOUR PROGRESS: WEIGHT LINE CHART CARD
  /// ----------------------------------------------------
  Widget buildWeightProgressCard() {
    return Obx(() {
      final double currentW = controller.currentWeight.value;
      final double diffW = controller.weightDifference.value;
      final String diffText = diffW >= 0
          ? "↑ ${diffW.toStringAsFixed(1)} kg"
          : "↓ ${diffW.abs().toStringAsFixed(1)} kg";
      final Color diffColor = diffW <= 0
          ? const Color(0xff00FF87)
          : const Color(0xffFF3B30);

      final List<double> weights = controller.weightHistoryLogs
          .map((log) => (log['weight'] as num).toDouble())
          .toList();
      final List<String> labels = controller.weightHistoryLogs
          .map((log) => log['date'] as String)
          .toList();

      return Container(
        height: 180,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: const Color(0xff0B0817).withOpacity(0.60),
          border: Border.all(
            color: const Color(0xffFF00E5).withOpacity(0.20),
            width: 1.0,
          ),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xffFF00E5).withOpacity(0.06),
              const Color(0xff0B0817).withOpacity(0.40),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xffFF00E5).withOpacity(0.03),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Weight Progress",
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.50),
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          "${currentW.toStringAsFixed(1)} kg",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          diffText,
                          style: GoogleFonts.inter(
                            color: diffColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),

            /// Real Line Chart Custom Painted
            Expanded(
              child: CustomPaint(
                size: Size.infinite,
                painter: ProgressLineChartPainter(weights: weights),
              ),
            ),
            const SizedBox(height: 6),

            /// X-Axis labels
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: labels.map((label) => xAxisLabel(label)).toList(),
            ),
          ],
        ),
      );
    });
  }

  Widget xAxisLabel(String label) {
    return Text(
      label,
      style: GoogleFonts.inter(
        color: Colors.white.withOpacity(0.35),
        fontSize: 8.5,
      ),
    );
  }

  /// INCHES LOST SMALL CARD
  Widget buildInchesLostCard() {
    Color themeColor = const Color(0xff00FF87);
    return GestureDetector(
      onTap: () => Get.toNamed('/progress-photos'),
      child: Container(
        height: 94,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xff0B0817).withOpacity(0.60),
          border: Border.all(color: themeColor.withOpacity(0.20), width: 1.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              themeColor.withOpacity(0.05),
              const Color(0xff0B0817).withOpacity(0.40),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Inches Lost",
              style: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.50),
                fontSize: 10,
              ),
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "2.1 in",
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeColor.withOpacity(0.12),
                  ),
                  child: Icon(
                    Icons.straighten_rounded,
                    color: themeColor,
                    size: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// CONSISTENCY CIRCULAR PROGRESS SMALL CARD
  Widget buildConsistencyCard() {
    Color themeColor = const Color(0xff00FF87);
    return Container(
      height: 94,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff0B0817).withOpacity(0.60),
        border: Border.all(color: themeColor.withOpacity(0.20), width: 1.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeColor.withOpacity(0.05),
            const Color(0xff0B0817).withOpacity(0.40),
          ],
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "This Week\nConsistency",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.50),
                    fontSize: 8.5,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "6/7 Days",
                  style: GoogleFonts.outfit(
                    color: themeColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 4),

          /// Micro Circular indicator
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 42,
                width: 42,
                child: CircularProgressIndicator(
                  value: 0.85,
                  strokeWidth: 4,
                  backgroundColor: Colors.white.withOpacity(0.05),
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                ),
              ),
              Text(
                "85%",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// ----------------------------------------------------
  /// STREAK & REWARDS WIDGETS
  /// ----------------------------------------------------
  Widget buildStreakAndRewardsCard() {
    Color themeColor = const Color(0xffFF7A00);
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff0B0817).withOpacity(0.60),
        border: Border.all(color: themeColor.withOpacity(0.20), width: 1.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeColor.withOpacity(0.05),
            const Color(0xff0B0817).withOpacity(0.40),
          ],
        ),
      ),
      child: Row(
        children: [
          /// Streak
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.02),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xffFF7A00),
                    size: 24,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "12",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Day Streak",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.50),
                            fontSize: 8.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          /// Reward Coins
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.02),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.stars_rounded,
                    color: Color(0xffFFD700),
                    size: 24,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "240",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Reward Coins",
                          style: GoogleFonts.inter(
                            color: Colors.white.withOpacity(0.50),
                            fontSize: 8.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// BADGES ROW CARD
  Widget buildBadgesCard() {
    Color themeColor = const Color(0xffB100FF);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: const Color(0xff0B0817).withOpacity(0.60),
        border: Border.all(color: themeColor.withOpacity(0.20), width: 1.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeColor.withOpacity(0.05),
            const Color(0xff0B0817).withOpacity(0.40),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Badges",
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.50),
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              buildBadgeIcon(
                icon: Icons.local_fire_department_rounded,
                color: const Color(0xffB100FF),
              ),
              const SizedBox(width: 10),
              buildBadgeIcon(
                icon: Icons.stars_rounded,
                color: const Color(0xffFF7A00),
              ),
              const SizedBox(width: 10),
              buildBadgeIcon(
                icon: Icons.emoji_events_rounded,
                color: const Color(0xff00A3FF),
              ),
              const Spacer(),
              Icon(
                Icons.chevron_right_rounded,
                color: Colors.white.withOpacity(0.35),
                size: 18,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildBadgeIcon({required IconData icon, required Color color}) {
    return Container(
      height: 38,
      width: 38,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xff090414),
        border: Border.all(color: color.withOpacity(0.35), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.12),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 18),
    );
  }

  /// ----------------------------------------------------
  /// QUICK ACTIONS GRID WIDGET
  /// ----------------------------------------------------
  Widget buildQuickActionsGrid() {
    final List<Map<String, dynamic>> actions = [
      {
        "title": "Update\nProgress",
        "icon": Icons.bar_chart_rounded,
        "color": const Color(0xff00FF87),
      },
      {
        "title": "Consult\nExpert",
        "icon": Icons.medical_services_rounded,
        "color": const Color(0xffB100FF),
      },
      {
        "title": "Supplements",
        "icon": Icons.offline_bolt_rounded,
        "color": const Color(0xffFF7A00),
      },
      {
        "title": "Social Room",
        "icon": Icons.groups_rounded,
        "color": const Color(0xffFF00E5),
      },
      {
        "title": "Family",
        "icon": Icons.people_outline_rounded,
        "color": const Color(0xff00A3FF),
      },
      {
        "title": "More",
        "icon": Icons.more_horiz_rounded,
        "color": Colors.white,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: actions.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        final action = actions[index];
        Color color = action["color"] as Color;

        return GestureDetector(
          onTap: () {
            final title = action["title"] as String;
            if (title.contains("Progress")) {
              Get.toNamed('/progress');
            } else if (title.contains("Expert")) {
              Get.toNamed('/booking');
            } else if (title.contains("Supplements")) {
              Get.toNamed('/supplements');
            } else if (title.contains("Social")) {
              Get.toNamed('/social-feed');
            } else if (title.contains("Family")) {
              Get.toNamed('/family');
            } else if (title.contains("More")) {
              showMoreActionsSheet(context);
            }
          },
          child: Column(
            children: [
              /// Circular colorful glow container
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xff0B0817),
                  border: Border.all(color: color.withOpacity(0.18), width: 1),
                  gradient: RadialGradient(
                    colors: [color.withOpacity(0.08), Colors.transparent],
                  ),
                ),
                child: Icon(action["icon"] as IconData, color: color, size: 20),
              ),
              const SizedBox(height: 6),
              Text(
                action["title"] as String,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.70),
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showMoreActionsSheet(BuildContext context) {
    final extraActions = [
      {
        "title": "Health Insights",
        "subtitle": "Science-backed health tips",
        "icon": Icons.lightbulb_rounded,
        "color": const Color(0xff00E5FF),
        "route": '/health-tips',
      },
      {
        "title": "Video Consultation",
        "subtitle": "Live expert consultation",
        "icon": Icons.video_call_rounded,
        "color": const Color(0xffFF00E5),
        "route": '/video-call',
      },
      {
        "title": "Smart Reminders",
        "subtitle": "Workout, meal & water alarms",
        "icon": Icons.alarm_rounded,
        "color": const Color(0xffFF7A00),
        "route": '/reminders',
      },
    ];

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: const Color(0xff090414),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 1.0),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Padding(
              padding: const EdgeInsets.all(22.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Text(
                    "More Quick Actions",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Explore other features and utilities",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.40),
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: extraActions.length,
                    itemBuilder: (context, idx) {
                      final act = extraActions[idx];
                      final icon = act["icon"] as IconData;
                      final color = act["color"] as Color;
                      final route = act["route"] as String;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.01),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.04),
                          ),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Get.back();
                              Get.toNamed(route);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: color.withOpacity(0.08),
                                      border: Border.all(
                                        color: color.withOpacity(0.20),
                                      ),
                                    ),
                                    child: Icon(icon, color: color, size: 18),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          act["title"] as String,
                                          style: GoogleFonts.outfit(
                                            color: Colors.white,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          act["subtitle"] as String,
                                          style: GoogleFonts.inter(
                                            color: Colors.white.withOpacity(
                                              0.40,
                                            ),
                                            fontSize: 9.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white.withOpacity(0.20),
                                    size: 11,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }

  /// ----------------------------------------------------
  /// REUSABLE HEADERS/HELPERS
  /// ----------------------------------------------------
  Widget sectionTitle(String title, String action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        if (action.isNotEmpty)
          Row(
            children: [
              Text(
                action,
                style: GoogleFonts.outfit(
                  color: const Color(0xffB100FF),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(
                Icons.arrow_forward_rounded,
                color: Color(0xffB100FF),
                size: 11,
              ),
            ],
          ),
      ],
    );
  }

  /// ----------------------------------------------------
  /// BOTTOM NAVIGATION BAR
  /// ----------------------------------------------------
  Widget buildBottomNav() {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: const Color(0xff090414),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
        border: Border.all(color: Colors.white.withOpacity(0.04), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          navItem(Icons.home_filled, "Dashboard", true, onTap: () {}),
          navItem(
            Icons.restaurant_rounded,
            "Meals",
            false,
            onTap: () => Get.toNamed('/meal-plan'),
          ),
          const SizedBox(width: 40), // Spacer for FAB
          navItem(
            Icons.groups_rounded,
            "Experts",
            false,
            onTap: () => Get.toNamed('/booking'),
          ),
          navItem(
            Icons.card_giftcard_rounded,
            "Rewards",
            false,
            onTap: () => Get.toNamed('/rewards-hub'),
          ),
        ],
      ),
    );
  }

  Widget navItem(
    IconData icon,
    String label,
    bool active, {
    VoidCallback? onTap,
  }) {
    Color activeColor = const Color(0xffFF00E5);
    Color inactiveColor = Colors.white.withOpacity(0.40);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: active ? activeColor : inactiveColor, size: 22),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: active ? activeColor : inactiveColor,
              fontSize: 10,
              fontWeight: active ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------
/// CUSTOM PAINTERS FOR PREMIUM UI
/// ----------------------------------------------------

/// 1. Custom painter for background waves inside Stats Cards
class WavePainter extends CustomPainter {
  final Color color;

  WavePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.03)
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color.withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final path = Path();
    path.moveTo(0, size.height * 0.7);

    // Draw wavy Bezier curve
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.45,
      size.width * 0.5,
      size.height * 0.65,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.85,
      size.width,
      size.height * 0.5,
    );

    // Draw stroke line
    canvas.drawPath(path, strokePaint);

    // Close path to bottom for fill
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 2. Custom painter for beautiful Timeline Nodes
class TimelineNodePainter extends CustomPainter {
  final bool isFirst;
  final bool isLast;
  final Color color;
  final bool isActive;

  TimelineNodePainter({
    required this.isFirst,
    required this.isLast,
    required this.color,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = isActive
          ? color.withOpacity(0.25)
          : Colors.white.withOpacity(0.08)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    double centerX = size.width / 2;
    double centerY = size.height / 2;

    // Draw vertical connection lines
    if (!isFirst) {
      canvas.drawLine(
        Offset(centerX, 0),
        Offset(centerX, centerY - 8),
        linePaint,
      );
    }
    if (!isLast) {
      canvas.drawLine(
        Offset(centerX, centerY + 8),
        Offset(centerX, size.height),
        linePaint,
      );
    }

    // Draw outer pulsing glowing circle
    final glowPaint = Paint()
      ..color = color.withOpacity(isActive ? 0.22 : 0.05)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), 9, glowPaint);

    // Draw middle circle
    final borderPaint = Paint()
      ..color = isActive ? color : Colors.white.withOpacity(0.12)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(centerX, centerY), 6, borderPaint);

    // Draw inner solid dot
    final dotPaint = Paint()
      ..color = isActive ? color : Colors.white.withOpacity(0.20)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 3. Custom painter for a beautiful glowing neon water bottle
class NeonBottlePainter extends CustomPainter {
  final double fillProgress;

  NeonBottlePainter({required this.fillProgress});

  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;

    // 1. Draw bottle outline
    final outlinePaint = Paint()
      ..color = const Color(0xff00A3FF).withOpacity(0.3)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = const Color(0xff00A3FF).withOpacity(0.12)
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final bottlePath = Path();

    // Cap/Neck
    bottlePath.moveTo(w * 0.35, h * 0.12);
    bottlePath.lineTo(w * 0.65, h * 0.12);
    bottlePath.lineTo(w * 0.65, h * 0.22);
    // Shoulder
    bottlePath.quadraticBezierTo(w * 0.65, h * 0.32, w * 0.85, h * 0.36);
    // Body
    bottlePath.lineTo(w * 0.85, h * 0.82);
    // Bottom
    bottlePath.quadraticBezierTo(w * 0.85, h * 0.90, w * 0.5, h * 0.90);
    bottlePath.quadraticBezierTo(w * 0.15, h * 0.90, w * 0.15, h * 0.82);
    // Body left
    bottlePath.lineTo(w * 0.15, h * 0.36);
    // Shoulder left
    bottlePath.quadraticBezierTo(w * 0.35, h * 0.32, w * 0.35, h * 0.22);
    bottlePath.close();

    canvas.drawPath(bottlePath, glowPaint);
    canvas.drawPath(bottlePath, outlinePaint);

    // 2. Draw water fill
    final waterPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xff00A3FF).withOpacity(0.7),
          const Color(0xff00E5FF).withOpacity(0.3),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    // Create a clipping path of the bottle interior
    canvas.save();
    canvas.clipPath(bottlePath);

    // Draw wavy top for water
    double waterHeight = h * 0.88 - (h * 0.52 * fillProgress);
    final wavePath = Path();
    wavePath.moveTo(0, waterHeight);
    wavePath.quadraticBezierTo(w * 0.25, waterHeight - 2, w * 0.5, waterHeight);
    wavePath.quadraticBezierTo(w * 0.75, waterHeight + 2, w, waterHeight);
    wavePath.lineTo(w, h * 0.88);
    wavePath.lineTo(0, h * 0.88);
    wavePath.close();

    canvas.drawPath(wavePath, waterPaint);
    canvas.restore();

    // Draw simple cap lines
    final capPaint = Paint()
      ..color = const Color(0xff00A3FF)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(w * 0.38, h * 0.08, w * 0.24, h * 0.04),
        const Radius.circular(2),
      ),
      capPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

/// 4. Custom painter for a glowing weight line chart
class ProgressLineChartPainter extends CustomPainter {
  final List<double> weights;

  ProgressLineChartPainter({required this.weights});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.03)
      ..strokeWidth = 0.8;

    // Draw horizontal grid lines
    for (int i = 0; i < 4; i++) {
      double y = size.height * 0.15 + (size.height * 0.25 * i);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    if (weights.isEmpty) return;

    double minVal = weights.reduce(min);
    double maxVal = weights.reduce(max);
    double valRange = maxVal - minVal;
    if (valRange == 0) valRange = 1.0;

    double stepX =
        size.width / (weights.length - 1 == 0 ? 1 : weights.length - 1);
    final points = <Offset>[];

    for (int i = 0; i < weights.length; i++) {
      double x = i * stepX;
      double normalized = (weights[i] - minVal) / valRange;
      double y = size.height * 0.80 - (normalized * size.height * 0.65);
      points.add(Offset(x, y));
    }

    // Compute bezier curve path
    final path = Path();
    path.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p1 = points[i];
      final p2 = points[i + 1];
      final controlPoint1 = Offset(p1.dx + (p2.dx - p1.dx) / 2.2, p1.dy);
      final controlPoint2 = Offset(p1.dx + (p2.dx - p1.dx) / 2.2, p2.dy);
      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        p2.dx,
        p2.dy,
      );
    }

    // Draw gradient fill under line
    final fillPath = Path.from(path);
    fillPath.lineTo(points.last.dx, size.height * 0.9);
    fillPath.lineTo(points.first.dx, size.height * 0.9);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [const Color(0xffFF00E5).withOpacity(0.12), Colors.transparent],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // Draw main glowing chart line
    final linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, linePaint);

    // Draw glowing final dot ("Today")
    final lastPoint = points.last;

    // Outer glow circle
    final glowPaint = Paint()
      ..color = const Color(0xffFF00E5).withOpacity(0.35)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(lastPoint, 6, glowPaint);

    // Inner white dot
    final solidPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(lastPoint, 2.5, solidPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class ActivePlanBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double w = size.width;
    double h = size.height;

    /// A. Draw Purple/Pink Nebula Radial Gradients
    Paint nebulaPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xffFF00E5).withOpacity(0.18),
          const Color(0xffB100FF).withOpacity(0.04),
          Colors.transparent,
        ],
        center: Alignment.centerRight,
      ).createShader(Rect.fromLTRB(w * 0.4, -h * 0.2, w * 1.2, h * 1.2));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), nebulaPaint);

    /// B. Draw Stars/Dots
    Paint starPaint = Paint()..color = Colors.white.withOpacity(0.15);
    canvas.drawCircle(Offset(w * 0.15, h * 0.22), 1.0, starPaint);
    canvas.drawCircle(Offset(w * 0.32, h * 0.18), 1.2, starPaint);
    canvas.drawCircle(Offset(w * 0.45, h * 0.35), 0.8, starPaint);
    canvas.drawCircle(
      Offset(w * 0.72, h * 0.12),
      1.5,
      starPaint..color = Colors.white.withOpacity(0.25),
    );
    canvas.drawCircle(Offset(w * 0.88, h * 0.28), 1.0, starPaint);
    canvas.drawCircle(Offset(w * 0.62, h * 0.45), 0.7, starPaint);

    /// C. Draw Mountain Silhouette (right aligned bottom)
    Path mountain = Path();
    mountain.moveTo(w * 0.42, h);
    mountain.lineTo(w * 0.64, h * 0.52); // Peak
    mountain.lineTo(w * 0.86, h);
    mountain.close();

    Paint mountainPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xff120826), Color(0xff06010F)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(w * 0.4, h * 0.5, w * 0.9, h));

    canvas.drawPath(mountain, mountainPaint);

    /// Draw a tiny human silhouette on peak
    Paint humanPaint = Paint()..color = Colors.white.withOpacity(0.50);
    double px = w * 0.64;
    double py = h * 0.52;
    canvas.drawCircle(Offset(px, py - 4), 1.2, humanPaint); // Head
    canvas.drawLine(
      Offset(px, py - 3),
      Offset(px, py),
      Paint()
        ..color = Colors.white.withOpacity(0.50)
        ..strokeWidth = 1.0,
    ); // Body

    /// D. Draw Glowing Circular Target/Streak Ring (Far Right side)
    double cx = w * 0.82;
    double cy = h * 0.40;
    double r = 32.0;

    // Glowing border ring
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
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5;

    // Outer glow - concentric circles (safe)
    for (double i = 1; i <= 3; i++) {
      canvas.drawCircle(
        Offset(cx, cy),
        r,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3.5 + (i * 2.0)
          ..color = const Color(0xffB100FF).withOpacity(0.12 / i),
      );
    }
    canvas.drawCircle(Offset(cx, cy), r, ringPaint);

    // Inner background
    canvas.drawCircle(
      Offset(cx, cy),
      r - 1.5,
      Paint()..color = const Color(0xff090414).withOpacity(0.85),
    );

    // Target emoji drawn inside (🎯 represent Active Plan goal)
    TextPainter textPainter = TextPainter(
      text: const TextSpan(text: "🎯", style: TextStyle(fontSize: 16)),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(cx - textPainter.width / 2, cy - textPainter.height / 2),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// ----------------------------------------------------
/// PREMIUM SEARCH BAR WIDGET
/// ----------------------------------------------------
class PremiumSearchBar extends StatefulWidget {
  const PremiumSearchBar({super.key});

  @override
  State<PremiumSearchBar> createState() => _PremiumSearchBarState();
}

class _PremiumSearchBarState extends State<PremiumSearchBar> {
  final List<String> searchHints = [
    "Search Breakfast...",
    "Search Lunch...",
    "Search Mid Meal...",
    "Search Dinner...",
  ];
  int currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          currentIndex = (currentIndex + 1) % searchHints.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search_rounded, color: Colors.black54, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.2),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: Align(
                key: ValueKey<int>(currentIndex),
                alignment: Alignment.centerLeft,
                child: Text(
                  searchHints[currentIndex],
                  style: GoogleFonts.outfit(
                    color: Colors.black87,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xff00A2FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.tune_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------
/// SWIGGY STYLE PROMO CARDS WIDGET
/// ----------------------------------------------------
class SwiggyPromoCards extends StatelessWidget {
  SwiggyPromoCards({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final double kcalProgress = controller.targetCalories.value > 0
          ? (controller.currentCalories.value / controller.targetCalories.value)
                .clamp(0.0, 1.0)
          : 0.0;
      final double proteinProgress = controller.targetProtein.value > 0
          ? (controller.currentProtein.value / controller.targetProtein.value)
                .clamp(0.0, 1.0)
          : 0.0;
      final double carbsProgress = controller.targetCarbs.value > 0
          ? (controller.currentCarbs.value / controller.targetCarbs.value)
                .clamp(0.0, 1.0)
          : 0.0;
      final double fatProgress = controller.targetFat.value > 0
          ? (controller.currentFat.value / controller.targetFat.value).clamp(
              0.0,
              1.0,
            )
          : 0.0;

      return Row(
        children: [
          Expanded(
            child: _buildMacroCard(
              title: "Calories",
              consumed: "${controller.currentCalories.value}",
              target: "${controller.targetCalories.value} kcal",
              progress: kcalProgress,
              color: const Color(0xffFF7A00),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _buildMacroCard(
              title: "Protein",
              consumed: "${controller.currentProtein.value}g",
              target: "${controller.targetProtein.value}g",
              progress: proteinProgress,
              color: const Color(0xff00FF87),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _buildMacroCard(
              title: "Carbs",
              consumed: "${controller.currentCarbs.value}g",
              target: "${controller.targetCarbs.value}g",
              progress: carbsProgress,
              color: const Color(0xff00A3FF),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: _buildMacroCard(
              title: "Fat",
              consumed: "${controller.currentFat.value}g",
              target: "${controller.targetFat.value}g",
              progress: fatProgress,
              color: const Color(0xffB100FF),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildMacroCard({
    required String title,
    required String consumed,
    required String target,
    required double progress,
    required Color color,
  }) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.09),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.12), width: 0.8),
      ),
      padding: const EdgeInsets.all(6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              color: Colors.white.withOpacity(0.7),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),

          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                consumed,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 1),
              Text(
                target,
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          // Small horizontal progress bar at bottom of card
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.05),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }
}

/// ----------------------------------------------------
/// PROMOTIONAL BANNER SECTION
/// ----------------------------------------------------
class PromoBannerSection extends StatefulWidget {
  const PromoBannerSection({super.key});

  @override
  State<PromoBannerSection> createState() => _PromoBannerSectionState();
}

class _PromoBannerSectionState extends State<PromoBannerSection>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;
  late AnimationController _floatController;
  late Animation<double> _floatAnim;

  final List<Map<String, dynamic>> _promos = [
    {
      "tag": "🔥 Limited Offer",
      "tagColor": const Color(0xffFF9A3C),
      "headline": "Flat 50% Off\nDiet Plans!",
      "sub": "Personalised Indian meal plans\ncrafted by expert dietitians.",
      "cta": "Grab Deal →",
      "icons": ["🥗", "🥑", "🍎"],
      "gradientStart": const Color(0xff003A6E),
      "gradientEnd": const Color(0xff00509E),
      "glowColor": const Color(0xffFF9A3C),
    },
    {
      "tag": "💪 New Feature",
      "tagColor": const Color(0xff00E5A0),
      "headline": "AI Coach\nNow Live!",
      "sub": "Real-time feedback on\nyour workouts & calories.",
      "cta": "Try Now →",
      "icons": ["🤖", "📊", "⚡"],
      "gradientStart": const Color(0xff00316A),
      "gradientEnd": const Color(0xff004A90),
      "glowColor": const Color(0xff00E5A0),
    },
    {
      "tag": "🥑 Just Added",
      "tagColor": const Color(0xffC97FFF),
      "headline": "New Vegan\nRecipes!",
      "sub": "50+ plant-based Indian\nrecipes — added today.",
      "cta": "Explore →",
      "icons": ["🥦", "🥕", "🌿"],
      "gradientStart": const Color(0xff002D60),
      "gradientEnd": const Color(0xff0044A0),
      "glowColor": const Color(0xffC97FFF),
    },
    {
      "tag": "🏃 Challenge",
      "tagColor": const Color(0xffFF6B9D),
      "headline": "30-Day Fat\nBurn Sprint!",
      "sub": "Join 12,000+ members in\nour biggest challenge yet.",
      "cta": "Join Free →",
      "icons": ["🏅", "🔥", "💦"],
      "gradientStart": const Color(0xff003570),
      "gradientEnd": const Color(0xff004C9E),
      "glowColor": const Color(0xffFF6B9D),
    },
  ];

  @override
  void initState() {
    super.initState();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);
    _floatAnim = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final next = (_currentPage + 1) % _promos.length;
      _pageController.animateToPage(
        next,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _floatController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: SizedBox(
            height: 190,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _promos.length,
              onPageChanged: (i) => setState(() => _currentPage = i),
              itemBuilder: (context, index) {
                final p = _promos[index];
                return _buildSlide(p);
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_promos.length, (i) {
            final active = i == _currentPage;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3.5),
              width: active ? 22 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: active ? Colors.white : Colors.white.withOpacity(0.28),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSlide(Map<String, dynamic> p) {
    final Color glowColor = p["glowColor"] as Color;
    final List<String> icons = p["icons"] as List<String>;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [p["gradientStart"] as Color, p["gradientEnd"] as Color],
        ),
      ),
      child: Stack(
        children: [
          // Glowing circle blobs in background
          Positioned(
            right: -30,
            top: -30,
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [glowColor.withOpacity(0.28), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            left: -20,
            bottom: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [glowColor.withOpacity(0.14), Colors.transparent],
                ),
              ),
            ),
          ),

          // Content row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // LEFT: text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Tag chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: (p["tagColor"] as Color).withOpacity(0.18),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: (p["tagColor"] as Color).withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          p["tag"] as String,
                          style: GoogleFonts.inter(
                            color: p["tagColor"] as Color,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      // Headline
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        transitionBuilder: (child, anim) => FadeTransition(
                          opacity: anim,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.12),
                              end: Offset.zero,
                            ).animate(anim),
                            child: child,
                          ),
                        ),
                        child: Text(
                          p["headline"] as String,
                          key: ValueKey(p["headline"]),
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Sub text
                      Text(
                        p["sub"] as String,
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 10,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      // CTA chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: glowColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: glowColor.withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          p["cta"] as String,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // RIGHT: Floating emoji column
                AnimatedBuilder(
                  animation: _floatAnim,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatAnim.value),
                      child: child,
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: icons.asMap().entries.map((e) {
                      final delay = e.key;
                      return Padding(
                        padding: EdgeInsets.only(top: delay == 0 ? 0 : 6),
                        child: AnimatedBuilder(
                          animation: _floatController,
                          builder: (context, ch) {
                            // Stagger each icon slightly
                            final offset =
                                (_floatAnim.value + (delay * 4.0)) % 12 - 6;
                            return Transform.translate(
                              offset: Offset(0, offset * 0.6),
                              child: ch,
                            );
                          },
                          child: Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.07),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.12),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                e.value,
                                style: const TextStyle(fontSize: 20),
                              ),
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
      ),
    );
  }
}

/// BLOCKBUSTER MEAL CAROUSEL
class BlockbusterMealCarousel extends StatefulWidget {
  final List<dynamic> meals;
  const BlockbusterMealCarousel({super.key, required this.meals});

  @override
  State<BlockbusterMealCarousel> createState() =>
      _BlockbusterMealCarouselState();
}

class _BlockbusterMealCarouselState extends State<BlockbusterMealCarousel> {
  late final PageController _pageController = PageController(
    viewportFraction: 0.74,
  )..addListener(_pageListener);
  double _currentPage = 0.0;

  final List<String> placeholderImages = [
    'https://images.unsplash.com/photo-1493770348161-369560ae357d?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80',
    'https://images.unsplash.com/photo-1490645935967-10de6ba17061?auto=format&fit=crop&w=800&q=80',
  ];

  void _pageListener() {
    if (mounted) {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.meals.isEmpty) {
      return Container(
        height: 220,
        margin: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color(0xff0B0817).withOpacity(0.55),
          border: Border.all(color: Colors.white.withOpacity(0.04)),
        ),
        child: Center(
          child: Text(
            "No active meal plans found.",
            style: GoogleFonts.inter(
              color: Colors.white.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        Transform.translate(
          offset: const Offset(
            -26,
            0,
          ), // Shift slightly left so first card aligns left
          child: SizedBox(
            height: 350,
            child: PageView.builder(
              controller: _pageController,
              physics: const BouncingScrollPhysics(),
              clipBehavior: Clip.none,
              itemCount: widget.meals.length,
              itemBuilder: (context, index) {
                double scale = 1.0;
                if (_pageController.hasClients &&
                    _pageController.positions.length == 1 &&
                    _pageController.position.haveDimensions) {
                  double pageOffset = _currentPage - index;
                  scale = (1 - (pageOffset.abs() * 0.15)).clamp(0.85, 1.0);
                } else {
                  scale = index == 0 ? 1.0 : 0.85;
                }

                final meal = widget.meals[index];
                final String imageUrl =
                    placeholderImages[index % placeholderImages.length];

                return _buildMovieStyleMealCard(meal, scale, imageUrl);
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Pagination Dots
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.meals.length, (index) {
            final isSelected = (_currentPage.round() == index);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              height: 6,
              width: isSelected ? 20 : 6,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white
                    : Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildMovieStyleMealCard(dynamic meal, double scale, String imageUrl) {
    return GestureDetector(
      onTap: () => Get.toNamed('/meal-plan'),
      child: Transform.scale(
        scale: scale,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.transparent,
            boxShadow: [
              if (scale > 0.95)
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 8),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Image Section (74% height) with fading bottom overlay ──
              Expanded(
                flex: 74,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xff1A0030),
                          child: const Icon(
                            Icons.restaurant_rounded,
                            color: Colors.white38,
                            size: 48,
                          ),
                        ),
                      ),
                      // Smooth gradient overlay to blend bottom of image with the black portion below it
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                const Color(0xff06010F).withOpacity(0.5),
                                const Color(0xff06010F).withOpacity(0.85),
                              ],
                              stops: const [0.7, 0.9, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Text Section (26% height) with fading bottom overlay to blend with app background ──
              Expanded(
                flex: 26,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xff06010F).withOpacity(0.85),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Big bold title
                      Text(
                        meal["title"] as String,
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Subtitle (kcal | macros)
                      Text(
                        "${meal["kcal"]} | ${meal["macros"]}",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.55),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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
