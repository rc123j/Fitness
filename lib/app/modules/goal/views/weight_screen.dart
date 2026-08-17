import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../../services/onboarding_draft_service.dart';
import 'activity_level_screen.dart';

class WeightScreen extends StatefulWidget {
  final String goalTitle;
  final int goalId;
  final String gender;
  final int age;
  final int height;

  const WeightScreen({
    super.key,
    required this.goalTitle,
    required this.goalId,
    required this.gender,
    required this.age,
    required this.height,
  });

  @override
  State<WeightScreen> createState() => _WeightScreenState();
}

class _ThemeColors {
  static const purple = Color(0xff7B61FF);
  static const pink = Color(0xffFF00E5);
}

class _WeightScreenState extends State<WeightScreen> {
  double selectedWeight = 70.0;
  late ScrollController _scrollController;
  final double _itemWidth = 10.0; // width of each tick mark container

  @override
  void initState() {
    super.initState();
    // Load from draft if exists
    final draft = OnboardingDraftService.getDraft();
    if (draft['weight'] != null) {
      selectedWeight = (draft['weight'] as num).toDouble();
    }
    // Clamp to valid range (30kg to 180kg)
    if (selectedWeight < 30.0) {
      selectedWeight = 30.0;
    } else if (selectedWeight > 180.0) {
      selectedWeight = 180.0;
    }

    // Scroll offset calculation:
    // (selectedWeight - 30.0) is the weight range.
    // 0.1 kg increments means there are 10 items per 1 kg.
    // Scroll offset = targetIndex * _itemWidth.
    final initialOffset = (selectedWeight - 30.0) * 10 * _itemWidth;
    _scrollController = ScrollController(initialScrollOffset: initialOffset);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final offset = _scrollController.offset;
    double weight = 30.0 + (offset / _itemWidth) * 0.1;
    if (weight < 30.0) weight = 30.0;
    if (weight > 180.0) weight = 180.0;
    if ((selectedWeight - weight).abs() > 0.01) {
      setState(() {
        selectedWeight = weight;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _proceed() {
    OnboardingDraftService.saveStep5(weight: selectedWeight);
    Get.to(
      () => ActivityLevelScreen(
        goalTitle: widget.goalTitle,
        goalId: widget.goalId,
        gender: widget.gender,
        age: widget.age,
        height: widget.height,
        weight: selectedWeight,
      ),
      transition: Transition.rightToLeftWithFade,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = widget.gender == "Male"
        ? _ThemeColors.purple
        : _ThemeColors.pink;

    return Scaffold(
      backgroundColor: const Color(0xff050510),
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [themeColor.withOpacity(0.18), Colors.transparent],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    const Color(0xffFF7A00).withOpacity(0.12),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Button & Progress
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "STEP 5 OF 10",
                              style: GoogleFonts.outfit(
                                color: Colors.white,
                                fontSize: 11,
                                letterSpacing: 1.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: List.generate(10, (index) {
                                final active = index <= 4; // Steps 1-5 active
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

                  const SizedBox(height: 28),

                  // Title
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "What's your\n",
                          style: GoogleFonts.outfit(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                          ),
                        ),
                        TextSpan(
                          text: "Weight?",
                          style: GoogleFonts.outfit(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            height: 1.15,
                            foreground: Paint()
                              ..shader =
                                  const LinearGradient(
                                    colors: [
                                      Color(0xffFF00E5),
                                      Color(0xffFF7A00),
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
                    "Enter your current weight.",
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.50),
                      fontSize: 13,
                    ),
                  ),

                  // Weight visual layout
                  Expanded(
                    flex: 9,
                    child: Row(
                      children: [
                        // 1. Large Weight Display Text
                        Expanded(
                          flex: 4,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.baseline,
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Text(
                                        selectedWeight.toStringAsFixed(
                                          1,
                                        ), // shows decimal precision, e.g. 70.4
                                        style: GoogleFonts.outfit(
                                          color: Colors.white,
                                          fontSize: 38,
                                          fontWeight: FontWeight.w900,
                                          height: 1.0,
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      Text(
                                        "kg",
                                        style: GoogleFonts.outfit(
                                          color: themeColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Container(
                                  height: 3,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: themeColor,
                                    borderRadius: BorderRadius.circular(1.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: themeColor.withOpacity(0.50),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 7,
                          child: SizedBox.expand(
                            child: Transform.translate(
                              offset: const Offset(
                                0,
                                220,
                              ), // shifts the avatar down, static
                              child: Transform.scale(
                                scale: 2.0, // bigger static avatar
                                alignment: Alignment.bottomCenter,
                                child: Image.asset(
                                  widget.gender == "Male"
                                      ? "assets/new_images/man_weight.png"
                                      : "assets/new_images/female_weight.png",
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Icon(
                                      widget.gender == "Male"
                                          ? Icons.accessibility_new_rounded
                                          : Icons.woman_rounded,
                                      size: 240,
                                      color: themeColor.withOpacity(0.60),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 3. Horizontal scrolling weight scale — stable scrollable ruler
                  Container(
                    height: 125,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.02),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.05),
                        width: 1,
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.01),
                          Colors.white.withOpacity(0.03),
                        ],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final screenWidth = constraints.maxWidth;
                        final outerPadding = screenWidth / 2;
                        return Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            // The scrollable numbers + ticks
                            ListView.builder(
                              controller: _scrollController,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.symmetric(
                                horizontal: outerPadding - (_itemWidth / 2),
                              ),
                              itemCount: 1501, // 30.0 kg → 180.0 kg (0.1 kg steps)
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                final currentVal = 30.0 + index * 0.1;
                                final isWholeNumber = (index % 10) == 0;
                                final isHalfNumber = (index % 5) == 0;

                                final difference = (selectedWeight - currentVal).abs();
                                // Magnifying bubble factor: 1.0 when centered, 0.0 when 1.5kg or further away
                                final factor = (1.0 - (difference / 1.5)).clamp(0.0, 1.0);

                                final double tickHeight;
                                if (isWholeNumber) {
                                  tickHeight = 20.0 + (factor * 18.0); // 20 to 38
                                } else if (isHalfNumber) {
                                  tickHeight = 12.0 + (factor * 14.0); // 12 to 26
                                } else {
                                  tickHeight = 8.0 + (factor * 10.0);  // 8 to 18
                                }

                                final double tickWidth = 1.5 + (factor * 1.5); // 1.5 to 3.0

                                final tickColor = Color.lerp(
                                  Colors.white.withOpacity(0.15),
                                  themeColor,
                                  factor,
                                )!;

                                return SizedBox(
                                  width: _itemWidth,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Number label
                                      if (isWholeNumber)
                                        Text(
                                          currentVal.toInt().toString(),
                                          softWrap: false,
                                          overflow: TextOverflow.visible,
                                          style: GoogleFonts.outfit(
                                            color: Color.lerp(
                                              Colors.white.withOpacity(0.18),
                                              Colors.white,
                                              factor,
                                            )!,
                                            fontSize: 13.0 + (factor * 6.0), // 13 to 19
                                            fontWeight: FontWeight.lerp(
                                              FontWeight.w400,
                                              FontWeight.w900,
                                              factor,
                                            )!,
                                          ),
                                        )
                                      else
                                        const SizedBox(height: 25),
                                      const SizedBox(height: 10),
                                      // Tick mark
                                      Container(
                                        height: tickHeight,
                                        width: tickWidth,
                                        decoration: BoxDecoration(
                                          color: tickColor,
                                          borderRadius: BorderRadius.circular(1),
                                          boxShadow: factor > 0.8
                                              ? [
                                                  BoxShadow(
                                                    color: themeColor.withOpacity(0.4 * factor),
                                                    blurRadius: 4,
                                                    spreadRadius: 0.5,
                                                  ),
                                                ]
                                              : null,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                    ],
                                  ),
                                );
                              },
                            ),
                            // Static center indicator needle overlay
                            Positioned(
                              bottom: 6,
                              child: IgnorePointer(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      height: 42,
                                      width: 3,
                                      decoration: BoxDecoration(
                                        color: themeColor,
                                        borderRadius: BorderRadius.circular(1.5),
                                        boxShadow: [
                                          BoxShadow(
                                            color: themeColor.withOpacity(0.8),
                                            blurRadius: 8,
                                            spreadRadius: 1.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Container(
                                      width: 6,
                                      height: 6,
                                      decoration: BoxDecoration(
                                        color: themeColor,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: themeColor.withOpacity(0.8),
                                            blurRadius: 6,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const Spacer(),

                  // Next Button
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
                        onTap: _proceed,
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
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
