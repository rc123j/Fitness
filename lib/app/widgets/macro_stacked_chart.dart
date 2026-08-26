import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Macro accent colours — kept in sync with the Progress screen's
/// "Today's Nutrition" ring so the two reads match.
const kProteinColor = Color(0xff00A2FF);
const kCarbsColor = Color(0xffFF7A00);
const kFatColor = Color(0xffFF00E5);
const _kTargetColor = Color(0xffFFB020);

String _thousands(int n) => n.toString().replaceAllMapped(
  RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
  (m) => '${m[1]},',
);

/// A day's logged intake for the chart.
/// `{ date: 'yyyy-MM-dd', calories: num, protein: num, carbs: num, fat: num }`
class MacroDay {
  final String date;
  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  MacroDay({
    required this.date,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  factory MacroDay.fromMap(Map<String, dynamic> m) => MacroDay(
    date: m['date']?.toString() ?? '',
    calories: double.tryParse(m['calories']?.toString() ?? '0') ?? 0,
    protein: double.tryParse(m['protein']?.toString() ?? '0') ?? 0,
    carbs: double.tryParse(m['carbs']?.toString() ?? '0') ?? 0,
    fat: double.tryParse(m['fat']?.toString() ?? '0') ?? 0,
  );

  /// Calories implied by the macros (4 / 4 / 9 kcal per gram).
  double get macroKcal => protein * 4 + carbs * 4 + fat * 9;
  bool get isEmpty => calories <= 0 && macroKcal <= 0;
}

/// Stacked-bar intake chart: one bar per day, split into protein / carbs /
/// fat by calorie share, bar height = that day's calories, with a dashed
/// calorie-target line. Tap a bar to read its exact numbers.
///
/// Deliberately a different read from the flat single-colour calorie bars
/// on the Progress screen — this one carries kcal *and* the macro split in
/// a single mark.
class MacroStackedChart extends StatefulWidget {
  /// Oldest day first.
  final List<MacroDay> days;
  final double targetCalories;
  final double height;

  const MacroStackedChart({
    super.key,
    required this.days,
    required this.targetCalories,
    this.height = 240,
  });

  @override
  State<MacroStackedChart> createState() => _MacroStackedChartState();
}

class _MacroStackedChartState extends State<MacroStackedChart> {
  static const double _slotWidth = 40.0;
  static const double _yAxisWidth = 34.0;
  int? _selected;

  @override
  void initState() {
    super.initState();
    // Start with the most recent day selected so numbers are visible.
    if (widget.days.isNotEmpty) _selected = widget.days.length - 1;
  }

  @override
  void didUpdateWidget(covariant MacroStackedChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selected != null && _selected! >= widget.days.length) {
      _selected = widget.days.isEmpty ? null : widget.days.length - 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.days.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            "Nothing logged yet",
            style: GoogleFonts.inter(color: Colors.white.withOpacity(0.4)),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final naturalWidth =
            _yAxisWidth + widget.days.length * _slotWidth;
        final chartWidth = max(constraints.maxWidth, naturalWidth);
        // When there are only a few days, widen each slot so the bars
        // spread across the card instead of bunching on the left.
        final slot = (chartWidth - _yAxisWidth) / widget.days.length;

        return SizedBox(
          height: widget.height,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            reverse: true, // opens scrolled to the most recent day
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: chartWidth,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (d) {
                  final plotX = d.localPosition.dx - _yAxisWidth;
                  if (plotX < 0) return;
                  final i = (plotX / slot).floor();
                  if (i >= 0 && i < widget.days.length) {
                    setState(() => _selected = i);
                  }
                },
                child: CustomPaint(
                  painter: _MacroStackedPainter(
                    days: widget.days,
                    target: widget.targetCalories,
                    selected: _selected,
                    yAxisWidth: _yAxisWidth,
                    slotWidth: slot,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MacroStackedPainter extends CustomPainter {
  final List<MacroDay> days;
  final double target;
  final int? selected;
  final double yAxisWidth;
  final double slotWidth;

  _MacroStackedPainter({
    required this.days,
    required this.target,
    required this.selected,
    required this.yAxisWidth,
    required this.slotWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    const double xAxisHeight = 24.0;
    const double topPad = 44.0; // headroom for the tooltip
    final double chartTop = topPad;
    final double chartBottom = size.height - xAxisHeight;
    final double chartHeight = chartBottom - chartTop;
    final double barWidth = 20.0;

    double maxVal = max(target * 1.15, 2000);
    for (final d in days) {
      maxVal = max(maxVal, d.calories);
      maxVal = max(maxVal, d.macroKcal);
    }
    maxVal = (maxVal / 500).ceil() * 500.0;

    double yFor(double v) => chartBottom - (v / maxVal) * chartHeight;

    // ---- Y grid + labels ----
    final gridStep = maxVal <= 3000 ? 500.0 : 1000.0;
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 1;
    for (double v = 0; v <= maxVal + 1; v += gridStep) {
      final y = yFor(v);
      canvas.drawLine(Offset(yAxisWidth, y), Offset(size.width, y), gridPaint);
      final label = v == 0
          ? '0'
          : (v % 1000 == 0
                ? '${(v / 1000).toInt()}K'
                : '${(v / 1000).toStringAsFixed(1)}K');
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: GoogleFonts.inter(
            color: Colors.white.withOpacity(0.4),
            fontSize: 9,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height / 2));
    }

    // ---- target dashed line ----
    if (target > 0 && target <= maxVal) {
      final ty = yFor(target);
      final tPaint = Paint()
        ..color = _kTargetColor.withOpacity(0.8)
        ..strokeWidth = 1.3;
      for (double x = yAxisWidth; x < size.width; x += 9) {
        canvas.drawLine(Offset(x, ty), Offset(x + 5, ty), tPaint);
      }
    }

    // ---- bars ----
    for (int i = 0; i < days.length; i++) {
      final d = days[i];
      final cx = yAxisWidth + slotWidth * i + slotWidth / 2;
      final x = cx - barWidth / 2;
      final isSel = selected == i;

      if (d.isEmpty) {
        // missed day — a faint baseline tick
        final mp = Paint()
          ..color = Colors.white.withOpacity(0.14)
          ..strokeWidth = 2.5
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(
          Offset(x + 3, chartBottom),
          Offset(x + barWidth - 3, chartBottom),
          mp,
        );
      } else {
        // Split the day's *actual* calories in proportion to the macro
        // calorie contribution, so bar height == calories and the
        // segments still read as the P/C/F share.
        final total = d.macroKcal > 0 ? d.macroKcal : 1.0;
        final barTotalKcal = d.calories > 0 ? d.calories : d.macroKcal;
        final pK = d.macroKcal > 0
            ? d.protein * 4 / total * barTotalKcal
            : barTotalKcal;
        final cK = d.macroKcal > 0 ? d.carbs * 4 / total * barTotalKcal : 0.0;
        final fK = d.macroKcal > 0 ? d.fat * 9 / total * barTotalKcal : 0.0;

        double cursor = chartBottom;
        void seg(double kcal, Color color, {bool roundTop = false}) {
          if (kcal <= 0) return;
          final segH = (kcal / maxVal) * chartHeight;
          final rect = Rect.fromLTWH(x, cursor - segH, barWidth, segH);
          final rr = roundTop
              ? RRect.fromRectAndCorners(
                  rect,
                  topLeft: const Radius.circular(5),
                  topRight: const Radius.circular(5),
                )
              : RRect.fromRectAndRadius(rect, Radius.zero);
          canvas.drawRRect(
            rr,
            Paint()..color = color.withOpacity(isSel ? 1.0 : 0.78),
          );
          cursor -= segH;
        }

        seg(pK, kProteinColor);
        seg(cK, kCarbsColor);
        seg(fK, kFatColor, roundTop: true);

        if (isSel) {
          final topY = yFor(barTotalKcal);
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(x - 2, topY - 2, barWidth + 4, chartBottom - topY + 2),
              const Radius.circular(6),
            ),
            Paint()
              ..color = Colors.white.withOpacity(0.9)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 1.4,
          );
        }
      }

      // x-axis date label
      final label = _shortDate(d.date);
      final lp = TextPainter(
        text: TextSpan(
          text: label,
          style: GoogleFonts.inter(
            color: Colors.white.withOpacity(isSel ? 0.9 : 0.5),
            fontSize: 9,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      lp.paint(canvas, Offset(cx - lp.width / 2, chartBottom + 8));
    }

    // ---- tooltip for the selected bar ----
    if (selected != null && selected! >= 0 && selected! < days.length) {
      final d = days[selected!];
      if (!d.isEmpty) {
        final cx = yAxisWidth + slotWidth * selected! + slotWidth / 2;
        _paintTooltip(canvas, size, cx, d);
      }
    }
  }

  void _paintTooltip(Canvas canvas, Size size, double cx, MacroDay d) {
    final kcal = (d.calories > 0 ? d.calories : d.macroKcal).round();
    final line1 = '${_thousands(kcal)} kcal';
    final line2 =
        'P ${d.protein.round()}   C ${d.carbs.round()}   F ${d.fat.round()}';

    final tp1 = TextPainter(
      text: TextSpan(
        text: line1,
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final tp2 = TextPainter(
      text: TextSpan(
        text: line2,
        style: GoogleFonts.inter(
          color: Colors.white.withOpacity(0.75),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final boxW = max(tp1.width, tp2.width) + 20;
    final boxH = tp1.height + tp2.height + 14;
    double left = cx - boxW / 2;
    left = left.clamp(yAxisWidth, size.width - boxW);
    const top = 2.0;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, boxW, boxH),
      const Radius.circular(8),
    );
    canvas.drawRRect(rrect, Paint()..color = const Color(0xff1C1533));
    canvas.drawRRect(
      rrect,
      Paint()
        ..color = Colors.white.withOpacity(0.12)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1,
    );
    tp1.paint(canvas, Offset(left + 10, top + 5));
    tp2.paint(canvas, Offset(left + 10, top + 5 + tp1.height + 2));
  }

  String _shortDate(String s) {
    final d = DateTime.tryParse(s);
    if (d == null) return '';
    return '${d.day}/${d.month}';
  }

  @override
  bool shouldRepaint(covariant _MacroStackedPainter old) =>
      old.selected != selected ||
      old.days != days ||
      old.target != target;
}

/// Protein / Carbs / Fat / Target key for [MacroStackedChart].
class MacroChartLegend extends StatelessWidget {
  const MacroChartLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 18,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: [
        _item(kProteinColor, "Protein"),
        _item(kCarbsColor, "Carbs"),
        _item(kFatColor, "Fat"),
        _dashItem("Target"),
      ],
    );
  }

  Widget _item(Color c, String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(color: c, borderRadius: BorderRadius.circular(2)),
      ),
      const SizedBox(width: 6),
      Text(
        label,
        style: GoogleFonts.inter(
          color: Colors.white.withOpacity(0.7),
          fontSize: 11,
        ),
      ),
    ],
  );

  Widget _dashItem(String label) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      SizedBox(
        width: 14,
        height: 2,
        child: CustomPaint(painter: _MiniDash(color: _kTargetColor)),
      ),
      const SizedBox(width: 6),
      Text(
        label,
        style: GoogleFonts.inter(
          color: Colors.white.withOpacity(0.7),
          fontSize: 11,
        ),
      ),
    ],
  );
}

class _MiniDash extends CustomPainter {
  final Color color;
  _MiniDash({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 2;
    for (double x = 0; x < size.width; x += 5) {
      canvas.drawLine(
        Offset(x, size.height / 2),
        Offset(x + 3, size.height / 2),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MiniDash old) => false;
}
