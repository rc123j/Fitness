import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RocketLaunchOverlay {
  static void show(BuildContext context, {String mealTitle = ""}) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _RocketScene(onDone: () => entry.remove()),
    );
    overlay.insert(entry);
  }
}

class _RocketScene extends StatefulWidget {
  final VoidCallback onDone;
  const _RocketScene({required this.onDone});
  @override
  State<_RocketScene> createState() => _RocketSceneState();
}

class _RocketSceneState extends State<_RocketScene> with TickerProviderStateMixin {
  late final AnimationController _rocketCtrl;
  late final AnimationController _blastCtrl;
  late final AnimationController _shakeCtrl;

  late final Animation<double> _rocketY;
  late final Animation<double> _rocketScale;
  late final Animation<double> _dimOpacity;
  late final Animation<double> _rotationAnim;

  bool _blasting = false;
  final List<_Confetti> _confetti = [];
  final List<_ExhaustDrop> _exhaustDrops = [];
  final math.Random _rng = math.Random();

  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();

    // Rocket rises (900 ms)
    _rocketCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _rocketY = Tween<double>(begin: 1.15, end: 0.40).animate(
      CurvedAnimation(parent: _rocketCtrl, curve: Curves.easeOutQuart),
    );

    _rocketScale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.4), weight: 15),
      TweenSequenceItem(tween: Tween(begin: 1.4, end: 1.0), weight: 85),
    ]).animate(_rocketCtrl);

    _dimOpacity = Tween<double>(begin: 0.0, end: 0.60).animate(
      CurvedAnimation(parent: _rocketCtrl, curve: const Interval(0.0, 0.4, curve: Curves.easeOut)),
    );

    _rotationAnim = Tween<double>(begin: 0.0, end: -0.15).animate(
      CurvedAnimation(parent: _rocketCtrl, curve: Curves.easeOut),
    );

    // Blast and Confetti drift (1800 ms)
    _blastCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _shakeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _rocketCtrl.addListener(() {
      _spawnExhaust();
      _tickExhaust();
      setState(() {});
    });

    _blastCtrl.addListener(() {
      _tickConfetti();
      setState(() {});
    });

    _shakeCtrl.addListener(() => setState(() {}));

    _rocketCtrl.addStatusListener((s) {
      if (s == AnimationStatus.completed && !_blasting) {
        _blasting = true;
        HapticFeedback.vibrate();
        _spawnConfetti();
        _shakeCtrl.forward();
        _blastCtrl.forward().whenComplete(widget.onDone);
      }
    });

    _rocketCtrl.forward();
  }

  void _spawnExhaust() {
    if (_rng.nextDouble() < 0.7) {
      _exhaustDrops.add(_ExhaustDrop(
        life: 1.0,
        size: _rng.nextDouble() * 12 + 6,
        dx: (_rng.nextDouble() - 0.5) * 16,
        speed: _rng.nextDouble() * 7 + 5,
        color: _exhaustColors[_rng.nextInt(_exhaustColors.length)],
      ));
    }
  }

  void _tickExhaust() {
    for (final d in _exhaustDrops) {
      d.y += d.speed;
      d.life -= 0.06;
    }
    _exhaustDrops.removeWhere((d) => d.life <= 0);
  }

  void _spawnConfetti() {
    // Spawn 65 pieces of colorful confetti shooting out in all directions
    for (int i = 0; i < 65; i++) {
      final angle = _rng.nextDouble() * math.pi * 2;
      final speed = _rng.nextDouble() * 450 + 150;
      final color = _confettiColors[_rng.nextInt(_confettiColors.length)];
      _confetti.add(_Confetti(
        angle: angle,
        speed: speed,
        size: _rng.nextDouble() * 10 + 6,
        color: color,
        rotationSpeed: (_rng.nextDouble() - 0.5) * 8,
        swaySpeed: _rng.nextDouble() * 3 + 1,
        swayAmplitude: _rng.nextDouble() * 4 + 2,
        isRound: _rng.nextBool(),
      ));
    }
  }

  void _tickConfetti() {
    final t = _blastCtrl.value;
    for (final c in _confetti) {
      // Confetti movement: initially shoots out, then falls down with gravity and sways
      final double rad = t * c.speed;
      c.x = math.cos(c.angle) * rad + math.sin(t * c.swaySpeed * math.pi) * c.swayAmplitude * t;
      c.y = math.sin(c.angle) * rad + (t * t * 350); // Gravity pull down
      c.rotation = t * c.rotationSpeed * math.pi;
    }
  }

  static const _exhaustColors = [
    Color(0xffFF5F00), Color(0xffFFD600),
    Color(0xffFF0055), Color(0xffFFFFFF),
  ];

  static const _confettiColors = [
    Color(0xffFF007F), Color(0xff00FF66), Color(0xff00E5FF),
    Color(0xffFFD600), Color(0xffB100FF), Color(0xffFF5500),
    Color(0xffFFFFFF), Color(0xffFF00D4), Color(0xff00FFCC),
  ];

  Offset _shakeOffset() {
    if (!_blasting || _shakeCtrl.value >= 1.0) return Offset.zero;
    final t = _shakeCtrl.value;
    final mag = (1.0 - t) * 10;
    return Offset(
      math.sin(t * math.pi * 12) * mag,
      math.cos(t * math.pi * 10) * mag,
    );
  }

  @override
  void dispose() {
    _rocketCtrl.dispose();
    _blastCtrl.dispose();
    _shakeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final cx = size.width / 2;
    final cy = size.height * _rocketY.value;
    final blastCy = size.height * 0.40;
    final shake = _shakeOffset();
    final bv = _blastCtrl.value;
    final dimFade = _blasting ? (1.0 - bv * bv).clamp(0.0, 1.0) : 1.0;

    return IgnorePointer(
      child: Transform.translate(
        offset: shake,
        child: Stack(
          children: [
            // Darkening veil
            Opacity(
              opacity: (_dimOpacity.value * dimFade).clamp(0.0, 1.0),
              child: Container(color: Colors.black),
            ),

            // Engine Fire Trail
            CustomPaint(
              size: size,
              painter: _TrailPainter(
                rocketX: cx,
                rocketY: cy,
                progress: _rocketCtrl.value,
                exhaustDrops: List.from(_exhaustDrops),
                blastProgress: bv,
              ),
            ),

            // Confetti Explosion
            if (_blasting)
              CustomPaint(
                size: size,
                painter: _BlastPainter(
                  cx: cx,
                  cy: blastCy,
                  progress: bv,
                  confetti: _confetti,
                ),
              ),

            // Rocket Body
            if (!_blasting || bv < 0.15)
              Positioned(
                left: cx - 38,
                top: cy - 38,
                child: Transform.scale(
                  scale: _rocketScale.value,
                  child: Transform.rotate(
                    angle: _rotationAnim.value,
                    child: Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xffFF00D4).withOpacity(0.8),
                            blurRadius: 35,
                            spreadRadius: 8,
                          ),
                          BoxShadow(
                            color: const Color(0xffFF7A00).withOpacity(0.5),
                            blurRadius: 18,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.rocket_launch_rounded,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _TrailPainter extends CustomPainter {
  final double rocketX, rocketY, progress, blastProgress;
  final List<_ExhaustDrop> exhaustDrops;

  _TrailPainter({
    required this.rocketX,
    required this.rocketY,
    required this.progress,
    required this.exhaustDrops,
    required this.blastProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final trailFade = (1.0 - blastProgress * 2.0).clamp(0.0, 1.0);
    if (progress <= 0 || trailFade <= 0) return;

    final bottom = size.height * 1.15;
    final len = bottom - rocketY;

    // Glowing Shader Trail
    final po = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 48
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 18)
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xffFF00D4).withOpacity(0.55 * trailFade),
          const Color(0xffFF7A00).withOpacity(0.3 * trailFade),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(rocketX - 24, rocketY, 48, len));

    final pc = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withOpacity(0.95 * trailFade),
          const Color(0xffFFE500).withOpacity(0.85 * trailFade),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(rocketX - 4, rocketY, 8, len));

    final path = Path()
      ..moveTo(rocketX, bottom)
      ..lineTo(rocketX, rocketY + 36);

    canvas.drawPath(path, po);
    canvas.drawPath(path, pc);

    final ep = Paint()..style = PaintingStyle.fill;
    for (final d in exhaustDrops) {
      ep
        ..color = d.color.withOpacity(d.life * trailFade)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, d.size * 0.5);
      canvas.drawCircle(Offset(rocketX + d.dx, rocketY + 36 + d.y), d.size * 0.5, ep);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}

class _BlastPainter extends CustomPainter {
  final double cx, cy, progress;
  final List<_Confetti> confetti;

  _BlastPainter({
    required this.cx,
    required this.cy,
    required this.progress,
    required this.confetti,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final t = progress;

    // 1. Energy shockwave circle
    final shockwaveT = (t / 0.4).clamp(0.0, 1.0);
    if (shockwaveT > 0 && shockwaveT < 1.0) {
      final rad = shockwaveT * 260;
      final alpha = (1.0 - shockwaveT).clamp(0.0, 1.0);
      final swPaint = Paint()
        ..color = const Color(0xff00FFCC).withOpacity(alpha * 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = (1.0 - shockwaveT) * 20 + 2
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
      canvas.drawCircle(Offset(cx, cy), rad, swPaint);
    }

    // 2. Central white-hot flash
    final flashT = (t / 0.2).clamp(0.0, 1.0);
    final fa = (flashT * (1.0 - flashT) * 4).clamp(0.0, 1.0);
    if (fa > 0) {
      canvas.drawCircle(
        Offset(cx, cy),
        90 * flashT,
        Paint()
          ..color = Colors.white.withOpacity(fa * 0.9)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 35),
      );
    }

    // 3. Confetti rendering (Drifting sways and spins)
    final pPaint = Paint()..style = PaintingStyle.fill;
    for (final c in confetti) {
      final px = cx + c.x;
      final py = cy + c.y;

      final alpha = (1.0 - t).clamp(0.0, 1.0);
      pPaint.color = c.color.withOpacity(alpha);

      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(c.rotation);

      if (c.isRound) {
        canvas.drawCircle(Offset.zero, c.size * 0.5, pPaint);
      } else {
        // Draw rectangle confetti
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: c.size, height: c.size * 0.5),
          pPaint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => true;
}

class _Confetti {
  final double angle, speed, size;
  final Color color;
  final double rotationSpeed;
  final double swaySpeed;
  final double swayAmplitude;
  final bool isRound;

  double x = 0;
  double y = 0;
  double rotation = 0;

  _Confetti({
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
    required this.rotationSpeed,
    required this.swaySpeed,
    required this.swayAmplitude,
    required this.isRound,
  });
}

class _ExhaustDrop {
  double y = 0;
  double life;
  double size, dx, speed;
  Color color;
  _ExhaustDrop({
    required this.life,
    required this.size,
    required this.dx,
    required this.speed,
    required this.color,
  });
}
