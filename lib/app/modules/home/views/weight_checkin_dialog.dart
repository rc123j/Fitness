import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/api_client.dart';
import '../../../services/api_endpoints.dart';

class WeightCheckinDialog extends StatefulWidget {
  final double currentWeight;
  final double heightCm;
  final String gender;
  final int age;
  final Function(double newWeight)? onCompleted;

  const WeightCheckinDialog({
    super.key,
    required this.currentWeight,
    required this.heightCm,
    required this.gender,
    required this.age,
    this.onCompleted,
  });

  static Future<void> show(BuildContext context, {
    required double currentWeight,
    required double heightCm,
    required String gender,
    required int age,
    Function(double newWeight)? onCompleted,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => WeightCheckinDialog(
        currentWeight: currentWeight,
        heightCm: heightCm,
        gender: gender,
        age: age,
        onCompleted: onCompleted,
      ),
    );
  }

  @override
  State<WeightCheckinDialog> createState() => _WeightCheckinDialogState();
}

class _WeightCheckinDialogState extends State<WeightCheckinDialog> {
  late TextEditingController _weightController;
  late double _newWeight;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _newWeight = widget.currentWeight > 0 ? widget.currentWeight : 70.0;
    _weightController = TextEditingController(text: _newWeight.toStringAsFixed(1));
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  double get _computedBmi {
    final heightM = widget.heightCm / 100.0;
    if (heightM <= 0) return 22.0;
    final bmiVal = _newWeight / (heightM * 2.0);
    return (bmiVal.isNaN || bmiVal.isInfinite) ? 22.0 : bmiVal;
  }

  double get _weightDiff => _newWeight - widget.currentWeight;

  Future<void> _submitWeight() async {
    final parsed = double.tryParse(_weightController.text.trim());
    if (parsed == null || parsed <= 20 || parsed >= 300) {
      Get.snackbar('Invalid Weight', 'Please enter a valid weight between 20 kg and 300 kg.');
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final heightM = widget.heightCm / 100.0;
      final bmiVal = heightM > 0 ? parsed / (heightM * 2.0) : 22.0;
      
      // Compute BMR Mifflin-St Jeor
      final isFemale = widget.gender.toLowerCase().contains('fem');
      final bmrVal = isFemale 
        ? (10 * parsed) + (6.25 * widget.heightCm) - (5 * widget.age) - 161
        : (10 * parsed) + (6.25 * widget.heightCm) - (5 * widget.age) + 5;
      
      final tdeeVal = bmrVal * 1.375; // Moderate activity default

      final apiClient = Get.find<ApiClient>();
      
      // Call backend to regenerate Month 2 diet plan with new weight & recalculated metrics
      await apiClient.post(ApiEndpoints.generateDietPlan, data: {
        'weight_kg': parsed,
        'bmi': double.parse(bmiVal.toStringAsFixed(1)),
        'bmr': double.parse(bmrVal.toStringAsFixed(1)),
        'tdee': double.parse(tdeeVal.toStringAsFixed(1)),
        'target_calories': tdeeVal.round(),
        'protein_target': (parsed * 1.5).round(),
        'carbs_target': ((tdeeVal * 0.45) / 4).round(),
        'fat_target': ((tdeeVal * 0.25) / 9).round(),
      });

      if (mounted) {
        Navigator.of(context).pop();
        if (widget.onCompleted != null) {
          widget.onCompleted!(parsed);
        }
        Get.snackbar(
          'Month 2 Plan Generated! 🎉',
          'Your new meal plan has been updated according to your new weight.',
          duration: const Duration(seconds: 4),
          backgroundColor: const Color(0xff140E26),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update weight and generate plan: $e');
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final diffText = _weightDiff == 0
        ? "No weight change"
        : (_weightDiff < 0
            ? "${_weightDiff.abs().toStringAsFixed(1)} kg lost 🎉"
            : "+${_weightDiff.toStringAsFixed(1)} kg gained 💪");

    return Dialog(
      backgroundColor: const Color(0xff0F0B1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xffFF00E5).withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.monitor_weight_rounded,
                    color: Color(0xffFF00E5),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "30-Day Weight Check-In",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Update your weight to build Month 2 Plan",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Previous vs New Weight
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.04),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Starting Weight",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${widget.currentWeight.toStringAsFixed(1)} kg",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 1,
                    height: 36,
                    color: Colors.white.withOpacity(0.1),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        "Progress Status",
                        style: GoogleFonts.inter(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        diffText,
                        style: GoogleFonts.outfit(
                          color: const Color(0xff00E5FF),
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Input field
            Text(
              "Current Weight (kg)",
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              onChanged: (val) {
                final p = double.tryParse(val);
                if (p != null) {
                  setState(() => _newWeight = p);
                }
              },
              decoration: InputDecoration(
                suffixText: 'kg',
                suffixStyle: GoogleFonts.outfit(color: Colors.white.withOpacity(0.6)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.06),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide(color: Colors.white.withOpacity(0.12)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: Color(0xffFF00E5)),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Live Calculated BMI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recalculated BMI:",
                  style: GoogleFonts.inter(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
                Text(
                  _computedBmi.toStringAsFixed(1),
                  style: GoogleFonts.outfit(
                    color: const Color(0xffFFB800),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Submit Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitWeight,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFF00E5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Generate Month 2 Plan 🚀",
                        style: GoogleFonts.outfit(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
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
