import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MealPromoItem {
  final String title;
  final String subtitle;
  final String imagePath;
  final Color accentColor;

  const MealPromoItem({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.accentColor,
  });
}

class PremiumMealPromoCard extends StatefulWidget {
  const PremiumMealPromoCard({super.key});

  @override
  State<PremiumMealPromoCard> createState() => _PremiumMealPromoCardState();
}

class _PremiumMealPromoCardState extends State<PremiumMealPromoCard>
    with TickerProviderStateMixin {

  final List<MealPromoItem> _items = [
    const MealPromoItem(
      title: "YOUR MEAL PLAN",
      subtitle: "Protein rich • 620 kcal",
      imagePath: "assets/new_images/non-veg.png",
      accentColor: Color(0xffFF9A3C),
    ),
    const MealPromoItem(
      title: "YOUR VEG PLAN",
      subtitle: "Balanced • 540 kcal",
      imagePath: "assets/new_images/vegeterian.png",
      accentColor: Color(0xff00E5A0),
    ),
    const MealPromoItem(
      title: "YOUR VEGAN PLAN",
      subtitle: "Fiber rich • 480 kcal",
      imagePath: "assets/new_images/vegan.png",
      accentColor: Color(0xffC97FFF),
    ),
    const MealPromoItem(
      title: "YOUR EGG PLAN",
      subtitle: "Protein rich • 510 kcal",
      imagePath: "assets/new_images/eggeterian.png",
      accentColor: Color(0xffFF6B9D),
    ),
    const MealPromoItem(
      title: "YOUR KETO PLAN",
      subtitle: "Low carb • 580 kcal",
      imagePath: "assets/new_images/keto.png",
      accentColor: Color(0xffFF3E3E),
    ),
  ];

  // Brand accent used for the (very subtle) static glow — no longer lerps
  // between each item's accentColor.
  static const Color _brandGlow = Color(0xffFFD166);

  // The overlap+settle transition runs inside this window; the remainder of
  // the 3200ms cycle is the "hold" where the image just floats in place.
  static const int _cycleMs = 3200;
  static const int _transitionMs = 1300;

  // Exit leads entry by a short beat (a "push", not a mirrored swap), and
  // both finish before the settle phase begins.
  static const double _exitStart = 0.0;
  static const double _exitEnd = 0.55;
  static const double _enterStart = 0.10;
  static const double _enterEnd = 0.68;

  int _currentIndex = 0;
  int _prevIndex = 0;

  late AnimationController _transitionController;
  late AnimationController _floatController;

  Timer? _cycleTimer;

  // ---- Outgoing image: pushed out left, fades, tiny scale-down + tilt ----
  late final Animation<double> _exitProgress = CurvedAnimation(
    parent: _transitionController,
    curve: const Interval(_exitStart, _exitEnd, curve: Curves.easeInOut),
  );
  late final Animation<double> _outgoingOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
    CurvedAnimation(parent: _transitionController, curve: const Interval(_exitStart, _exitEnd, curve: Curves.easeIn)),
  );
  late final Animation<double> _outgoingTranslateX = Tween<double>(begin: 0.0, end: -58.0).animate(_exitProgress);
  late final Animation<double> _outgoingScale = Tween<double>(begin: 1.0, end: 0.94).animate(_exitProgress);
  late final Animation<double> _outgoingRotation = Tween<double>(begin: 0.0, end: -2 * math.pi / 180).animate(_exitProgress);

  // ---- Incoming image: enters from the right, gentle overshoot settle ----
  late final Animation<double> _enterProgress = CurvedAnimation(
    parent: _transitionController,
    curve: const Interval(_enterStart, _enterEnd, curve: Curves.easeOutCubic),
  );
  late final Animation<double> _enterProgressLinear = CurvedAnimation(
    parent: _transitionController,
    curve: const Interval(_enterStart, _enterEnd, curve: Curves.linear),
  );
  late final Animation<double> _incomingOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(_enterProgress);
  late final Animation<double> _incomingTranslateX = Tween<double>(begin: 55.0, end: 0.0).animate(_enterProgress);
  late final Animation<double> _incomingRotation = Tween<double>(begin: 3 * math.pi / 180, end: 0.0).animate(_enterProgress);
  // 0.88 -> 1.02 during the entrance, then a quiet settle to 1.0.
  late final Animation<double> _incomingScale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween<double>(begin: 0.88, end: 1.02).chain(CurveTween(curve: Curves.easeOutCubic)),
      weight: 70,
    ),
    TweenSequenceItem(
      tween: Tween<double>(begin: 1.02, end: 1.0).chain(CurveTween(curve: Curves.easeOut)),
      weight: 30,
    ),
  ]).animate(_enterProgress);

  // ---- Continuous idle float (subtle, no bounce) ----
  late final Animation<double> _floatY = Tween<double>(begin: -3, end: 3).animate(
    CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
  );
  late final Animation<double> _floatRotation = Tween<double>(begin: -1 * math.pi / 180, end: 1 * math.pi / 180).animate(
    CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
  );
  // Decorative glow breathes very slightly — kept in the brand color family.
  late final Animation<double> _glowOpacity = Tween<double>(begin: 0.10, end: 0.16).animate(
    CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
  );
  late final Animation<double> _driftSmall = Tween<double>(begin: -2, end: 2).animate(
    CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
  );

  @override
  void initState() {
    super.initState();

    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _transitionMs),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _cycleTimer = Timer.periodic(const Duration(milliseconds: _cycleMs), (timer) {
      _triggerNextItem();
    });

    _transitionController.value = 1.0;
  }

  void _triggerNextItem() {
    if (!mounted) return;
    setState(() {
      _prevIndex = _currentIndex;
      _currentIndex = (_currentIndex + 1) % _items.length;
    });
    _transitionController.forward(from: 0.0);
  }

  @override
  void dispose() {
    _cycleTimer?.cancel();
    _transitionController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  // Bell curve (0 -> 1 -> 0) used to peak the motion-blur exactly mid-swipe
  // and settle it to zero by the time the image stops moving.
  double _blurBell(double progress) => math.sin((progress.clamp(0.0, 1.0)) * math.pi);

  // Fade + tiny vertical shift only — no horizontal flying text.
  Widget _buildDynamicText(String text, TextStyle style) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeOutCubic,
      transitionBuilder: (child, anim) {
        final isIncoming = child.key == ValueKey<String>(text);
        return AnimatedBuilder(
          animation: anim,
          child: child,
          builder: (context, child) {
            final dy = (1 - anim.value) * (isIncoming ? 8.0 : -8.0);
            return Opacity(
              opacity: anim.value,
              child: Transform.translate(offset: Offset(0, dy), child: child),
            );
          },
        );
      },
      child: Text(text, key: ValueKey<String>(text), style: style),
    );
  }

  // A soft blurred ellipse beneath the food so it reads as sitting in space
  // rather than pasted flat onto the card.
  Widget _buildGroundShadow({required double translateX, required double scale, required double opacity}) {
    return Transform.translate(
      offset: Offset(translateX, 50),
      child: Transform.scale(
        scaleX: scale * 0.85,
        scaleY: scale * 0.30,
        child: Opacity(
          opacity: opacity * 0.28,
          child: ImageFiltered(
            imageFilter: ui.ImageFilter.blur(sigmaX: 9, sigmaY: 5),
            child: Container(
              width: 92,
              height: 30,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // A faint diagonal light streak that passes over the incoming dish once,
  // like a product-shot glint — the cheap-in-Flutter version of a specular
  // pass a motion designer would bake into a rendered animation.
  Widget _buildGlint({required Widget child, required double sweep, required double strength}) {
    if (strength <= 0.001) return child;
    return ShaderMask(
      blendMode: BlendMode.softLight,
      shaderCallback: (bounds) {
        final center = -0.6 + sweep * 2.2;
        return LinearGradient(
          begin: Alignment(center - 0.55, -1),
          end: Alignment(center + 0.55, 1),
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.45 * strength),
            Colors.transparent,
          ],
          stops: const [0.35, 0.5, 0.65],
        ).createShader(bounds);
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = _items[_currentIndex];
    final prev = _items[_prevIndex];

    return Container(
      height: 155,
      width: double.infinity,
      color: Colors.transparent,
      child: Stack(
        children: [
          // Static, very subtle brand-color glow — no longer shifts hue per item.
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Positioned(
                right: -40,
                top: -20,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        _brandGlow.withOpacity(_glowOpacity.value),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          // A second, much smaller soft blob for a touch of depth/parallax —
          // moves independently and very slightly from the main glow.
          AnimatedBuilder(
            animation: _floatController,
            builder: (context, child) {
              return Positioned(
                right: 70 + _driftSmall.value,
                bottom: 4 - _driftSmall.value,
                child: Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05),
                  ),
                ),
              );
            },
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildDynamicText(
                        current.title,
                        GoogleFonts.outfit(
                          color: Colors.white.withOpacity(0.95),
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        "IS READY",
                        style: GoogleFonts.outfit(
                          color: const Color(0xffFFD166),
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          _buildDynamicText(
                            current.subtitle,
                            GoogleFonts.outfit(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            color: Color(0xffFFD166),
                            size: 14,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Right side: previous image is pushed out left while the
                // next image enters from the right — both visible at once.
                Expanded(
                  flex: 2,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    clipBehavior: Clip.none,
                    children: [
                      if (_transitionController.value < 1.0) ...[
                        AnimatedBuilder(
                          animation: _transitionController,
                          builder: (context, child) {
                            return _buildGroundShadow(
                              translateX: _outgoingTranslateX.value,
                              scale: _outgoingScale.value,
                              opacity: _outgoingOpacity.value,
                            );
                          },
                        ),
                        AnimatedBuilder(
                          animation: _transitionController,
                          builder: (context, child) {
                            final blur = _blurBell(_exitProgress.value) * 3.2;
                            return Transform.translate(
                              offset: Offset(_outgoingTranslateX.value, 0.0),
                              child: Transform.rotate(
                                angle: _outgoingRotation.value,
                                child: Transform.scale(
                                  scale: _outgoingScale.value,
                                  child: Opacity(
                                    opacity: _outgoingOpacity.value,
                                    child: ImageFiltered(
                                      imageFilter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur * 0.15),
                                      child: Image.asset(
                                        prev.imagePath,
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],

                      AnimatedBuilder(
                        animation: _transitionController,
                        builder: (context, child) {
                          return _buildGroundShadow(
                            translateX: _incomingTranslateX.value,
                            scale: _incomingScale.value,
                            opacity: _incomingOpacity.value,
                          );
                        },
                      ),

                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _transitionController,
                          _floatController,
                        ]),
                        builder: (context, child) {
                          // Only float once the entrance has settled, so the
                          // idle motion doesn't fight the entrance motion.
                          final settleWeight = _incomingOpacity.value;
                          final floatY = _floatY.value * settleWeight;
                          final floatRotation = _floatRotation.value * settleWeight;
                          final blur = _blurBell(_enterProgressLinear.value) * 3.2;

                          return Transform.translate(
                            offset: Offset(_incomingTranslateX.value, floatY),
                            child: Transform.rotate(
                              angle: _incomingRotation.value + floatRotation,
                              child: Transform.scale(
                                scale: _incomingScale.value,
                                child: Opacity(
                                  opacity: _incomingOpacity.value,
                                  child: ImageFiltered(
                                    imageFilter: ui.ImageFilter.blur(sigmaX: blur, sigmaY: blur * 0.15),
                                    child: _buildGlint(
                                      sweep: _enterProgressLinear.value,
                                      strength: _incomingOpacity.value,
                                      child: Image.asset(
                                        current.imagePath,
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
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
