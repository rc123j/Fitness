import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class CongratulationsScreen extends StatefulWidget {
  final String memberCode;
  const CongratulationsScreen({super.key, required this.memberCode});

  @override
  State<CongratulationsScreen> createState() => _CongratulationsScreenState();
}

class _CongratulationsScreenState extends State<CongratulationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff050510),
      body: Stack(
        children: [
          // 1. Full Screen Image blended into dark background
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.7,
            child: ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                  stops: [
                    0.5,
                    1.0,
                  ], // Starts fading at 50%, fully transparent at bottom
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: Image.asset(
                'assets/new_images1/congratulation_screen.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback just in case the image path is slightly different
                  return Container(color: Colors.grey.withOpacity(0.1));
                },
              ),
            ),
          ),

          // 2. Content (Text + Swipe Button)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Your Personalized\nMeal Plan Is Waiting",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "We've calculated your exact macros and built a custom plan tailored to help you hit your fitness goals.",
                    style: GoogleFonts.outfit(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 15,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Bouncing Swipe Button
                  BouncingSwipeButton(
                    onSwipeComplete: () {
                      Get.offAllNamed('/main-navigation');
                    },
                  ),
                  const SizedBox(height: 10), // extra padding at bottom
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BouncingSwipeButton extends StatefulWidget {
  final VoidCallback onSwipeComplete;
  const BouncingSwipeButton({Key? key, required this.onSwipeComplete})
    : super(key: key);

  @override
  State<BouncingSwipeButton> createState() => _BouncingSwipeButtonState();
}

class _BouncingSwipeButtonState extends State<BouncingSwipeButton>
    with SingleTickerProviderStateMixin {
  double _dragPosition = 0.0;
  bool _isCompleted = false;
  bool _isDragging = false;
  late AnimationController _bounceController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _bounceAnimation = Tween<double>(begin: 0, end: 15).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double containerWidth = constraints.maxWidth;
        const double thumbWidth = 64.0;
        final double maxDragPosition =
            containerWidth - thumbWidth - 10; // 5 padding on each side

        return Container(
          height: 74,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08), // Dark theme glass container
            borderRadius: BorderRadius.circular(37),
            border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
          ),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: [
              // Center Text
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 20.0,
                  ), // offset for the thumb
                  child: Text(
                    "Start",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              // Bouncing Arrows on the right
              Positioned(
                right: 30,
                child: AnimatedBuilder(
                  animation: _bounceAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(_bounceAnimation.value, 0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white.withOpacity(0.2),
                            size: 24,
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white.withOpacity(0.5),
                            size: 24,
                          ),
                          Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Draggable Thumb (Smooth Snap Back)
              AnimatedPositioned(
                duration: _isDragging
                    ? Duration.zero
                    : const Duration(milliseconds: 400),
                curve: Curves
                    .easeOutBack, // Gives a playful spring effect when it snaps back
                left: 5 + _dragPosition,
                child: GestureDetector(
                  onHorizontalDragStart: (details) {
                    if (_isCompleted) return;
                    setState(() {
                      _isDragging = true;
                    });
                  },
                  onHorizontalDragUpdate: (details) {
                    if (_isCompleted) return;
                    setState(() {
                      _dragPosition += details.delta.dx;
                      if (_dragPosition < 0) _dragPosition = 0;
                      if (_dragPosition > maxDragPosition)
                        _dragPosition = maxDragPosition;
                    });
                  },
                  onHorizontalDragEnd: (details) {
                    if (_isCompleted) return;
                    setState(() {
                      _isDragging = false;
                    });

                    if (_dragPosition > maxDragPosition * 0.70) {
                      setState(() {
                        _dragPosition = maxDragPosition;
                        _isCompleted = true;
                      });
                      Future.delayed(const Duration(milliseconds: 200), () {
                        widget.onSwipeComplete();
                      });
                    } else {
                      // Smoothly animate back to 0 due to AnimatedPositioned
                      setState(() {
                        _dragPosition = 0;
                      });
                    }
                  },
                  child: Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.shopping_basket_rounded,
                        color: Colors.black,
                        size: 26,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
