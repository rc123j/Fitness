import 'dart:async';
import 'dart:math' as math;
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

  int _currentIndex = 0;
  int _prevIndex = 0;
  
  late AnimationController _transitionController;
  late AnimationController _floatController;
  
  Timer? _cycleTimer;

  // Transition Animations for Outgoing Image (Vanish down)
  late final Animation<double> _outgoingOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
    CurvedAnimation(
      parent: _transitionController,
      curve: const Interval(0.0, 0.40, curve: Curves.easeIn),
    ),
  );
  late final Animation<Offset> _outgoingSlide = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.0, 1.2), // Vanish downwards
  ).animate(
    CurvedAnimation(
      parent: _transitionController,
      curve: const Interval(0.0, 0.50, curve: Curves.easeInBack),
    ),
  );
  late final Animation<double> _outgoingScale = Tween<double>(begin: 1.0, end: 0.3).animate(
    CurvedAnimation(
      parent: _transitionController,
      curve: const Interval(0.0, 0.45, curve: Curves.easeIn),
    ),
  );

  // Transition Animations for Incoming Image (Appear from nowhere/Pop & Spin)
  late final Animation<double> _incomingOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _transitionController,
      curve: const Interval(0.20, 0.70, curve: Curves.easeOut),
    ),
  );
  late final Animation<double> _incomingScale = Tween<double>(begin: 0.0, end: 1.0).animate(
    CurvedAnimation(
      parent: _transitionController,
      curve: const Interval(0.20, 0.90, curve: Curves.elasticOut), // Organic elastic pop
    ),
  );
  late final Animation<double> _incomingRotation = Tween<double>(begin: -180 * math.pi / 180, end: 0.0).animate(
    CurvedAnimation(
      parent: _transitionController,
      curve: const Interval(0.20, 0.95, curve: Curves.easeOutBack), // Smooth spin & snap
    ),
  );

  // Float Animation
  late final Animation<double> _floatAnim = Tween<double>(begin: -4, end: 4).animate(
    CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
  );

  @override
  void initState() {
    super.initState();
    
    // Transition controller (950ms for smooth pop & spin)
    _transitionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 950),
    );

    // Floating controller (constant soft float, 2.2s cycle)
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    // Start cycle timer (3.2 seconds)
    _cycleTimer = Timer.periodic(const Duration(milliseconds: 3200), (timer) {
      _triggerNextItem();
    });

    // Start with the first animation completed (incoming at 1.0)
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

  @override
  Widget build(BuildContext context) {
    final current = _items[_currentIndex];
    final prev = _items[_prevIndex];

    return Container(
      height: 155,
      width: double.infinity,
      color: Colors.transparent, // Completely transparent section!
      child: Stack(
        children: [
          // Dynamic color glow behind image (Radial light)
          AnimatedBuilder(
            animation: _transitionController,
            builder: (context, child) {
              final double incomingWeight = _transitionController.value;
              final glowColor = Color.lerp(
                prev.accentColor,
                current.accentColor,
                incomingWeight,
              );

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
                        glowColor!.withOpacity(0.25),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Main Content Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Row(
              children: [
                // Left Side Info Section
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Heading transition: Flying from Left to Right!
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        transitionBuilder: (child, anim) {
                          // Check if this child is the current (incoming) title
                          final isIncoming = child.key == ValueKey<String>(current.title);
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: isIncoming ? const Offset(-1.2, 0.0) : const Offset(1.2, 0.0), // In from Left, Out to Right
                              end: Offset.zero,
                            ).animate(CurvedAnimation(
                              parent: anim,
                              curve: isIncoming ? Curves.easeOutBack : Curves.easeIn,
                            )),
                            child: FadeTransition(
                              opacity: anim,
                              child: child,
                            ),
                          );
                        },
                        child: Text(
                          current.title,
                          key: ValueKey<String>(current.title),
                          style: GoogleFonts.outfit(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // IS READY badge
                      Text(
                        "IS READY",
                        style: GoogleFonts.outfit(
                          color: const Color(0xffFFD166), // Vibrant golden highlight
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Animated Subtitle Details: Flying Left to Right
                      Row(
                        children: [
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 650),
                            transitionBuilder: (child, anim) {
                              final isIncoming = child.key == ValueKey<String>(current.subtitle);
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: isIncoming ? const Offset(-1.2, 0.0) : const Offset(1.2, 0.0),
                                  end: Offset.zero,
                                ).animate(CurvedAnimation(
                                  parent: anim,
                                  curve: isIncoming ? Curves.easeOutBack : Curves.easeIn,
                                )),
                                child: FadeTransition(
                                  opacity: anim,
                                  child: child,
                                ),
                              );
                            },
                            child: Text(
                              current.subtitle,
                              key: ValueKey<String>(current.subtitle),
                              style: GoogleFonts.outfit(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 13,
                                  fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Tiny Arrow CTA
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

                // Right Side: Pop & Spin In, Vanish Down
                Expanded(
                  flex: 2,
                  child: Stack(
                    alignment: Alignment.centerRight,
                    clipBehavior: Clip.none,
                    children: [
                      // Outgoing Image (Vanishing Down)
                      if (_transitionController.value < 1.0)
                        AnimatedBuilder(
                          animation: _transitionController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: _outgoingSlide.value,
                              child: Transform.scale(
                                scale: _outgoingScale.value,
                                child: Opacity(
                                  opacity: _outgoingOpacity.value,
                                  child: Image.asset(
                                    prev.imagePath,
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                      // Incoming Image (Appearing from Nowhere / Pop & Spin)
                      AnimatedBuilder(
                        animation: Listenable.merge([
                          _transitionController,
                          _floatController,
                        ]),
                        builder: (context, child) {
                          final double incomingWeight = _transitionController.value;
                          
                          final double currentScale = _incomingScale.value;
                          final double currentRotation = _incomingRotation.value;

                          // Apply floating offset ONLY when transition is done or mostly done
                          final double floatY = _floatAnim.value * incomingWeight;

                          return Transform.translate(
                            offset: Offset(0.0, floatY),
                            child: Transform.rotate(
                              angle: currentRotation,
                              child: Transform.scale(
                                scale: currentScale,
                                child: Opacity(
                                  opacity: _incomingOpacity.value,
                                  child: Image.asset(
                                    current.imagePath,
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.contain,
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
