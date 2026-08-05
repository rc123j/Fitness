import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../services/onboarding_draft_service.dart';
import 'dietary_preferences_screen.dart';

class ActivityLevelScreen extends StatefulWidget {
  final String goalTitle;
  final int goalId;
  final String gender;
  final int age;
  final int height;
  final double weight;

  const ActivityLevelScreen({
    super.key,
    required this.goalTitle,
    required this.goalId,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
  });

  @override
  State<ActivityLevelScreen> createState() => _ActivityLevelScreenState();
}

class _ActivityLevelScreenState extends State<ActivityLevelScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 2; // Default to Moderately Active

  late AnimationController _shineController;
  late Animation<double> _shineAnimation;

  @override
  void initState() {
    super.initState();
    _shineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _shineAnimation = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );
    _shineController.repeat(reverse: false);
  }

  @override
  void dispose() {
    _shineController.dispose();
    super.dispose();
  }

  final List<Map<String, dynamic>> activityLevels = [
    {
      "id": 1,
      "title": "Sedentary",
      "desc":
          "Little to no regular physical activity. Desk job, reading or sitting.",
      "multiplier": 1.2,
      "image": "assets/new_images/sedentry.png",
      "color": const Color(0xffFF5F6D),
    },
    {
      "id": 2,
      "title": "Lightly Active",
      "desc":
          "Light exercise or sports 1-3 days per week. Light walking, gardening.",
      "multiplier": 1.375,
      "image": "assets/new_images/lightly_active.png",
      "color": const Color(0xffFF7A00),
    },
    {
      "id": 3,
      "title": "Moderately Active",
      "desc": "Moderate workout, gym sessions, or sports 3-5 days per week.",
      "multiplier": 1.55,
      "image": "assets/new_images/modrate_active.png",
      "color": const Color(0xffC026D3),
    },
    {
      "id": 4,
      "title": "Very Active",
      "desc":
          "Hard exercise, high-intensity training, or sports 6-7 days per week.",
      "multiplier": 1.725,
      "image": "assets/new_images/very_active.png",
      "color": const Color(0xff7B61FF),
    },
    {
      "id": 5,
      "title": "Extra Active",
      "desc":
          "Extremely hard daily training/sports & physical job (e.g. athlete, construction).",
      "multiplier": 1.9,
      "image": "assets/new_images/extra_active.png",
      "color": const Color(0xff00E5FF),
    },
  ];

  double _getMultiplier(int id) {
    final g = widget.gender.toLowerCase();
    final isMale = g == 'male' || g == 'm';
    switch (id) {
      case 1:
        return 1.3;
      case 2:
        return isMale ? 1.6 : 1.5;
      case 3:
        return isMale ? 1.7 : 1.6;
      case 4:
        return isMale ? 2.1 : 1.9;
      case 5:
        return isMale ? 2.4 : 2.2;
      default:
        return 1.3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050510),
      body: Stack(
        children: [
          /// BACKGROUND GLOW (Bottom Left / Top Right)
          Positioned(
            bottom: -100,
            left: -80,
            child: Container(
              height: 320,
              width: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffC026D3).withOpacity(0.15),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            top: -50,
            right: -50,
            child: Container(
              height: 250,
              width: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xff00E5FF).withOpacity(0.18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// 1. TOP PROGRESS BAR & BACK BUTTON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Arrow
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.04),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.08),
                              width: 0.8,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),

                      // Step Indicator
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "STEP 6 OF 10",
                              style: GoogleFonts.outfit(
                                color: const Color(0xffFF00E5).withOpacity(0.9),
                                fontSize: 11,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: List.generate(10, (index) {
                                final active = index <= 5; // Steps 1-6 active
                                return Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                      right: index == 9 ? 0 : 4,
                                    ),
                                    height: 3.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      gradient: active
                                          ? const LinearGradient(
                                              colors: [
                                                Color(0xffFF00E5),
                                                Color(0xffFF7A00),
                                              ],
                                            )
                                          : null,
                                      color: active
                                          ? null
                                          : Colors.white.withOpacity(0.10),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  /// 2. TITLE & TEXT
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "What is your\nActivity ",
                          style: GoogleFonts.outfit(
                            height: 1.1,
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        TextSpan(
                          text: "Level?",
                          style: GoogleFonts.outfit(
                            height: 1.1,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            foreground: Paint()
                              ..shader =
                                  const LinearGradient(
                                    colors: [
                                      Color(0xffFF7A00),
                                      Color(0xffC026D3),
                                    ],
                                  ).createShader(
                                    const Rect.fromLTWH(0.0, 0.0, 200.0, 50.0),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Your daily physical activity determines your total daily energy expenditure (TDEE).",
                    style: GoogleFonts.inter(
                      color: Colors.white.withOpacity(0.60),
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// 3. ACTIVITY LEVELS LIST
                  buildActivityCard(0),
                  const SizedBox(height: 8),
                  buildActivityCard(1),
                  const SizedBox(height: 8),
                  buildActivityCard(2),
                  const SizedBox(height: 8),
                  buildActivityCard(3),
                  const SizedBox(height: 8),
                  buildActivityCard(4),

                  const Spacer(),

                  /// 4. CONTINUE BUTTON
                  Container(
                    height: 48,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xffB100FF),
                          Color(0xffFF5F6D),
                          Color(0xffFF7A00),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xffB100FF).withOpacity(0.30),
                          blurRadius: 10,
                          spreadRadius: 1,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(24),
                        onTap: () {
                          final selectedLevel = activityLevels[selectedIndex];
                          OnboardingDraftService.saveStep6(
                            activityLevelId: selectedLevel["id"] as int,
                            activityLevelName: selectedLevel["title"] as String,
                          );
                          Get.to(
                            () => DietaryPreferencesScreen(
                              goalTitle: widget.goalTitle,
                              goalId: widget.goalId,
                              gender: widget.gender,
                              age: widget.age,
                              height: widget.height,
                              weight: widget.weight,
                              activityLevelId: selectedLevel["id"] as int,
                              activityLevelName: selectedLevel["title"],
                            ),
                            transition: Transition.cupertino,
                          );
                        },
                        child: Center(
                          child: Text(
                            "Continue",
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildProgress(bool active) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      height: 3,
      width: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.5),
        gradient: active
            ? const LinearGradient(
                colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
              )
            : null,
        color: active ? null : Colors.white.withOpacity(0.12),
      ),
    );
  }

  Widget buildActivityCard(int index) {
    final activity = activityLevels[index];
    final isSelected = selectedIndex == index;
    final themeColor = activity["color"] as Color;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.12), width: 0.8),
          gradient: isSelected
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xffFF00E5), Color(0xffFF7A00)],
                )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.05),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xffFF00E5).withOpacity(0.15),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Container(
          margin: const EdgeInsets.all(1.2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.5),
            color: const Color(0xff090918),
          ),
          child: Row(
            children: [
              // Icon with shine animation
              SizedBox(
                height: 72,
                width: 72,
                child: OverflowBox(
                  maxHeight: 140,
                  maxWidth: 140,
                  child: AnimatedBuilder(
                    animation: _shineAnimation,
                    builder: (context, child) {
                      return ShaderMask(
                        blendMode: BlendMode.srcATop,
                        shaderCallback: (rect) {
                          final x = _shineAnimation.value;
                          return LinearGradient(
                            begin: Alignment(x - 1.5, -1.0),
                            end: Alignment(x + 1.5, 1.0),
                            colors: [
                              Colors.white.withOpacity(0.0),
                              Colors.white.withOpacity(0.15),
                              const Color(0xffFFE8A0).withOpacity(0.35),
                              Colors.white.withOpacity(0.15),
                              Colors.white.withOpacity(0.0),
                            ],
                            stops: const [0.0, 0.4, 0.5, 0.6, 1.0],
                          ).createShader(rect);
                        },
                        child: child,
                      );
                    },
                    child: Image.asset(
                      activity["image"] as String,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          activity["title"] as String,
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1.5,
                          ),
                          decoration: BoxDecoration(
                            color: themeColor.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "x${_getMultiplier(activity["id"] as int)}",
                            style: GoogleFonts.outfit(
                              color: themeColor,
                              fontSize: 9.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      activity["desc"] as String,
                      style: GoogleFonts.inter(
                        color: Colors.white.withOpacity(0.50),
                        fontSize: 12,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),

              // Checkmark Badge
              if (isSelected)
                Container(
                  height: 16,
                  width: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.black,
                    size: 11,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
